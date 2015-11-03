//
//  addMeetingView.h
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addMeetingViewDelegate <NSObject>

@optional
-(void)closeAddMeetingViewDidAdd:(BOOL)didAdd;
@end


@interface addMeetingView : UIView <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


//Protocol Properties
@property (strong, nonatomic) id <addMeetingViewDelegate> delegateMeetingView;


//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSString *selectedClassName;


//Text Fields
@property (strong, nonatomic) IBOutlet UITextField *dateAndTimeField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (strong, nonatomic) IBOutlet UITextField *meetingNameField;




//Button Properties
@property (strong, nonatomic) IBOutlet UIButton *doneButton;


//Button Methods
- (IBAction)doneButtonPressed:(UIButton *)sender;



//Toolbar
@property (strong, nonatomic) UIToolbar *pickerDoneBar;

//Pickers
@property (strong, nonatomic) UIPickerView *typePicker;
@property (strong, nonatomic) UIDatePicker *datePicker;



@end
