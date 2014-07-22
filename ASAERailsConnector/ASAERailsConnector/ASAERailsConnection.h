//
//  RACConnection.h
//  RailsConnector
//
//  Created by Andrew Sage on 12/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASAERailsUser.h"

@class ASAERailsConnection;

@protocol ASAERailsConnectionDelegate <NSObject>
@optional

- (void)connectionNetworkStarted;
- (void)connectionNetworkEnded;
- (void)connectionFailed:(NSString*)message;
- (void)connectionNotAuthenticated;
- (void)connectionAuthenticationTokenSet;
- (void)connectionSignUpFailed;
- (void)connectionSignUpFailedDueTo:(NSString*)field message:(NSArray*)messages;
- (void)connectionSignUpCompleted;
- (void)connectionDownloadedCollection:(NSArray *)downloadedArray inResponseTo:(NSString*)remoteCommand;

@end

@interface ASAERailsConnection : NSObject

@property (nonatomic, weak) id <ASAERailsConnectionDelegate> delegate;
@property (strong, nonatomic) NSString *serverAPIBaseURL;
@property (strong, nonatomic) NSString *authenticationToken;
@property (strong, nonatomic) ASAERailsUser *user;
@property (nonatomic, assign) BOOL debugMode;

+ (ASAERailsConnection *)sharedInstance;


- (void)authenticate;
- (void)signUp:(NSString*)name email:(NSString*)emailAddress password:(NSString*)password confirmPassword:(NSString*)passwordConfirmation;

- (void)postCollectionToServer:(NSArray*)collectionArray collectionClass:(NSString*)collectionClass;
- (void)getCollectionFromServer:(NSString*)collectionClass since:(NSDate*)sinceDate;
- (void)deleteFromServer:(NSString*)collectionClass objectToken:(NSString*)token;

@end
