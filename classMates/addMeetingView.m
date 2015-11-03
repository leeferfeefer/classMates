//
//  addMeetingView.m
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "addMeetingView.h"

@implementation addMeetingView

@synthesize appDelegate;

-(void)didMoveToSuperview{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.layer.cornerRadius = 10;

    self.backgroundColor = [UIColor grayColor];
    
    self.types = [self createTypeArray];
    
    self.typePicker = [[UIPickerView alloc] init];
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;


    _locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    _meetingNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.pickerDoneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 414, 44)];
    [self.pickerDoneBar setBarTintColor:[UIColor grayColor]];
    [self.pickerDoneBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDoneButtonPressed)];
    barButtonDone.tintColor = [UIColor whiteColor];
    self.pickerDoneBar.items = @[flexibleSpace, barButtonDone];

    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    [_typeField setInputView:_typePicker];
    
    [_dateAndTimeField setInputView:_datePicker];
    [_dateAndTimeField setInputAccessoryView:_pickerDoneBar];
}






#pragma mark - Button Methods

- (IBAction)doneButtonPressed:(UIButton *)sender {
    if ([_locationField.text isEqualToString:@""] || [_dateAndTimeField.text isEqualToString:@""] || [_typeField.text isEqualToString:@""]) {
        if (self.delegateMeetingView && [self.delegateMeetingView respondsToSelector:@selector(closeAddMeetingViewDidAdd:)]) {
            [self.delegateMeetingView closeAddMeetingViewDidAdd:NO];
        }
    } else {
        
        //Add Meeting to QB
        QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
        meetingObject.className = @"Meetings";
    
        [meetingObject.fields setObject:_meetingNameField.text forKey:@"meetingName"];
        [meetingObject.fields setObject:_dateAndTimeField.text forKey:@"dateAndTime"];
        [meetingObject.fields setObject:_locationField.text forKey:@"location"];
        [meetingObject.fields setObject:_typeField.text forKey:@"meetingType"];
        [meetingObject.fields setObject:_selectedClassName forKey:@"className"];

        [QBRequest createObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
            
            meetingObject.className = @"userMeetings";
            
            //Update user meetings on quickblox
            [QBRequest createObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                
                //Add meeting to list of meetings
                [appDelegate.myMeetings addObject:object.fields];
                [appDelegate.myMeetingIDs addObject:object.ID];
                [appDelegate.idForMeeting setObject:object.ID forKey:object.fields];
                
                if (self.delegateMeetingView && [self.delegateMeetingView respondsToSelector:@selector(closeAddMeetingViewDidAdd:)]) {
                    [self.delegateMeetingView closeAddMeetingViewDidAdd:YES];
                }

            } errorBlock:^(QBResponse * _Nonnull response) {
                NSLog(@"error creating user meeting");
            }];
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"error creating meeting");
        }];
    }
}


#pragma mark - UIPickerView Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_types count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _types[row];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_typeField setText:_types[row]];
    [_typeField resignFirstResponder];
}



#pragma mark - Bar Button Methods

-(void)pickerViewDoneButtonPressed {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy hh:mm a"];
    
    if ([_dateAndTimeField isEditing]) {
        [_dateAndTimeField setText:[dateFormatter stringFromDate:_datePicker.date]];
        [_dateAndTimeField endEditing:YES];
    }
}



#pragma mark - Helper Methods

-(NSArray *)createTypeArray {
    return [NSArray arrayWithObjects:@"Homework", @"Test", @"Project", @"Other", nil];
}

@end
