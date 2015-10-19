//
//  logIn.h
//  classMates
//
//  Created by Lee Fincher on 10/17/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface logIn : UIViewController <UITextFieldDelegate>



//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;



//Labels
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;



//Image Views
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;


//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end
