//
//  logIn.m
//  classMates
//
//  Created by Lee Fincher on 10/17/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "logIn.h"


// CANNOT USE ANYMORE
static NSString * const authServer = @"https://login.gatech.edu/cas?service=";
static NSString * const courseService = @"http://dev.m.gatech.edu/api/coursecatalog/term";
static NSString * const scheduleService = @"http://dev.m.gatech.edu/api/schedule/myschedule";
static NSString * const courseCritiqueService = @"https://critique.gatech.edu";
static NSString * const seatmeService = @"http://dev.m.gatech.edu/api/seatme/buildings";
static NSString * const userCommentsService = @"http://dev.m.gatech.edu/api/usercomments/user";



@interface logIn ()

@end

@implementation logIn

@synthesize appDelegate;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_statusLabel setHidden:YES];
    
    _usernameField.alpha = 0;
    _passwordField.alpha = 0;
    [_usernameField setHidden:YES];
    [_passwordField setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Save data - Maybe make a data manager
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    
    _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;

    _logoImage.image = [UIImage imageNamed:@"Logo"];
    _logoImage.layer.cornerRadius = 10;
    _logoImage.layer.masksToBounds = YES;
    
    [_loginSwitch setOn:NO];
    
    _signUpButton.layer.cornerRadius = 5;
    _logInButton.layer.cornerRadius = 5;
    
//    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Switch Methods

- (IBAction)switchChanged:(UISwitch *)sender {
//    if ([_loginSwitch isOn]) {
//        
//        [UIView animateWithDuration:.1 animations:^{
//            _usernameField.alpha = 0;
//            _passwordField.alpha = 0;
//            _logInButton.alpha = 0;
//            
//            [_signUpButton setTitle:@"Facebook Login" forState:UIControlStateNormal];
//            
//        } completion:^(BOOL finished) {
//            [_usernameField setHidden:YES];
//            [_passwordField setHidden:YES];
//            [_logInButton setHidden:YES];
//        }];
//    } else {
//        
//        [_usernameField setHidden:NO];
//        [_passwordField setHidden:NO];
//        [_logInButton setHidden:NO];
//        
//        [UIView animateWithDuration:.1 animations:^{
//            _usernameField.alpha = 1;
//            _passwordField.alpha = 1;
//            _logInButton.alpha = 1;
//            
//            [_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
//
//        } completion:^(BOOL finished) {
//        }];
//    }
}



#pragma mark - Button Methods

- (IBAction)signUpButtonPressed:(UIButton *)sender {

    if (_fromLogIn) {
        
        [self keyboardCloser];
        [self login];
        
        //Sign up
    } else if (_fromSignUp) {
        
        [self keyboardCloser];
        [self signUp];
        
        //Go to sign up
    } else {
        
        _fromSignUp = YES;
        
        [self.usernameField becomeFirstResponder];
        
        [_usernameField setHidden:NO];
        [_passwordField setHidden:NO];
        
        [UIView animateWithDuration:.1 animations:^{
            [self.logInButton setTitle:@"Cancel" forState:UIControlStateNormal];
            _usernameField.alpha = 1;
            _passwordField.alpha = 1;
            
        }];
    }
}
- (IBAction)logInButtonPressed:(UIButton *)sender {
    
    //Cancel
    if (_fromSignUp || _fromLogIn) {
        
        [self keyboardCloser];
        
        if (![_statusLabel isHidden]) {
            [UIView animateWithDuration:.1 animations:^{
                _statusLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [_statusLabel setHidden:YES];
            }];
        }
        
        _fromSignUp = NO;
        _fromLogIn = NO;
        
        [UIView animateWithDuration:.1 animations:^{
            [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
            [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            
            _usernameField.alpha = 0;
            _passwordField.alpha = 0;
            
        } completion:^(BOOL finished) {
            [_usernameField setHidden:YES];
            [_passwordField setHidden:YES];
        }];
    
        
        //Go to log in
    } else {
        
        _fromLogIn = YES;
        
        [self.usernameField becomeFirstResponder];
        
        [_usernameField setHidden:NO];
        [_passwordField setHidden:NO];

        [UIView animateWithDuration:.1 animations:^{
            [self.logInButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.signUpButton setTitle:@"Log In" forState:UIControlStateNormal];
            
            _usernameField.alpha = 1;
            _passwordField.alpha = 1;
        }];
    }
}







#pragma mark - Login Methods

-(void)login{
    
    [_loginSpinner startAnimating];
    
    //Login user with Quickblox Authentication
    [QBRequest logInWithUserLogin:_usernameField.text password:_passwordField.text successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        
        
        NSLog(@"login success");
        NSLog(@"Now pulling from QB");
        
        
        //Request to pull user information
        NSMutableDictionary *getRequest = [NSMutableDictionary new];
        [getRequest setObject:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        [self getUserData:getRequest];
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"Error logging in");
        NSLog(@"the response is %@", response);
        
        [_loginSpinner stopAnimating];
        
        if (response.status == QBResponseStatusCodeUnAuthorized) {
            [self wrongLoginWithMessage:@"Username not found"];
        }
    }];
    

}
    
    

#pragma mark - Signup Methods

-(void)signUp{
    
    [_loginSpinner startAnimating];
    
    QBUUser *user = [QBUUser user];
    user.login = _usernameField.text;
    user.password = _passwordField.text;
    
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        
        NSLog(@"signup success!!!");
        [self login];

    } errorBlock:^(QBResponse *response) {
        
        NSLog(@"error signing up");
        NSLog(@"the error respnse is %@", response);
        
        [_loginSpinner stopAnimating];
    }];
}
    
    
    
    
    
    
#pragma mark - UITextfield Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //Hide error message
    if (![_statusLabel isHidden]) {
        [_statusLabel setHidden:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [textField resignFirstResponder];
        if (_fromLogIn) {
            [self login];
        } else if (_fromSignUp) {
            [self signUp];
        }
    }
    return YES;
}





#pragma mark - Helper Methods

-(void)wrongLoginWithMessage:(NSString *)message{
    [_statusLabel setHidden:NO];
    [_statusLabel setText:message];
}
-(void)keyboardCloser{
    if ([_usernameField isFirstResponder]) {
        [_usernameField resignFirstResponder];
    } else if ([_passwordField isFirstResponder]) {
        [_passwordField resignFirstResponder];
    }
}





#pragma mark - Data Methods

-(void)getUserData:(NSMutableDictionary *)getRequest{

    NSLog(@"pulling user data from quickblox");
    
    [QBRequest objectsWithClassName:@"userData" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        if ([objects count] > 0) {
            appDelegate.userInfo = objects[0].fields;
            [appDelegate.userInfo setObject:objects[0].ID forKey:@"ID"];
            
            [self getUserClasses:getRequest];
            
        } else {
            NSLog(@"creating user data object on quickblox");
            [self createUserData];
        }
    
    } errorBlock:^(QBResponse * _Nonnull response) {
        [_loginSpinner stopAnimating];
        NSLog(@"error pulling data from quicblox");
    }];
}
-(void)getUserClasses:(NSMutableDictionary *)getRequest{
    
    NSLog(@"pulling user classes");

    [QBRequest objectsWithClassName:@"userClasses" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        if ([objects count] > 0) {
            for (QBCOCustomObject *userClass in objects) {
                [appDelegate.myClasses addObject:userClass.fields];
                [appDelegate.myClassIDs addObject:userClass.ID];
            }
        }
        
        [self getUserMeetings:getRequest];

    } errorBlock:^(QBResponse * _Nonnull response) {
        [_loginSpinner stopAnimating];
        NSLog(@"Errorr pulling user classes");
    }];
}
-(void)getUserMeetings:(NSMutableDictionary *)getRequest{
    
    NSLog(@"pulling user meetings");

    [QBRequest objectsWithClassName:@"userMeetings" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        if ([objects count] > 0) {
            for (QBCOCustomObject *userMeeting in objects) {
                [appDelegate.myMeetings addObject:userMeeting.fields];
                [appDelegate.myMeetingIDs addObject:userMeeting.ID];
                [appDelegate.idForMeeting setObject:userMeeting.ID forKey:userMeeting.fields];
            }
        }
        [_loginSpinner stopAnimating];
        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        [_loginSpinner stopAnimating];
        NSLog(@"error pulling user meetings");
    }];
}
-(void)pullFromFacebook{

    // Get facebook account from Settings.app
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType =  [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:@"870246169748873", ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *facebookAccounts = [accountStore accountsWithAccountType:facebookAccountType];
             
             NSLog(@"facebook accounts =%@", facebookAccounts);
             
             [self updateUserWith:facebookAccounts[0]];
             
             //Save facebook acoount / upload to account
         } else {
             //Error
             NSLog(@"error getting permission %@",e);
             
             //Not logged in on phone ALERT HERE
         }
     }];
}
-(void)updateUserWith:(NSString *)facebookID{
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [loginManager logInWithReadPermissions: @[@"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                    NSLog(@"errir is %@", error);
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in %@", result);
                                    
                                    if ([FBSDKAccessToken currentAccessToken]) {
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:@{@"fields": @"id, name, friends"}]
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error) {
                                                 NSLog(@"fetched user:%@", result);
                                                
                                                 QBCOCustomObject *userObject = [QBCOCustomObject customObject];
                                                 userObject.className = @"userData";
                                                 userObject.ID = appDelegate.userInfo[@"ID"];
                                                 [userObject.fields setObject:facebookID forKey:@"facebookID"];
                                                 
                                                 [QBRequest updateObject:userObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                                                     
                                                     [_loginSpinner stopAnimating];
                                                     [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                                                     
                                                 } errorBlock:^(QBResponse *response) {
                                                     // error handling
                                                     [_loginSpinner stopAnimating];
                                                     NSLog(@"error updating user data object");
                                                     NSLog(@"Response error: %@",response);
                                                 }];

                                             } else {
                                                 NSLog(@"errir is %@", error);
                                             }
                                         }];
                                    }
                                    
                                }
                            }];
    
}
-(void)createUserData{
 
    QBCOCustomObject *userObject = [QBCOCustomObject customObject];
    userObject.className = @"userData";

    [QBRequest createObject:userObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
        
        //Save user data custom object
        appDelegate.userInfo = object.fields;
        [appDelegate.userInfo setObject:object.ID forKey:@"ID"];
        
        if ([_loginSwitch isOn]) {
            //Pull facebook data from device
            [self pullFromFacebook];
        } else {
            [_loginSpinner stopAnimating];
            [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        
        [_loginSpinner stopAnimating];
        
        NSLog(@"error creating userData object");
        NSLog(@"the response is %@", response);
    }];
}
    
    
    
    
    
    
    
    
    
    
    
#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}




@end
