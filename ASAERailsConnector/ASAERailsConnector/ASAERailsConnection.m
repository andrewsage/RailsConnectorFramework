//
//  RACConnection.m
//  RailsConnector
//
//  Created by Andrew Sage on 12/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import "ASAERailsConnection.h"

static const int kTimeoutInterval = 20; // 20 seconds

// The URLs for the remote server commands
static const NSString *kRemoteCommandsSignIn = @"/users/sign_in.json";
static const NSString *kRemoteCommandsSignUp = @"/users.json";

@interface ASAERailsConnection () {
    NSInteger _networkSessions;
}
@end

@implementation ASAERailsConnection


+(ASAERailsConnection *)sharedInstance {
    static dispatch_once_t once;
    static ASAERailsConnection * sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if(self) {
        
        self.user = [[ASAERailsUser alloc] init];
        self.serverAPIBaseURL = nil;
        _networkSessions = 0;
        _debugMode = NO;
    }
    
    return self;
}

- (void)getCollectionFromServer:(NSString*)collectionClass since:(NSDate *)sinceDate {

    
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [sinceDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"];

    
    NSString *remoteCommand = [NSString stringWithFormat:@"/%@.json?since=%@",
                               collectionClass,
                               [dateFormat stringFromDate:gmtDate]];
    [self sendRemoteGETCommand:remoteCommand];
}

- (void)postCollectionToServer:(NSArray *)collectionArray collectionClass:(NSString*)collectionClass {
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    [dataDictionary setObject:collectionArray forKey:collectionClass];
    
    NSString *remoteCommand = [NSString stringWithFormat:@"/%@/batch_update.json", collectionClass];
    
    [self sendRemotePOSTCommand:remoteCommand withJSON:dataDictionary];
}

- (void)deleteFromServer:(NSString*)collectionClass objectToken:(NSString*)token {
    
    NSString *remoteCommand = [NSString stringWithFormat:@"/%@/%@.json", collectionClass, token];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAPIBaseURL, remoteCommand];
    NSMutableURLRequest *deleteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];
    
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [deleteRequest setValue:[NSString stringWithFormat:@"%@", self.user.emailAddress] forHTTPHeaderField:@"X-User-Email"];
    [deleteRequest setValue:self.authenticationToken forHTTPHeaderField:@"X-User-Token"];
    
    [self sendRequest:deleteRequest];
}

- (void)sendRemoteGETCommand:(NSString *)command {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAPIBaseURL, command];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%@", self.user.emailAddress] forHTTPHeaderField:@"X-User-Email"];
    [request setValue:self.authenticationToken forHTTPHeaderField:@"X-User-Token"];
    
    [self sendRequest:request];
}


- (void)sendRemotePOSTCommand:(NSString *)command withJSON:(NSDictionary*)jsonDictionary {
    
    //NSLog(@"Data we are going to send: %@", jsonDictionary);
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAPIBaseURL, command];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];

    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [postRequest setValue:[NSString stringWithFormat:@"%@", self.user.emailAddress] forHTTPHeaderField:@"X-User-Email"];
    [postRequest setValue:self.authenticationToken forHTTPHeaderField:@"X-User-Token"];

    
    NSError *error;    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                   options:0
                                                     error:&error];
    
    [postRequest setHTTPBody:data];
    
    [self sendRequest:postRequest];
}

- (void)sendRequest:(NSMutableURLRequest *)request {
    
    [self startNetworkTraffic];
    
    request.timeoutInterval = 240;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               [self stopNetworkTraffic];
                               
                               if(error) {
                                   NSLog(@"Connection failed: %@", error.localizedDescription);
                                   [self.delegate connectionFailed:error.localizedDescription];
                               } else {
                                   NSLog(@"We sent to: %@", response.URL);
                                   NSString *commandSent = [[response.URL absoluteString] stringByReplacingOccurrencesOfString:self.serverAPIBaseURL withString:@""];
                                   NSLog(@"Command send: %@", commandSent);
                                   NSLog(@"Connection did receive response: %@", response);

                                   NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                   NSInteger responseStatusCode = [httpResponse statusCode];
                                   
                                   if(responseStatusCode == 500) {
                                       NSLog(@"Internal Server error: response 500");
                                       [self processReceivedJSON:data forCommandSent:commandSent];

                                   } else {
                                       
                                       NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                       if(self.debugMode) {
                                           NSLog(@"Data received: %@", dataAsString);
                                       }
                                       
                                       [self processReceivedJSON:data forCommandSent:commandSent];
                                   }
                               }
                               
                           }];
}

- (void)authenticate {
    
    self.authenticationToken = nil;
    NSError *error;
    
    NSMutableDictionary *loginDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *usernamePasswordDictionary = [NSMutableDictionary dictionary];
    [usernamePasswordDictionary setObject:self.user.emailAddress forKey:@"email"];
    [usernamePasswordDictionary setObject:self.user.password forKey:@"password"];
    [loginDictionary setObject:usernamePasswordDictionary forKey:@"user"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:loginDictionary options:0 error:&error];
    
    /*
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Data we are going to send: %@", jsonDictionary);
    */
    
    NSString *postUrlString = [NSString stringWithFormat:@"%@%@", self.serverAPIBaseURL, kRemoteCommandsSignIn];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:data];
    
    [self sendRequest:request];
}

- (void)signUp:(NSString*)name email:(NSString*)emailAddress password:(NSString*)password confirmPassword:(NSString*)passwordConfirmation {
    
    self.authenticationToken = nil;
    NSError *error;
    
    NSMutableDictionary *loginDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *usernamePasswordDictionary = [NSMutableDictionary dictionary];
    [usernamePasswordDictionary setObject:emailAddress forKey:@"email"];
    [usernamePasswordDictionary setObject:name forKey:@"name"];
    [usernamePasswordDictionary setObject:password forKey:@"password"];
    [usernamePasswordDictionary setObject:passwordConfirmation forKey:@"password_confirmation"];
    [loginDictionary setObject:usernamePasswordDictionary forKey:@"user"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:loginDictionary options:0 error:&error];
    
    /*
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Data we are going to send: %@", jsonDictionary);
    */
    
    NSString *postUrlString = [NSString stringWithFormat:@"%@%@", self.serverAPIBaseURL, kRemoteCommandsSignUp];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:data];
    
    [self sendRequest:request];
}

- (void)processReceivedJSON:(id)jsonData forCommandSent:(NSString *)commandSent {
    //NSLog(@"data: %@", jsonDictionary);
    
    NSError *jsonError;
    NSArray *jsonArray = nil;
    NSDictionary *jsonDictionary = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        jsonArray = (NSArray *)jsonObject;
    }
    else {
        jsonDictionary = (NSDictionary *)jsonObject;
    }

    
    if([commandSent isEqualToString:kRemoteCommandsSignIn]) {
        
        self.authenticationToken = [jsonDictionary objectForKey:@"authentication_token"];
        if(self.authenticationToken == nil) {
            [self.delegate connectionNotAuthenticated];
        } else {
            self.user.userId = [jsonDictionary objectForKey:@"id"];
            [self.delegate connectionAuthenticationTokenSet];
        }
    } else if([commandSent isEqualToString:kRemoteCommandsSignUp]) {
        

        NSDictionary *errorDictionary = [jsonDictionary objectForKey:@"errors"];
        if(errorDictionary) {
            if([errorDictionary objectForKey:@"password"]) {
                [self.delegate connectionSignUpFailedDueTo:@"Password" message:[errorDictionary objectForKey:@"password"]];
            } else if([errorDictionary objectForKey:@"email"]) {
                [self.delegate connectionSignUpFailedDueTo:@"Email" message:[errorDictionary objectForKey:@"email"]];
            } else {
                [self.delegate connectionSignUpFailed];
            }
            NSLog(@"Sign up failed due to: %@", errorDictionary);

        } else {
            NSLog(@"sign up completed");
            self.authenticationToken = [jsonDictionary objectForKey:@"authentication_token"];
            self.user.userId = [jsonDictionary objectForKey:@"id"];
            self.user.emailAddress = [jsonDictionary objectForKey:@"email"];
            [self.delegate connectionSignUpCompleted];
        }
    } else {
        [self.delegate connectionDownloadedCollection:jsonArray
                                         inResponseTo:commandSent];
    }
}


- (void)startNetworkTraffic {
    
    if(_networkSessions == 0) {
        [self.delegate connectionNetworkStarted];
        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    _networkSessions++;
    
    //NSLog(@"Network Sessions %ld", (long)_networkSessions);
}

- (void)stopNetworkTraffic {
    
    _networkSessions--;
    
    //NSLog(@"Network Sessions %ld", (long)_networkSessions);
    
    
    if(_networkSessions == 0) {
        [self.delegate connectionNetworkEnded];
        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


@end
