//
//  schedule.m
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "schedule.h"

@interface schedule ()

@end

@implementation schedule

@synthesize appDelegate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    if (_matched) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have friends in your classes!!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        _matched = false;
    }

    [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
    [_classEventTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bar_Image"] forBarMetrics:UIBarMetricsDefault];
    

    _classesForDay = [NSMutableArray new];
    _meetingsForDay = [NSMutableArray new];
    
    
    [_addClassButton setTintColor:[UIColor whiteColor]];
    
    
    //Classes and Events Table view:
    CGFloat tableViewY = 136;
    self.classEventTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, 414, self.view.frame.size.height - tableViewY)];
    self.classEventTableView.backgroundColor = [UIColor clearColor];
    [self.classEventTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.classEventTableView.dataSource = self;
    self.classEventTableView.delegate = self;
    [self.view addSubview:_classEventTableView];
    

    CGFloat labelWidth = 300;
    CGFloat labelHeight = 50;
    self.noEventsLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - labelWidth/2, self.view.frame.size.height/2 - labelHeight/2, labelWidth, labelHeight)];
    self.noEventsLabelTop.textColor = [UIColor whiteColor];
    self.noEventsLabelTop.font = [UIFont systemFontOfSize:22];
    [self.noEventsLabelTop setHidden:YES];
    [self.noEventsLabelTop setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.noEventsLabelTop];
    
    self.noEventsLabelBottom = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - labelWidth/2, _noEventsLabelTop.frame.origin.y + labelHeight, labelWidth, labelHeight)];
    self.noEventsLabelBottom.textColor = [UIColor whiteColor];
    self.noEventsLabelBottom.font = [UIFont systemFontOfSize:22];
    [self.noEventsLabelBottom setHidden:YES];
    [self.noEventsLabelBottom setTextAlignment:NSTextAlignmentCenter];
    self.noEventsLabelBottom.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.noEventsLabelBottom];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Classes";
    } else {
        return @"Meetings";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_classesForDay count];
    } else {
        return [_meetingsForDay count];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.frame = CGRectMake(20, 5, 320, 30);
    sectionLabel.font = [UIFont boldSystemFontOfSize:25];
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:sectionLabel];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"scheduleCell";
    scheduleCell *cell = (scheduleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"scheduleCell" owner:self options:nil] lastObject];
    }
    
    //Classes
    if (indexPath.section == 0) {

        [cell.meetingClassName setHidden:YES];
        
        NSMutableDictionary *classData = _classesForDay[indexPath.row];
        
        if (classData[@"friends"] == nil) {
            [cell.friendImage setHidden:YES];
        } else {
            [cell.friendImage setHidden:NO];
        }
        
        cell.classNameLabel.text = classData[@"className"];
        
        if (![cell.classNameLabel.text isEqualToString:@"No classes"]) {
            cell.classTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", classData[@"timeStart"], classData[@"timeEnd"]];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            cell.classTimeLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.classOccurrenceLabel.text = classData[@"weeklyOccurrence"];
        
        [cell.friendImage setHidden:YES];

    } else {
        
        [cell.meetingClassName setHidden:NO];
        
        NSMutableDictionary *meetingData = _meetingsForDay[indexPath.row];
    
        cell.classNameLabel.text = meetingData[@"meetingName"];

        if (![cell.classNameLabel.text isEqualToString:@"No meetings"]) {
            NSArray *timeArray = [meetingData[@"dateAndTime"] componentsSeparatedByString:@" "];
            cell.classTimeLabel.text = [NSString stringWithFormat:@"%@ %@", timeArray[4], timeArray[5]];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            cell.classTimeLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.classOccurrenceLabel.text = meetingData[@"meetingType"];
        cell.meetingClassName.text = meetingData[@"className"];

        [cell.friendImage setHidden:YES];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}



#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    scheduleCell *selectedCell = (scheduleCell *)[_classEventTableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.selectionStyle != UITableViewCellSelectionStyleNone) {
        //Classes
        if (indexPath.section == 0) {
            self.selectedClass = _classesForDay[indexPath.row];
            [self presentDetailClassView];
        //Meetings
        } else {
            self.selectedMeeting = _meetingsForDay[indexPath.row];
            [self presentDetailMeetingView];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}









#pragma mark - CLWeeklyCalendarViewDelegate Methods

-(NSDictionary *)CLCalendarBehaviorAttributes {
    return @{
             CLCalendarWeekStartDay : @0,   //Start from Tuesday every week
             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             CLCalendarSelectedDatePrintFormat : @"EEE, d MMM yyyy",
             CLCalendarSelectedDatePrintColor : [UIColor blackColor],
             CLCalendarSelectedDatePrintFontSize : @13,
             CLCalendarBackgroundImageColor : [UIColor redColor]
             };
}

-(void)dailyCalendarViewDidSelect:(NSDate *)date{
    _selectedDate = date;
    [self classesForDate:date];
    [self meetingsForDate:date];
    
    if ([_classesForDay count] == 0 && [_meetingsForDay count] == 0) {
        _noEventsLabelTop.text = @"No classes or meetings for";
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        _noEventsLabelBottom.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        [_noEventsLabelTop setHidden:NO];
        [_noEventsLabelBottom setHidden:NO];
        [_classEventTableView setHidden:YES];
    } else {
        [_noEventsLabelTop setHidden:YES];
        [_noEventsLabelBottom setHidden:YES];
        [_classEventTableView setHidden:NO];
        
        if ([_classesForDay count] == 0) {
            NSMutableDictionary *none = [NSMutableDictionary new];
            [none setObject:@"No classes" forKey:@"className"];
            [_classesForDay addObject:none];
        } else if ([_meetingsForDay count] == 0) {
            NSMutableDictionary *none = [NSMutableDictionary new];
            [none setObject:@"No meetings" forKey:@"meetingName"];
            [_meetingsForDay addObject:none];
        }
    }
    [_classEventTableView reloadData];
}






#pragma mark - Button Methods

- (IBAction)addClassButtonPressed:(UIBarButtonItem *)sender {
    [self presentAddClassView];
}





#pragma mark - Add Class View Methods

-(void)presentAddClassView{
    
    _classEventTableView.userInteractionEnabled = NO;
    _addClassButton.enabled = NO;

    CGFloat classViewWidth = 350;
    CGFloat classViewHeight = 206;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"addClassView" owner:self options:nil];
    self.classView = [[addClassView alloc] init];
    self.classView = [nibContents lastObject];
    self.classView.frame = CGRectMake(self.view.frame.size.width/2 - classViewWidth/2, self.view.frame.size.height, classViewWidth, classViewHeight);
    self.classView.delegateClassView = self;
    [self.view addSubview:_classView];
    
    CGRect newFrame = self.classView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _classView.frame.size.height/2);
    [UIView animateWithDuration:.3 animations:^{
        _classView.frame = newFrame;
    }];
}



#pragma mark - Add Class View Delegate Methods

-(void)closeAddClassViewDidAdd:(BOOL)didAdd{
    if (didAdd) {
        [self classesForDate:_selectedDate];
        [_classEventTableView reloadData];
    }
    CGRect newFrame = self.classView.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.classView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self.classView removeFromSuperview];
        self.classView = nil;
        _addClassButton.enabled = YES;
        _classEventTableView.userInteractionEnabled = YES;
    }];
}






#pragma mark - Helper Methods

-(void)classesForDate:(NSDate *)date{
    
    [_classesForDay removeAllObjects];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"E"];
    NSString *dayOfTheWeek = [dateFormatter stringFromDate:date];
    NSString *firstLetter = [dayOfTheWeek substringToIndex:1];
    
    //Tuesday and Thursday
    if ([firstLetter isEqualToString:@"T"]) {
        NSString *secondLetter = [dayOfTheWeek substringWithRange:NSMakeRange(1, 1)];
        
        //Tuesday
        if ([secondLetter isEqualToString:@"u"]) {
            for (NSMutableDictionary *class in appDelegate.myClasses) {
                if (([class[@"weeklyOccurrence"] rangeOfString:@"T"].location != NSNotFound && [class[@"weeklyOccurrence"] rangeOfString:@"TH"].location == NSNotFound) || ([class[@"weeklyOccurrence"] rangeOfString:@"TTH"].location != NSNotFound)) {
                    [_classesForDay addObject:class];
                }
            }
        //Thursday
        } else if ([secondLetter isEqualToString:@"h"]){
            for (NSMutableDictionary *class in appDelegate.myClasses) {
                if ([class[@"weeklyOccurrence"] rangeOfString:@"H"].location != NSNotFound) {
                    [_classesForDay addObject:class];
                }
            }
        }
        
    //Every other day
    } else {
        for (NSMutableDictionary *class in appDelegate.myClasses) {
            if ([class[@"weeklyOccurrence"] rangeOfString:firstLetter].location != NSNotFound) {
                [_classesForDay addObject:class];
            }
        }
    }
    
    
    //Sort classes Here
    [self sortClasses];
}
-(void)sortClasses{
    
    //Sort Classes here
}
-(void)meetingsForDate:(NSDate *)date {
    
    [_meetingsForDay removeAllObjects];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];

    for (NSMutableDictionary *meeting in appDelegate.myMeetings) {
        NSString *meetingDate = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                 [meeting[@"dateAndTime"] componentsSeparatedByString:@" "][0],
                                 [meeting[@"dateAndTime"] componentsSeparatedByString:@" "][1],
                                 [meeting[@"dateAndTime"] componentsSeparatedByString:@" "][2],
                                 [meeting[@"dateAndTime"] componentsSeparatedByString:@" "][3]];
        if ([[dateFormatter stringFromDate:date] isEqualToString:meetingDate]) {
                [_meetingsForDay addObject:meeting];
        }
    }
    
    
    //Sort meetings Here
    [self sortMeetings];
}
-(void)sortMeetings{
    
    //Sort Meetings here
}






#pragma mark - Present Class Detail View MethodsSc

-(void)presentDetailClassView {
    
    _classEventTableView.userInteractionEnabled = NO;
    _addClassButton.enabled = NO;
    
    CGFloat classViewWidth = 300;
    CGFloat classViewHeight = 300;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"detailClassView" owner:self options:nil];
    self.detailClassView = [[detailClassView alloc] init];
    self.detailClassView = [nibContents lastObject];
    self.detailClassView.frame = CGRectMake(self.view.frame.size.width/2 - classViewWidth/2, self.view.frame.size.height, classViewWidth, classViewHeight);
    self.detailClassView.delegateDetailClassView = self;
    self.detailClassView.selectedClass = _selectedClass;
    [self.view addSubview:_detailClassView];
    
    CGRect newFrame = self.detailClassView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _detailClassView.frame.size.height/2);
    [UIView animateWithDuration:.3 animations:^{
        _detailClassView.frame = newFrame;
    }];
}


#pragma mark - Close Class Detail View Methods


-(void)closeDetailClassViewIsFriends:(BOOL)friends isMeetings:(BOOL)meetings {
    
    [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
    
    CGRect newFrame = self.detailClassView.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.detailClassView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self.detailClassView removeFromSuperview];
        self.detailClassView = nil;
        _addClassButton.enabled = YES;
        _classEventTableView.userInteractionEnabled = YES;
        
        if (friends) {
            [self performSegueWithIdentifier:@"showFriends" sender:nil];
        } else if (meetings) {
            [self performSegueWithIdentifier:@"showMeetings" sender:nil];
        }
    }];
}





#pragma mark - Present Meeting Detail View Methods

-(void)presentDetailMeetingView {
    
    _classEventTableView.userInteractionEnabled = NO;
    _addClassButton.enabled = NO;
    
    CGFloat classViewWidth = 350;
    CGFloat classViewHeight = 300;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"detailMeetingView" owner:self options:nil];
    self.detailMeetingView = [[detailMeetingView alloc] init];
    self.detailMeetingView = [nibContents lastObject];
    self.detailMeetingView.frame = CGRectMake(self.view.frame.size.width/2 - classViewWidth/2, self.view.frame.size.height, classViewWidth, classViewHeight);
    self.detailMeetingView.delegateDetailMeetingView = self;
    self.detailMeetingView.selectedMeeting = _selectedMeeting;
    [self.view addSubview:_detailMeetingView];
    
    CGRect newFrame = self.detailMeetingView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _detailMeetingView.frame.size.height/2);
    [UIView animateWithDuration:.3 animations:^{
        _detailMeetingView.frame = newFrame;
    }];
}


#pragma mark - Close Meeting Detail View Methods

-(void)closeDetailMeetingViewIsEdit:(BOOL)edit isUnJoin:(BOOL)unjoin isDelete:(BOOL)deleteMeeting{
    
    [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
    
    CGRect newFrame = self.detailMeetingView.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.detailMeetingView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self.detailMeetingView removeFromSuperview];
        self.detailMeetingView = nil;
        _addClassButton.enabled = YES;
        _classEventTableView.userInteractionEnabled = YES;
        
        if (edit) {
            
        
        } else if (unjoin) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have unjoined this meeting!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
                [_classEventTableView reloadData];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else if (deleteMeeting) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"classMates" message:@"You have removed this meeting!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
                [_classEventTableView reloadData];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}











#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMeetings"]) {
        meetings *meetings = [segue destinationViewController];
        meetings.selectedClass = _selectedClass;
    } else if ([segue.identifier isEqualToString:@"showFriends"]) {
        friends *friends = [segue destinationViewController];
        friends.selectedClass = _selectedClass;
    }
}


@end
