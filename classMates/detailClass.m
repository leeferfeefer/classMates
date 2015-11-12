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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _meetingsTableView.delegate = self;
    _meetingsTableView.dataSource = self;
    _meetingsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage calendarBackgroundImage:_meetingsTableView.frame.size.height]];
    
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
    
    cell.meetingNameLabel.textColor = [UIColor whiteColor];
    cell.meetingLocationLabel.textColor = [UIColor whiteColor];
    cell.meetingTimeLabel.textColor = [UIColor whiteColor];
    cell.meetingTypeLabel.textColor = [UIColor whiteColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}




#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //If meeting is already in user's meetings
    if ([appDelegate.myMeetings containsObject:_meetings[indexPath.row]]) {
        
        //User owns this meeting
        if ([appDelegate.myMeetingIDs containsObject:[appDelegate.idForMeeting objectForKey:_meetings[indexPath.row]]]) {
            
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
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have already RSVP'ed for this meeting." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_meetingsTableView deselectRowAtIndexPath:[_meetingsTableView indexPathForSelectedRow] animated:YES];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } else {
        
        //Add meeting to list of meetings (in this case, this meeting does not belong to user)
        
    }
}






#pragma mark - Button Methods

- (IBAction)addMeetingButtonPressed:(UIBarButtonItem *)sender {
    _addMeetingButton.enabled = NO;
    [self presentCreateMeetingisEdit:NO andSelectedMeeting:nil];
}






#pragma mark - Create Meeting Methods

-(void)presentCreateMeetingisEdit:(BOOL)edit andSelectedMeeting:(NSMutableDictionary *)meeting{
    
    CGFloat meetingViewWidth = 350;
    CGFloat meetingViewHeight = 400;
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
    } else {
        self.meetingView.editing = NO;
        [self.meetingView.deleteMeetingButton setHidden:YES];
    }
    
    [self.view addSubview:_meetingView];
    
    CGRect newFrame = _meetingView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _meetingView.frame.size.height/2) - 100;
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
    }];
}




#pragma mark - Helper Methods

-(void)pullMeetings{
    [_meetings removeAllObjects];
    
    //Retreive all meetings with class name
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:_selectedClass[@"className"] forKey:@"className"];
    
    [QBRequest objectsWithClassName:@"Meetings" extendedRequest:getRequest successBlock:^(QBResponse * _Nonnull response, NSArray<QBCOCustomObject *> * _Nullable objects, QBResponsePage * _Nullable page) {
        
        if ([objects count] > 0) {
            for (QBCOCustomObject *meeting in objects) {
                [meeting.fields setObject:meeting.ID forKey:@"MeetingID"];
                [_meetings addObject:meeting.fields];
            }
            
            
            //Filter meetings here to see if they need to be deleted
            
            
        } else {
            //Present no meetings Create One alert
        }
        
        [_meetingsTableView reloadData];
        [_meetingSpinner stopAnimating];
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        [_meetingSpinner stopAnimating];
        NSLog(@"error pulling meeting data");
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