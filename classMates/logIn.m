//
//  logIn.m
//  classMates
//
//  Created by Lee Fincher on 10/17/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "logIn.h"

@interface logIn ()

@end

@implementation logIn

@synthesize appDelegate;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_statusLabel setHidden:YES];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Login Methods

-(void)login{
    
    
    //Login user with Quickblox Authentication
    [QBRequest logInWithUserLogin:_usernameField.text password:_passwordField.text successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        
        //Show uialertview
        
        //Request to pull user information
        NSMutableDictionary *getRequest = [NSMutableDictionary new];
        [getRequest setObject:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
        
        
        NSLog(@"login success");
        NSLog(@"Now pulling from QB");

        
        [self pullFromQB:getRequest];

        
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"Error logging in");
        
        // Show uilaert view
        
        [self wrongLoginWithMessage:@"Wrong username/password"];
    }];
}




#pragma mark - UITextfield Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //Hide error message
    if (![_statusLabel isHidden]) {
        [_statusLabel setHidden:YES];
    }
    
    
    if (textField == _usernameField) {
    
    } else if (textField == _passwordField) {
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [textField resignFirstResponder];
        [self login];
    }
    return YES;
}





#pragma mark - Helper Methods

-(void)wrongLoginWithMessage:(NSString *)message{
    [_statusLabel setHidden:NO];
    [_statusLabel setText:message];
}






#pragma mark - Data Methods


-(void)pullFromOSCAR{
    
}
-(void)uploadToQB{
    
}
-(void)pullFromQB:(NSMutableDictionary *)getRequest{

    NSLog(@"pulling data from quickblox");
    
    [QBRequest objectsWithClassName:@"userData" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        appDelegate.userInfo = objects[0].fields;
        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"error pulling data from quicblox");
    }];
}





#pragma mark - Signup Methods

-(void)signUp{
    
    //Sign up/Create user on QB
    
    [self pullFromFacebook];
    
    //Then update user
}
-(void)pullFromFacebook{
    //    if ([FBSDKAccessToken currentAccessToken]) {
    //        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
    //         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    //             if (!error) {
    //                 NSLog(@"fetched user:%@", result);
    //
    //             }
    //         }];
    //    } else {
    //        NSLog(@"no current access token");
    //    }
    
    
    
    
    
    //how to get shit
    
    //    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
    //                                            requestMethod:SLRequestMethodGET
    //                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
    //                                               parameters:nil];
    //    request.account = _account; // This is the _account from your code
    //    [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //        if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
    //            NSError *deserializationError;
    //            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
    //
    //            if (userData != nil && deserializationError == nil) {
    //                NSString *email = userData[@"email"];
    //                NSLog(@"%@", email);
    //            }
    //        }
    //    }];
    
    
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
         }
     }];
}
-(void)updateUserWith:(NSString *)facebookID{
    
    QBCOCustomObject *userObject = [QBCOCustomObject customObject];
    userObject.className = @"userData";
    [userObject.fields setObject:facebookID forKey:@"facebookID"];
    userObject.ID = appDelegate.userInfo[@"ID"];
    
    [QBRequest updateObject:userObject successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        
        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

    
    
    
    
    
    
    
    
    
    
    
#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
