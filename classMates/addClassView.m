//
//  addClassView.m
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "addClassView.h"


@implementation addClassView

@synthesize appDelegate;

-(void)didMoveToSuperview{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;


    [self.closeButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    _closeButton.layer.cornerRadius = 5;
    _closeButton.layer.masksToBounds = YES;
    
    _courseNumberField.delegate = self;
    _departmentField.delegate = self;
    
    self.departments = [self createDepartmentArray];
    self.weeklyOccurrences = [self createOccurenceArray];
    
    self.departmentPicker = [[UIPickerView alloc] init];
    self.departmentPicker.dataSource = self;
    self.departmentPicker.delegate = self;
    self.weeklyOccurencePicker = [[UIPickerView alloc] init];
    self.weeklyOccurencePicker.dataSource = self;
    self.weeklyOccurencePicker.delegate = self;
    
    
    self.pickerDoneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 414, 44)];
    [self.pickerDoneBar setBarTintColor:[UIColor grayColor]];
    [self.pickerDoneBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDoneButtonPressed)];
    barButtonDone.tintColor = [UIColor whiteColor];
    self.pickerDoneBar.items = @[flexibleSpace, barButtonDone];

    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    [_departmentField setInputView:_departmentPicker];
    [_weeklyOccurenceField setInputView:_weeklyOccurencePicker];

    [_timeStartField setInputView:_datePicker];
    [_timeStartField setInputAccessoryView:_pickerDoneBar];
    [_timeEndField setInputView:_datePicker];
    [_timeEndField setInputAccessoryView:_pickerDoneBar];
    [_departmentField setInputAccessoryView:_pickerDoneBar];
    [_weeklyOccurenceField setInputAccessoryView:_pickerDoneBar];
}



#pragma mark - Button Methods

-(void)doneButtonPressed{
    
    //Redo!!!
    if ([_courseNumberField.text isEqualToString:@""] || [_departmentField.text isEqualToString:@""]) {
        if (self.delegateClassView && [self.delegateClassView respondsToSelector:@selector(closeAddClassViewDidAdd:)]) {
            [self.delegateClassView closeAddClassViewDidAdd:NO];
        }
    } else {
     
        //Add Class to QB
        QBCOCustomObject *classObject = [QBCOCustomObject customObject];
        classObject.className = @"userClasses";
        
        [classObject.fields setObject:[NSString stringWithFormat:@"%@ - %@", _departmentField.text, _courseNumberField.text] forKey:@"className"];
        [classObject.fields setObject:_timeStartField.text forKey:@"timeStart"];
        [classObject.fields setObject:_timeEndField.text forKey:@"timeEnd"];
        [classObject.fields setObject:_weeklyOccurenceField.text forKey:@"weeklyOccurrence"];
        [classObject.fields setObject:appDelegate.userInfo[@"facebookID"] forKey:@"facebookID"];
        
        [QBRequest createObject:classObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
            
            [appDelegate.myClasses addObject:object.fields];
//            [appDelegate.myClassIDs addObject:object.ID];
            
            if (self.delegateClassView && [self.delegateClassView respondsToSelector:@selector(closeAddClassViewDidAdd:)]) {
                [self.delegateClassView closeAddClassViewDidAdd:YES];
            }
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"error creating class object");
        }];
    }
}



#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _courseNumberField) {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }
    return YES;
}


#pragma mark - UIPickerView Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _departmentPicker) {
        return [_departments count];
    } else {
        return [_weeklyOccurrences count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _departmentPicker) {
        return _departments[row];
    } else {
        return _weeklyOccurrences[row];
    }
}

#pragma mark - UIPickerView Delegate Methods





#pragma mark - Bar Button Methods

-(void)pickerViewDoneButtonPressed {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    if ([_timeStartField isEditing]) {
        [_timeStartField setText:[dateFormatter stringFromDate:_datePicker.date]];
        [_timeStartField endEditing:YES];

    } else if ([_timeEndField isEditing]) {
        [_timeEndField setText:[dateFormatter stringFromDate:_datePicker.date]];
        [_timeEndField endEditing:YES];
    } else if ([_departmentField isEditing]) {
        [_departmentField setText:_departments[[_departmentPicker selectedRowInComponent:0]]];
        [_departmentField endEditing:YES];
    } else if ([_weeklyOccurenceField isEditing]) {
        [_weeklyOccurenceField setText:_weeklyOccurrences[[_weeklyOccurencePicker selectedRowInComponent:0]]];
        [_weeklyOccurenceField endEditing:YES];
    }
}



#pragma mark - Helper Methods

-(NSArray *)createDepartmentArray{
    return [NSArray arrayWithObjects:@"ACCT",@"AERO",@"AE",@"AS",@"APPH",@"ASE",@"ARBC",@"ARCH",@"BIOL",@"BMEJ",
            @"BMED",
            @"BMEM",
            @"BC",
            @"CETL",
            @"CHBE",
            @"CHEM",
            @"CHIN",
            @"CP",
            @"CEE",
            @"COA",
            @"COE",
            @"CX",
            @"CSE",
            @"CS",
            @"COOP",
            @"UCGA",
            @"EAS",
            @"ECON",
            @"ECE",
            @"ENGL",
            @"ENTR",
            @"FS",
            @"FREN",
            @"GT",
            @"GTL",
            @"GRMN",
            @"HPS",
            @"HP",
            @"HS",
            @"HIN",
            @"HIST",
            @"HTS",
            @"ISYE",
            @"ID",
            @"IPCO",
            @"IPIN",
            @"IPFS",
            @"IPSA",
            @"INTA",
            @"IL",
            @"INTN",
            @"IMBA",
            @"JAPN",
            @"KOR",
            @"LATN",
            @"LS",
            @"LING",
            @"LCC",
            @"MGT",
            @"MOT",
            @"MSE",
            @"MATH",
            @"ME",
            @"MP",
            @"MSL",
            @"ML",
            @"MUSI",
            @"NS",
            @"NRE",
            @"PERS",
            @"PHIL",
            @"PHYS",
            @"POL",
            @"PTFE",
            @"DOPP",
            @"PSYC",
            @"PSY",
            @"PUBP",
            @"PUBJ",
            @"RGTR",
            @"RGTE",
            @"RUSS",
            @"SCI",
            @"SOC",
            @"SPAN" , nil];
}
-(NSArray *)createOccurenceArray{
    return [NSArray arrayWithObjects:@"MWF", @"MW", @"TTH", @"M", @"T", @"W", @"TH", @"F", nil];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
