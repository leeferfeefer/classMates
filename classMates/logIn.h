//
//  logIn.h
//  classMates
//
//  Created by Lee Fincher on 10/17/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "schedule.h"

@interface logIn : UIViewController <UITextFieldDelegate>



//Class Properties
@property BOOL fromSignUp;
@property BOOL fromLogIn;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *sessionTicket;
@property (strong, nonatomic) NSMutableArray *friendsInClass;
@property (strong, nonatomic) NSMutableArray *friends;
@property BOOL matched;

//Spinners
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginSpinner;


//Labels
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *facebookInfoLabel;



//Image Views
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;


//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;



//Buttons
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;


//Button Methods
- (IBAction)signUpButtonPressed:(UIButton *)sender;
- (IBAction)logInButtonPressed:(UIButton *)sender;


//Switch
@property (strong, nonatomic) IBOutlet UISwitch *loginSwitch;

//Switch Methods
- (IBAction)switchChanged:(UISwitch *)sender;


@end
