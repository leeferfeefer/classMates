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
    self.layer.masksToBounds = YES;
    
    self.types = [self createTypeArray];
    self.capacities = [self createCapacityArray];
    
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];


    _locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    _meetingNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _doneButton.layer.cornerRadius = 5;
    _doneButton.layer.masksToBounds = YES;
    
    
    self.pickerDoneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 414, 44)];
    [self.pickerDoneBar setBarTintColor:[UIColor grayColor]];
    [self.pickerDoneBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDoneButtonPressed)];
    barButtonDone.tintColor = [UIColor whiteColor];
    self.pickerDoneBar.items = @[flexibleSpace, barButtonDone];

    
    self.typePicker = [[UIPickerView alloc] init];
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    self.capacityPicker = [[UIPickerView alloc] init];
    self.capacityPicker.dataSource = self;
    self.capacityPicker.delegate = self;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    [_typeField setInputView:_typePicker];
    [_typeField setInputAccessoryView:_pickerDoneBar];
    [_dateAndTimeField setInputView:_datePicker];
    [_dateAndTimeField setInputAccessoryView:_pickerDoneBar];
    [_dateAndTimeField setDelegate:self];
    [_capacityField setInputView:_capacityPicker];
    [_capacityField setInputAccessoryView:_pickerDoneBar];
}






#pragma mark - Button Methods

- (IBAction)doneButtonPressed:(UIButton *)sender {
    
    [_doneButton setEnabled:NO];
    
    if ([_locationField.text isEqualToString:@""] || [_dateAndTimeField.text isEqualToString:@""] || [_typeField.text isEqualToString:@""] || [_capacityField.text isEqualToString:@""] | [_meetingNameField.text isEqualToString:@""]) {
        [self closeMeetingViewDidAdd:NO];
    } else {
        
        [_meetingSpinner startAnimating];
        
        if (_editing) {
            if (!_changed) {
                [self closeMeetingViewDidAdd:NO];
            } else {
                QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
                meetingObject.className = @"Meetings";
                
                [meetingObject.fields setObject:_meetingNameField.text forKey:@"meetingName"];
                [meetingObject.fields setObject:_dateAndTimeField.text forKey:@"dateAndTime"];
                [meetingObject.fields setObject:_locationField.text forKey:@"location"];
                [meetingObject.fields setObject:_typeField.text forKey:@"meetingType"];
                [meetingObject.fields setObject:_selectedClassName forKey:@"className"];
                [meetingObject.fields setObject:_capacityField.text forKey:@"capacity"];
                meetingObject.ID = _selectedMeeting[@"MeetingID"];
                
                [QBRequest updateObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                    
                    meetingObject.className = @"userMeetings";
                    meetingObject.ID = appDelegate.idForMeeting[_selectedMeeting];
                    
                    [QBRequest updateObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                        
                        //Update meeting in list of meetings
                        NSUInteger index = [appDelegate.myMeetings indexOfObject:_selectedMeeting];
                        
                        [appDelegate.myMeetings replaceObjectAtIndex:index withObject:object.fields];
                        [appDelegate.idForMeeting setObject:object.ID forKey:object.fields];
                        
                        [self closeMeetingViewDidAdd:YES];
                        
                    } errorBlock:^(QBResponse * _Nonnull response) {
                        NSLog(@"ERorr trying to update user  meeting");
                    }];
                } errorBlock:^(QBResponse * _Nonnull response) {
                    NSLog(@"error trying to update meeting");
                }];
            }
        } else {
            //Add Meeting to QB
            QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
            meetingObject.className = @"Meetings";
            QBCOPermissions *permissions = [QBCOPermissions permissions];
            permissions.updateAccess = QBCOPermissionsAccessOpen;
            meetingObject.permissions = permissions;
        
            [meetingObject.fields setObject:_meetingNameField.text forKey:@"meetingName"];
            [meetingObject.fields setObject:_dateAndTimeField.text forKey:@"dateAndTime"];
            [meetingObject.fields setObject:_locationField.text forKey:@"location"];
            [meetingObject.fields setObject:_typeField.text forKey:@"meetingType"];
            [meetingObject.fields setObject:_selectedClassName forKey:@"className"];
            [meetingObject.fields setObject:_capacityField.text forKey:@"capacity"];
            [meetingObject.fields setObject:@(0) forKey:@"participants"];
            [meetingObject.fields setObject:[NSNumber numberWithInteger:appDelegate.userID] forKey:@"owner"];

            [QBRequest createObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                
                meetingObject.className = @"userMeetings";
                [meetingObject.fields setObject:object.ID forKey:@"MeetingID"];
                
                //Update user meetings on quickblox
                [QBRequest createObject:meetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                    
                    //Add meeting to list of meetings
                    [appDelegate.myMeetings addObject:object.fields];
                    [appDelegate.myMeetingIDs addObject:object.ID];
                    [appDelegate.idForMeeting setObject:object.ID forKey:object.fields];
                    
                    [self closeMeetingViewDidAdd:YES];

                } errorBlock:^(QBResponse * _Nonnull response) {
                    NSLog(@"error creating user meeting");
                }];
            } errorBlock:^(QBResponse * _Nonnull response) {
                NSLog(@"error creating meeting");
            }];
        }
    }
}



#pragma mark - UIPickerView Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _typePicker) {
        return [_types count];
    } else {
        return [_capacities count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _typePicker) {
        return _types[row];
    } else {
        return _capacities[row];
    }
}

#pragma mark - UIPickerView Delegate Methods

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    [_typeField setText:_types[row]];
//    [_typeField resignFirstResponder];
//}



#pragma mark - Bar Button Methods

-(void)pickerViewDoneButtonPressed {
    if ([_dateAndTimeField isEditing]) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy hh:mm a"];
        [_dateAndTimeField setText:[dateFormatter stringFromDate:_datePicker.date]];
        [_dateAndTimeField endEditing:YES];
    } else if ([_typeField isEditing]) {
        [_typeField setText:_types[[_typePicker selectedRowInComponent:0]]];
        [_typeField endEditing:YES];
    } else if ([_capacityField isEditing]) {
        [_capacityField setText:_capacities[[_capacityPicker selectedRowInComponent:0]]];
        [_capacityField endEditing:YES];
    }
}



#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_editing) {
        _changed = YES;
    }
    if (textField == _dateAndTimeField) {
        [_datePicker setMinimumDate:[NSDate date]];
    }
}



#pragma mark - Helper Methods

-(NSArray *)createTypeArray {
    return [NSArray arrayWithObjects:@"Homework", @"Test", @"Project", @"Other", nil];
}
-(NSArray *)createCapacityArray {
    return [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"10", @"15", @"20", @"None", nil];
}





-(void)closeMeetingViewDidAdd:(BOOL)didAdd{
    if (self.delegateMeetingView && [self.delegateMeetingView respondsToSelector:@selector(closeAddMeetingViewDidAdd:)]) {
        [_meetingSpinner stopAnimating];
        [_doneButton setEnabled:YES];
        [self.delegateMeetingView closeAddMeetingViewDidAdd:didAdd];
    }
}


@end
