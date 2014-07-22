//
//  RACUser.h
//  RailsConnector
//
//  Created by Andrew Sage on 13/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAERailsUser : NSObject

@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *userId;

@end
