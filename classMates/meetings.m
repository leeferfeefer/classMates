//
//  meetings.m
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "meetings.h"

@interface meetings ()

@end

@implementation meetings

@synthesize appDelegate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.meetings = [NSMutableArray new];
    self.meetingsToBeDeleted = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _meetingsTableView.delegate = self;
    _meetingsTableView.dataSource = self;
    _meetingsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage calendarBackgroundImage:_meetingsTableView.frame.size.height]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bar_Image"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    CGFloat spinnerWidth = 37;
    _meetingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_meetingSpinner setHidesWhenStopped:YES];
    _meetingSpinner.frame = CGRectMake(self.view.frame.size.width/2 - spinnerWidth/2, self.view.frame.size.height/2 - spinnerWidth/2, spinnerWidth, spinnerWidth);
    [_meetingsTableView addSubview:_meetingSpinner];
    [_meetingSpinner startAnimating];
    
    [self pullMeetings];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_meetings count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"meetingCell";
    meetingCell *cell = (meetingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[meetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *meetingInfo = _meetings[indexPath.row];
    
    cell.meetingNameLabel.text = meetingInfo[@"meetingName"];
    cell.meetingLocationLabel.text = meetingInfo[@"location"];
    cell.meetingTimeLabel.text = meetingInfo[@"dateAndTime"];
    cell.meetingTypeLabel.text = meetingInfo[@"meetingType"];
    
    if (![meetingInfo[@"capacity"] isEqualToString:@"None"]) {
        cell.capacityLabel.text = [NSString stringWithFormat:@"%@/%@", meetingInfo[@"participants"], meetingInfo[@"capacity"]];
    } else {
        cell.capacityLabel.text = meetingInfo[@"capacity"];
    }
    
    cell.meetingNameLabel.textColor = [UIColor whiteColor];
    cell.meetingLocationLabel.textColor = [UIColor whiteColor];
    cell.meetingTimeLabel.textColor = [UIColor whiteColor];
    cell.meetingTypeLabel.textColor = [UIColor whiteColor];
    cell.capacityLabel.textColor = [UIColor whiteColor];

    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}




#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    
    NSMutableDictionary *selectedMeeting = _meetings[indexPath.row];
    
    NSLog(@"the selcted meeting is %@", selectedMeeting);
    
    //User owns this meeting
    if ([selectedMeeting[@"owner"] integerValue] == appDelegate.userID) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"This is your meeting. Do you want to delete or edit it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
            
            [self deleteMeeting:selectedMeeting];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
            
            [self presentCreateMeetingisEdit:YES andSelectedMeeting:selectedMeeting];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        
        [alertController addAction:deleteAction];
        [alertController addAction:editAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
    
        if ([appDelegate.myMeetings containsObject:selectedMeeting]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have already joined this meeting. Do you want to unjoin?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
                [alertController dismissViewControllerAnimated:YES completion:nil];
                
                //Update meeting object
                QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
                meetingObject.className = @"Meetings";
                meetingObject.ID = selectedMeeting[@"MeetingID"];
                
                NSMutableDictionary *operators = [NSMutableDictionary new];
                [operators setObject:@(-1) forKey:@"inc[participants]"];
                
                [QBRequest updateObject:meetingObject specialUpdateOperators:operators successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                    
                    NSInteger indexOfDeletedMeeting = [appDelegate.myMeetings indexOfObject:selectedMeeting];
                    
                    [QBRequest deleteObjectWithID:[appDelegate.myMeetingIDs objectAtIndex:indexOfDeletedMeeting] className:@"userMeetings" successBlock:^(QBResponse * _Nonnull response) {
                        
                        [appDelegate.myMeetings removeObjectAtIndex:indexOfDeletedMeeting];
                        [appDelegate.myMeetingIDs removeObjectAtIndex:indexOfDeletedMeeting];
                        [appDelegate.idForMeeting removeObjectForKey:selectedMeeting];
                        
                        [self pullMeetings];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have unjoined this meeting!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    } errorBlock:^(QBResponse * _Nonnull response) {
                        NSLog(@"error deleting user meeting obejct when unjoining meeting");
                    }];
                } errorBlock:^(QBResponse * _Nonnull response) {
                    NSLog(@"error updating participants in meeting object");
                }];
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:yesAction];
            [self presentViewController:alertController animated:YES completion:nil];

        } else {
            
            //Update meeting object
            QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
            meetingObject.className = @"Meetings";
            meetingObject.ID = selectedMeeting[@"MeetingID"];
            
            NSMutableDictionary *operators = [NSMutableDictionary new];
            [operators setObject:@(1) forKey:@"inc[participants]"];
            
            [QBRequest updateObject:meetingObject specialUpdateOperators:operators successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                
                QBCOCustomObject *userMeetingObject = [QBCOCustomObject customObject];
                userMeetingObject.className = @"userMeetings";
                
                [userMeetingObject.fields setObject:selectedMeeting[@"meetingName"] forKey:@"meetingName"];
                [userMeetingObject.fields setObject:selectedMeeting[@"dateAndTime"] forKey:@"dateAndTime"];
                [userMeetingObject.fields setObject:selectedMeeting[@"location"] forKey:@"location"];
                [userMeetingObject.fields setObject:selectedMeeting[@"meetingType"] forKey:@"meetingType"];
                [userMeetingObject.fields setObject:selectedMeeting[@"capacity"] forKey:@"capacity"];
                [userMeetingObject.fields setObject:selectedMeeting[@"className"]forKey:@"className"];
                [userMeetingObject.fields setObject:selectedMeeting[@"MeetingID"]forKey:@"MeetingID"];
                NSInteger participants = [selectedMeeting[@"participants"] integerValue];
                [userMeetingObject.fields setObject:selectedMeeting[@"owner"] forKey:@"owner"];
                [userMeetingObject.fields setObject:[NSNumber numberWithInteger:++participants] forKey:@"participants"];
                
                [QBRequest createObject:userMeetingObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                    
                    [appDelegate.myMeetings addObject:object.fields];
                    [appDelegate.myMeetingIDs addObject:object.ID];
                    [appDelegate.idForMeeting setObject:object.ID forKey:object.fields];
                    
                    [self pullMeetings];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have joined this meeting!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                } errorBlock:^(QBResponse * _Nonnull response) {
                    NSLog(@"creating user meeting object error for joining meeting");
                }];
            } errorBlock:^(QBResponse *response) {
                NSLog(@"error updating MEeting obejct");
            }];
        }
    }
}



-(void)deleteMeeting:(NSMutableDictionary *)meeting {
    
    [QBRequest deleteObjectWithID:meeting[@"MeetingID"] className:@"Meetings" successBlock:^(QBResponse * _Nonnull response) {

        [QBRequest deleteObjectWithID:appDelegate.idForMeeting[meeting] className:@"userMeetings" successBlock:^(QBResponse * _Nonnull response) {

            NSUInteger deletedIndex = [appDelegate.myMeetings indexOfObject:meeting];
            //Remove meeting from list of meetings
            [appDelegate.myMeetings removeObjectAtIndex:deletedIndex];
            [appDelegate.myMeetingIDs removeObjectAtIndex:deletedIndex];
            [appDelegate.idForMeeting removeObjectForKey:meeting];

            [self pullMeetings];
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"error deleting user meeting");
        }];
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"error deleting Meeting");
    }];
}




#pragma mark - Button Methods

- (IBAction)addMeetingButtonPressed:(UIBarButtonItem *)sender {
    _addMeetingButton.enabled = NO;
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self presentCreateMeetingisEdit:NO andSelectedMeeting:nil];
}






#pragma mark - Create Meeting Methods

-(void)presentCreateMeetingisEdit:(BOOL)edit andSelectedMeeting:(NSMutableDictionary *)meeting{
    
    _meetingsTableView.userInteractionEnabled = NO;
    
    CGFloat meetingViewWidth = 350;
    CGFloat meetingViewHeight = 230;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"addMeetingView" owner:self options:nil];
    self.meetingView = [[addMeetingView alloc] init];
    self.meetingView = [nibContents lastObject];
    self.meetingView.frame = CGRectMake(self.view.frame.size.width/2 - meetingViewWidth/2, self.view.frame.size.height, meetingViewWidth, meetingViewHeight);
    self.meetingView.delegateAddMeetingView = self;
    self.meetingView.selectedClassName = _selectedClass[@"className"];
    
    //Fill in data
    if (edit) {
        self.meetingView.selectedMeeting = meeting;
        self.meetingView.editing = YES;
        
        self.meetingView.meetingNameField.text = meeting[@"meetingName"];
        self.meetingView.typeField.text = meeting[@"meetingType"];
        self.meetingView.dateAndTimeField.text = meeting[@"dateAndTime"];
        self.meetingView.locationField.text = meeting[@"location"];
        self.meetingView.capacityField.text = meeting[@"capacity"];
    } else {
        self.meetingView.editing = NO;
    }
    
    [self.view addSubview:_meetingView];
    
    CGRect newFrame = _meetingView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _meetingView.frame.size.height/2);
    [UIView animateWithDuration:.3 animations:^{
        _meetingView.frame = newFrame;
    }];
}

#pragma mark - Create Meeting View Delegate Methods

-(void)closeAddMeetingViewDidAdd:(BOOL)didAdd{
    if (didAdd) {
        [self pullMeetings];
    }
    CGRect newFrame = _meetingView.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        _meetingView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self.meetingView removeFromSuperview];
        self.meetingView = nil;
        _addMeetingButton.enabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        _meetingsTableView.userInteractionEnabled = YES;
    }];
}




#pragma mark - Helper Methods

-(void)pullMeetings{
    [_meetings removeAllObjects];
    
    //Retreive all meetings with class name
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:_selectedClass[@"className"] forKey:@"className"];
    
    [QBRequest objectsWithClassName:@"Meetings" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy hh:mm a"];
        
        if ([objects count] > 0) {
            for (QBCOCustomObject *meeting in objects) {
                if ([[dateFormatter dateFromString:meeting.fields[@"dateAndTime"]] timeIntervalSinceReferenceDate] < [[NSDate date] timeIntervalSinceReferenceDate]) {
                    [_meetingsToBeDeleted addObject:meeting.ID];
                } else {
                    [meeting.fields setObject:meeting.ID forKey:@"MeetingID"];
                    [_meetings addObject:meeting.fields];
                }
            }
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"There are no meetings yet! Tap the 'Add Meeting' button at the top to be the first!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [_meetingsTableView reloadData];
        [_meetingSpinner stopAnimating];
        
        if ([_meetingsToBeDeleted count] > 0) {
            [self deleteMeetings];
        }
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        [_meetingSpinner stopAnimating];
        NSLog(@"error pulling meeting data");
    }];
}
-(void)deleteMeetings{
    [QBRequest deleteObjectsWithIDs:_meetingsToBeDeleted className:@"Meetings" successBlock:^(QBResponse * _Nonnull response, NSArray<NSString *> * _Nullable deletedObjectsIDs, NSArray<NSString *> * _Nullable notFoundObjectsIDs, NSArray<NSString *> * _Nullable wrongPermissionsObjectsIDs) {
        [_meetingsToBeDeleted removeAllObjects];
        NSLog(@"the meetings were deleted :)");
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"could not delete the meetings");
    }];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
