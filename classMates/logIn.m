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

//Other api call that may be the oen
static NSString *const other = @"http://m.gatech.edu/w/schedule/c/api/";
//http://m.gatech.edu/widget/gtplaces/content/api/buildings
//http://m.gatech.edu/widget/coursecatalog/content/api/term



@interface logIn ()

@end

@implementation logIn

@synthesize appDelegate;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [_statusLabel setHidden:YES];
    
    
    //State Restoration
//    [self handleSession];
    
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
    
    _logInButton.enabled = NO;
    _signUpButton.enabled = NO;
    [_loginSpinner startAnimating];
    
    //Login user with Quickblox Authentication
    [QBRequest logInWithUserLogin:_usernameField.text password:_passwordField.text successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        
        NSLog(@"login success");
        NSLog(@"Now pulling from QB");
        
        appDelegate.userID = user.ID;

        [self saveSession];
        
        //Request to pull user information
        NSMutableDictionary *getRequest = [NSMutableDictionary new];
        [getRequest setObject:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        [self getUserClasses:getRequest];
        
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"Error logging in");
        NSLog(@"the response is %@", response);
        
        _logInButton.enabled = YES;
        _signUpButton.enabled = YES;
        [_loginSpinner stopAnimating];

        if (response.status == QBResponseStatusCodeUnAuthorized) {
            [self wrongLoginWithMessage:@"Username not found"];
        }
    }];
}
    
    

#pragma mark - Signup Methods

-(void)signUp{
    
    _logInButton.enabled = NO;
    _signUpButton.enabled = NO;
    [_loginSpinner startAnimating];
    
    QBUUser *user = [QBUUser user];
    user.login = _usernameField.text;
    user.password = _passwordField.text;
    
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        
        NSLog(@"signup success!!!");
        [self login];

    } errorBlock:^(QBResponse *response) {
        
        NSLog(@"the errors are %@", response.error.reasons[@"errors"]);

        
        _logInButton.enabled = YES;
        _signUpButton.enabled = YES;
        [_loginSpinner stopAnimating];
    
        if (response.status == QBResponseStatusCodeValidationFailed) {
            [self wrongLoginWithMessage:@"Username already taken"];
        }
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

-(void)getUserClasses:(NSMutableDictionary *)getRequest{
    
    NSLog(@"pulling user classes");

    [QBRequest objectsWithClassName:@"userClasses" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        if ([objects count] > 0) {
            for (QBCOCustomObject *userClass in objects) {
                [appDelegate.myClasses addObject:userClass.fields];
//                [appDelegate.myClassIDs addObject:userClass.ID];
            }
        }
        
        NSLog(@"the classes are %@", objects);
        
        [self getUserMeetings:getRequest];

    } errorBlock:^(QBResponse * _Nonnull response) {
        _logInButton.enabled = YES;
        _signUpButton.enabled = YES;
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
        
        if ([_loginSwitch isOn]) {
            NSLog(@"pulling from facebook");
            [self pullFromFacebook];
        } else {
            [_loginSpinner stopAnimating];
            [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        }
        
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        _logInButton.enabled = YES;
        _signUpButton.enabled = YES;
        [_loginSpinner stopAnimating];
        NSLog(@"error pulling user meetings");
    }];
}





#pragma mark - Facebook Methods

-(void)pullFromFacebook{
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [loginManager logInWithReadPermissions:@[@"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                    NSLog(@"errir is %@", error);
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    FBSDKGraphRequest *meRequest = [[FBSDKGraphRequest alloc]
                                                                  initWithGraphPath:@"/me"
                                                                  parameters:@{@"fields": @"id, name"}
                                                                  HTTPMethod:@"GET"];
                                    [meRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                          id meResult,
                                                                          NSError *meError) {
                                        if (!meError) {
                                            FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc]
                                                                                 initWithGraphPath:@"/me/friends?limit=5000"
                                                                                 parameters:@{@"fields": @"id, name"}
                                                                                 HTTPMethod:@"GET"];
                                            [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                                         id friendResult,
                                                                                         NSError *friendError) {
                                                
                                                if (!friendError) {
                                                    NSString *me = [NSString stringWithFormat:@"%@ - %@", meResult[@"name"], meResult[@"id"]];
                                                    
                                                    for (NSMutableDictionary *friend in friendResult[@"data"]) {
                                                        NSString *friendInfo = [NSString stringWithFormat:@"%@ - %@", friend[@"name"], friend[@"id"]];
                                                        [appDelegate.friends addObject:friendInfo];
                                                    }
                                                    
                                                    
                                                    [appDelegate.userInfo setObject:me forKey:@"facebookID"];
                                                    
                                                    NSLog(@"me is %@", me);
                                                    NSLog(@"friends are %@", appDelegate.friends);
                                                    
                                                    if ([appDelegate.friends count] > 0) {
                                                        //Pull all facebook friend's classes
                                                        [self pullFacebookFriendsClasses];
                                                    } else {
                                                        [_loginSpinner stopAnimating];
                                                        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                                                    }
                                                } else {
                                                    NSLog(@"the error retrieving friends is %@", friendError);
                                                    _logInButton.enabled = YES;
                                                    _signUpButton.enabled = YES;
                                                    [_loginSpinner stopAnimating];
                                                }
                                            }];
                                        } else {
                                            NSLog(@"the error retrieving me is %@", meError);
                                            _logInButton.enabled = YES;
                                            _signUpButton.enabled = YES;
                                            [_loginSpinner stopAnimating];
                                        }
                                    }];
                                }
                            }];
    
}





    
    
    
-(void)pullFacebookFriendsClasses{
    NSLog(@"pulling from facebook classes");
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];

    int counter = 0;
    for (NSString *friend in appDelegate.friends) {
        counter++;
        
        [getRequest setObject:friend forKey:@"facebookID"];
        
        [QBRequest objectsWithClassName:@"userClasses" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
            
            NSLog(@"the pulled friends classes are %@", objects);
            
            for (QBCOCustomObject *friendClassObject in objects) {
                [appDelegate.friendClasses addObject:friendClassObject.fields];
            }
            if (counter == [appDelegate.friends count]) {
                [self matchClasses];
            }
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"could not retrieve classes with friend %@", friend);
        }];
    }
}

-(void)matchClasses{
    
    NSLog(@"matching classes");
    
    NSLog(@"the friend classes are %@", appDelegate.friendClasses);
    
    for (NSMutableDictionary *friendClass in appDelegate.friendClasses) {
        for (NSMutableDictionary *myClass in appDelegate.myClasses) {
            if ([myClass[@"className"] isEqualToString:friendClass[@"className"]]) {
                
                NSLog(@"my classname is %@ and friends class name is %@", myClass[@"className"], friendClass[@"className"]);
                
                if (myClass[@"friends"] == nil) {
                    self.friendsInClass = [NSMutableArray new];
                    self.matched = YES;
                }
                [self.friendsInClass addObject:friendClass[@"facebookID"]];

                [myClass setObject:self.friendsInClass forKey:@"friends"];
            }
        }
    }
    
    [_loginSpinner stopAnimating];
    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
}






#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (_matched) {
        schedule *schedClass = [segue destinationViewController];
        schedClass.matched = YES;
    }
}






#pragma mark - State Restoration

-(void)saveSession{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[QBSession currentSession]] forKey:@"session"];
}
-(QBSession *)getSession{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"session"]];
}

-(void)saveAppDelegate{
    NSMutableDictionary *delegate = [NSMutableDictionary new];
    [delegate setObject:appDelegate.myClasses forKey:@"myClasses"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:delegate] forKey:@"appDelegate"];
}
-(NSMutableDictionary *)getAppDelegate{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"appDelegate"]];
}



-(void)handleSession{
    //If token is valid
    if ([self getSession].tokenValid) {
        
        NSLog(@"the app delegate is %@", [self getAppDelegate]);
//        
//        appDelegate = [self getAppDelegate];
        
//        appDelegate.myClasses = [self getAppDelegate].myClasses;
//        appDelegate.myMeetings = [self getAppDelegate].myMeetings;
//        appDelegate.myMeetingIDs = [self getAppDelegate].myMeetingIDs;
//        appDelegate.myClasses = [self getAppDelegate].myClasses;

        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
    }
}
@end
