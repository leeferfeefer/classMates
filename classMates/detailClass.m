//
//  detailClass.m
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "detailClass.h"

@interface detailClass ()

@end

@implementation detailClass

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
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
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
    
    cell.meetingNameLabel.text = _meetings[indexPath.row][@"meetingName"];
    cell.meetingLocationLabel.text = _meetings[indexPath.row][@"location"];
    cell.meetingTimeLabel.text = _meetings[indexPath.row][@"dateAndTime"];
    cell.meetingTypeLabel.text = _meetings[indexPath.row][@"meetingType"];
    
    if (![_meetings[indexPath.row][@"capacity"] isEqualToString:@"None"]) {
        cell.capacityLabel.text = [NSString stringWithFormat:@"%@/%@", _meetings[indexPath.row][@"participants"], _meetings[indexPath.row][@"capacity"]];
    } else {
        cell.capacityLabel.text = _meetings[indexPath.row][@"capacity"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //User owns this meeting
    if ([_meetings[indexPath.row][@"owner"] integerValue] == appDelegate.userID) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"This is your meeting. Do you want to edit it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
            
            [self presentCreateMeetingisEdit:YES andSelectedMeeting:_meetings[indexPath.row]];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        NSMutableDictionary *tempMeeting = [NSMutableDictionary new];
        tempMeeting = _meetings[indexPath.row];
        [tempMeeting removeObjectForKey:@"owner"];
        
        NSLog(@"the selected meeting is %@", _meetings[indexPath.row]);
        
        
        if ([appDelegate.myMeetings containsObject:tempMeeting]) {
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
                meetingObject.ID = _meetings[indexPath.row][@"MeetingID"];
                
                NSMutableDictionary *operators = [NSMutableDictionary new];
                [operators setObject:@(-1) forKey:@"inc[participants]"];
                
                [QBRequest updateObject:meetingObject specialUpdateOperators:operators successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                    
                    NSInteger indexOfDeletedMeeting = [appDelegate.myMeetings indexOfObject:tempMeeting];
                    
                    [QBRequest deleteObjectWithID:[appDelegate.myMeetingIDs objectAtIndex:indexOfDeletedMeeting] className:@"userMeetings" successBlock:^(QBResponse * _Nonnull response) {
                        
                        [appDelegate.myMeetings removeObjectAtIndex:indexOfDeletedMeeting];
                        [appDelegate.myMeetingIDs removeObjectAtIndex:indexOfDeletedMeeting];
                        [appDelegate.idForMeeting removeObjectForKey:tempMeeting];
                        
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
            meetingObject.ID = _meetings[indexPath.row][@"MeetingID"];
            
            NSMutableDictionary *operators = [NSMutableDictionary new];
            [operators setObject:@(1) forKey:@"inc[participants]"];
            
            [QBRequest updateObject:meetingObject specialUpdateOperators:operators successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                
                QBCOCustomObject *userMeetingObject = [QBCOCustomObject customObject];
                userMeetingObject.className = @"userMeetings";
                
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"meetingName"] forKey:@"meetingName"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"dateAndTime"] forKey:@"dateAndTime"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"location"] forKey:@"location"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"meetingType"] forKey:@"meetingType"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"capacity"] forKey:@"capacity"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"className"]forKey:@"className"];
                [userMeetingObject.fields setObject:_meetings[indexPath.row][@"MeetingID"]forKey:@"MeetingID"];
                NSInteger participants = [_meetings[indexPath.row][@"participants"] integerValue];
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






#pragma mark - Button Methods

- (IBAction)addMeetingButtonPressed:(UIBarButtonItem *)sender {
    _addMeetingButton.enabled = NO;
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self presentCreateMeetingisEdit:NO andSelectedMeeting:nil];
}






#pragma mark - Create Meeting Methods

-(void)presentCreateMeetingisEdit:(BOOL)edit andSelectedMeeting:(NSMutableDictionary *)meeting{
    
    CGFloat meetingViewWidth = 350;
    CGFloat meetingViewHeight = 270;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"addMeetingView" owner:self options:nil];
    self.meetingView = [[addMeetingView alloc] init];
    self.meetingView = [nibContents lastObject];
    self.meetingView.frame = CGRectMake(self.view.frame.size.width/2 - meetingViewWidth/2, self.view.frame.size.height, meetingViewWidth, meetingViewHeight);
    self.meetingView.delegateMeetingView = self;
    self.meetingView.selectedClassName = _selectedClass[@"className"];
    
    //Fill in data
    if (edit) {
        [self.meetingView.deleteMeetingButton setHidden:NO];
        self.meetingView.selectedMeeting = meeting;
        self.meetingView.editing = YES;
        
        self.meetingView.meetingNameField.text = meeting[@"meetingName"];
        self.meetingView.typeField.text = meeting[@"meetingType"];
        self.meetingView.dateAndTimeField.text = meeting[@"dateAndTime"];
        self.meetingView.locationField.text = meeting[@"location"];
        self.meetingView.capacityField.text = meeting[@"capacity"];
    } else {
        self.meetingView.editing = NO;
        [self.meetingView.deleteMeetingButton setHidden:YES];
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
                [meeting.fields setObject:[NSNumber numberWithInteger:meeting.userID] forKey:@"owner"];
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
