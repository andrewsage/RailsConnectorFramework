//
//  RACSignInViewController.m
//  RailsConnector
//
//  Created by Andrew Sage on 13/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import "ASAERailsSignInViewController.h"

@interface ASAERailsSignInViewController () <UITextFieldDelegate, ASAERailsConnectionDelegate, ASAERailsSignUpViewControllerDelegate> {
    NSString *emailAddress;
    NSString *password;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ASAERailsSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _backgroundColor = [UIColor whiteColor];
        self.signUpController = [[ASAERailsSignUpViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = self.backgroundColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(viewTappedGesture:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [self buildUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buildUI
{
    NSLayoutConstraint *constraint;
    
    UIImageView *imageView = nil;
    
    if(self.headerImage) {
        imageView = [[UIImageView alloc] initWithImage:self.headerImage];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:imageView];
        
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f
                                                   constant:0.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                 multiplier:1.0f
                                                   constant:50.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeTrailing
                                                 multiplier:1.0f
                                                   constant:-50.0f];
        
        [self.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:imageView
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                 multiplier:1.0f
                                                   constant:90.0f];
        
        [self.view addConstraint:constraint];
    }
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.emailTextField.placeholder = @"email address";
    self.emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.delegate = self;
    [self.view addSubview:self.emailTextField];
    
    
    constraint = [NSLayoutConstraint constraintWithItem:self.emailTextField
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.emailTextField
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-10.0f];
    
    [self.view addConstraint:constraint];
    
    if(imageView) {
        constraint = [NSLayoutConstraint constraintWithItem:self.emailTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:imageView
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0f
                                                   constant:5.0f];

        
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self.emailTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f
                                                   constant:60.0f];
    }
    
        
    [self.view addConstraint:constraint];
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    [self.view addSubview:self.passwordTextField];
    
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordTextField
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordTextField
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordTextField
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.emailTextField
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    
    
    
    
    // Sign In button
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(signInTapped) forControlEvents:UIControlEventTouchUpInside];
    [signInButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    signInButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:signInButton];
    
    constraint = [NSLayoutConstraint constraintWithItem:signInButton
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:signInButton
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordTextField
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:20.0f];
    
    [self.view addConstraint:constraint];
    
    
    // Sign Up button
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(signUpTapped) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:signUpButton];
    
    constraint = [NSLayoutConstraint constraintWithItem:signUpButton
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:signUpButton
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:-20.0f];
    
    [self.view addConstraint:constraint];
    
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    signUpLabel.text = @"Not registered?";
    signUpLabel.backgroundColor = [UIColor clearColor];
    signUpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:signUpLabel];
    
    constraint = [NSLayoutConstraint constraintWithItem:signUpLabel
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:signUpLabel
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:signUpButton
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:-20.0f];
    
    [self.view addConstraint:constraint];
    

    
    // Close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:closeButton];
    
    constraint = [NSLayoutConstraint constraintWithItem:closeButton
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:10.0f];
    [self.view addConstraint:constraint];
    
    
    
    constraint = [NSLayoutConstraint constraintWithItem:closeButton
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:10.0f];
    [self.view addConstraint:constraint];
    
    /*
     constraint = [NSLayoutConstraint constraintWithItem:closeButton
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0f
     constant:44.0f];
     [self.view addConstraint:constraint];
     
     constraint = [NSLayoutConstraint constraintWithItem:closeButton
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0f
     constant:44.0f];
     [self.view addConstraint:constraint];
     */

}

#pragma mark Actions

- (void)closeButtonTapped {
    
    [self.delegate signInViewControllerDidCancelLogIn:self];
}

- (void)signUpTapped {
    
    self.signUpController.delegate = self;
    
    [self presentViewController:self.signUpController
                       animated:YES
                     completion:NULL];

}

- (void)signInTapped {
    
    emailAddress = self.emailTextField.text;
    password = self.passwordTextField.text;
    
    if([self canStartSignIn]) {
        
        ASAERailsConnection *connection = [ASAERailsConnection sharedInstance];
        connection.user.emailAddress = emailAddress;
        connection.user.password = password;
        connection.delegate = self;
        [connection authenticate];
        
    }
}


- (BOOL)canStartSignIn {
    
    // Ensure that both fields are completed
    if(emailAddress && password && emailAddress.length != 0 && password.length != 0) {
        return YES; // Okay to being the login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    return NO;
}

#pragma mark - RACConnectionDelegate methods

- (void)connectionFailed:(NSString *)message {
    
    [[[UIAlertView alloc] initWithTitle:@"Connection to server failed"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionNotAuthenticated {
    
    NSLog(@"RACSignInViewController: Call failed as we are not logged in");
    
    [[[UIAlertView alloc] initWithTitle:@"Incorrect details"
                                message:@"The password is not correct for the email address provided"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionAuthenticationTokenSet {
    
    ASAERailsConnection *connection = [ASAERailsConnection sharedInstance];

 
    [self.delegate signInViewController:self
                           didLogInUser:connection.user];

}


#pragma mark - UITextFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self signInTapped];
    }
    
    return YES;
    
    
}


- (void)viewTappedGesture:(UITapGestureRecognizer *)sender {
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - RACSignUpViewControllerDelegate methods

- (void)signUpViewController:(ASAERailsSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    
}

- (void)signUpViewController:(ASAERailsSignUpViewController *)signUpController didSignUpUser:(ASAERailsUser *)user {
    
    ASAERailsConnection *connection = [ASAERailsConnection sharedInstance];

    [self.delegate signInViewController:self
                           didLogInUser:connection.user];
}

- (void)signUpViewControllerDidCancelSignUp:(ASAERailsSignUpViewController *)signUpController {
    
    [signUpController dismissViewControllerAnimated:YES
                                         completion:NULL];
}

- (void)connectionNetworkStarted {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)connectionNetworkEnded {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}


@end
