//
//  RACSignInViewController.h
//  RailsConnector
//
//  Created by Andrew Sage on 13/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAERailsUser.h"
#import "ASAERailsConnection.h"
#import "ASAERailsSignUpViewController.h"


@class ASAERailsSignInViewController;

@protocol ASAERailsSignInViewControllerDelegate <NSObject>
@optional

- (BOOL)signInViewController:(ASAERailsSignInViewController *)signInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password;

/// Sent to the delegate when a ASAERailsUser is logged in.
- (void)signInViewController:(ASAERailsSignInViewController *)signInController didLogInUser:(ASAERailsUser *)user;

/// Sent to the delegate when the log in attempt fails.
- (void)signInViewController:(ASAERailsSignInViewController *)signInController didFailToLogInWithError:(NSError *)error;

/// Sent to the delegate when the log in screen is dismissed.
- (void)signInViewControllerDidCancelLogIn:(ASAERailsSignInViewController *)signInController;
@end


@interface ASAERailsSignInViewController : UIViewController

@property (nonatomic, weak) id <ASAERailsSignInViewControllerDelegate> delegate;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (nonatomic, strong) ASAERailsSignUpViewController *signUpController;
@property (nonatomic, strong) UIImage *headerImage;

@end
