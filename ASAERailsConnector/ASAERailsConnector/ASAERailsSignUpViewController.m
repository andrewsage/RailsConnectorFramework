//
//  RACSignUpViewController.m
//  RailsConnector
//
//  Created by Andrew Sage on 14/06/2014.
//  Copyright (c) 2014 ASAE. All rights reserved.
//

#import "ASAERailsSignUpViewController.h"

@interface ASAERailsSignUpViewController () <UITextFieldDelegate, ASAERailsConnectionDelegate> {
    NSString *name;
    NSString *emailAddress;
    NSString *password;
    NSString *passwordConfirm;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmTextField;


@end

@implementation ASAERailsSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _backgroundColor = [UIColor whiteColor];

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

    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextField.placeholder = @"name";
    self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.delegate = self;
    [self.view addSubview:self.nameTextField];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.nameTextField
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.nameTextField
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-10.0f];
    
    [self.view addConstraint:constraint];
    
    if(imageView) {
        constraint = [NSLayoutConstraint constraintWithItem:self.nameTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:imageView
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0f
                                                   constant:5.0f];
        
    } else {
        constraint = [NSLayoutConstraint constraintWithItem:self.nameTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f
                                                   constant:60.0f];
        
    }
    
    [self.view addConstraint:constraint];

    
    
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
    
    constraint = [NSLayoutConstraint constraintWithItem:self.emailTextField
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.nameTextField
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
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
    
    
    self.passwordConfirmTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordConfirmTextField.secureTextEntry = YES;
    self.passwordConfirmTextField.placeholder = @"confirm password";
    self.passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordConfirmTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordConfirmTextField.returnKeyType = UIReturnKeyDone;
    self.passwordConfirmTextField.delegate = self;
    [self.view addSubview:self.passwordConfirmTextField];
    
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordConfirmTextField
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordConfirmTextField
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-10.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.passwordConfirmTextField
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordTextField
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:10.0f];
    
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
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordConfirmTextField
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:20.0f];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewTappedGesture:(UITapGestureRecognizer *)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordConfirmTextField resignFirstResponder];
}

- (void)closeButtonTapped {
    
    [self.delegate signUpViewControllerDidCancelSignUp:self];
}

- (void)signUpTapped {
    
    name = self.nameTextField.text;
    emailAddress = self.emailTextField.text;
    password = self.passwordTextField.text;
    passwordConfirm = self.passwordConfirmTextField.text;
    
    if([self canStartSignUp]) {
        
        ASAERailsConnection *connection = [ASAERailsConnection sharedInstance];
        connection.user.emailAddress = emailAddress;
        connection.user.password = password;
        connection.delegate = self;
        [connection signUp:name
                          email:emailAddress
                       password:password
                confirmPassword:passwordConfirm];
        
    }
}


- (BOOL)canStartSignUp {
    
    // Ensure that both fields are completed
    if([passwordConfirm isEqualToString:password] == NO) {
        
        [[[UIAlertView alloc] initWithTitle:@"Confirm Password Incorrect"
                                    message:@"Make sure the confirm password matches the password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];

        return NO;
    }
    
    if(name && emailAddress && password && name.length != 0 && emailAddress.length != 0 && password.length != 0) {
        return YES; // Okay to being the login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    return NO;
}

#pragma mark - UITextFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordConfirmTextField becomeFirstResponder];
    } else if (textField == self.passwordConfirmTextField) {
        
        [self.passwordConfirmTextField resignFirstResponder];
        
        [self signUpTapped];
    }
    
    return YES;
}

#pragma mark - RACConnectionDelegate methods

- (void)connectionFailed:(NSString *)message {
    
    [[[UIAlertView alloc] initWithTitle:@"Connection to server failed"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionSignUpFailed {
    
    [[[UIAlertView alloc] initWithTitle:@"Sign Up Failed"
                                message:@"The registration process failed"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionSignUpFailedDueTo:(NSString *)field message:(NSArray *)messages {

    NSMutableString *errorMessage = [NSMutableString stringWithString:field];
    for(NSString *message in messages) {
        [errorMessage appendString:@" "];
        [errorMessage appendString:message];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Sign Up Failed"
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionSignUpCompleted {
    
    [self.delegate signUpViewController:self
                          didSignUpUser:NULL];
    
}

- (void)connectionNetworkStarted {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)connectionNetworkEnded {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}



@end
