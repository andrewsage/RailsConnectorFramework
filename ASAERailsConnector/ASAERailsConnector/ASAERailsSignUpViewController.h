//
//  RACSignUpViewController.h
//  RailsConnector
//
//  Created by Andrew Sage on 14/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAERailsConnection.h"
#import "ASAERailsUser.h"

@class ASAERailsSignUpViewController;

@protocol ASAERailsSignUpViewControllerDelegate <NSObject>
@optional

/// Sent to the delegate when a RACUser is signed up.
- (void)signUpViewController:(ASAERailsSignUpViewController *)signUpController didSignUpUser:(ASAERailsUser *)user;

/// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(ASAERailsSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error;

/// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(ASAERailsSignUpViewController *)signUpController;
@end

@interface ASAERailsSignUpViewController : UIViewController

@property (nonatomic, weak) id <ASAERailsSignUpViewControllerDelegate> delegate;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *headerImage;

@end
