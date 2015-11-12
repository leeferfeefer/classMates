//
//  addClassView.h
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol classViewDelegate <NSObject>

@optional
-(void)closeAddClassView;
@end


@interface addClassView : UIView <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


//Protocol Properties
@property (strong, nonatomic) id <classViewDelegate> delegateClassView;


//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSArray *departments;
@property (strong, nonatomic) NSArray *weeklyOccurrences;





//Text Field Properties
@property (strong, nonatomic) IBOutlet UITextField *departmentField;
@property (strong, nonatomic) IBOutlet UITextField *courseNumberField;
@property (strong, nonatomic) IBOutlet UITextField *timeStartField;
@property (strong, nonatomic) IBOutlet UITextField *timeEndField;
@property (strong, nonatomic) IBOutlet UITextField *weeklyOccurenceField;





//Tool Bar Properties
@property (nonatomic, strong) UIToolbar *pickerDoneBar;

//Picker Views
@property (strong, nonatomic) UIPickerView *departmentPicker;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *weeklyOccurencePicker;


//Button Properties
@property (strong, nonatomic) IBOutlet UIButton *closeButton;





@end
