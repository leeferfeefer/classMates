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
    [_classEventTableView deselectRowAtIndexPath:[_classEventTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    _calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
    


    //Classes and Events Table view:
    CGFloat tableViewY = 200;
    self.classEventTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, 414, self.view.frame.size.height - tableViewY)];
    self.classEventTableView.backgroundColor = [UIColor clearColor];
    self.classEventTableView.dataSource = self;
    self.classEventTableView.delegate = self;
    [self.view addSubview:_classEventTableView];
    
    
    self.currentClasses = [NSMutableArray new];
    self.currentMeetings = [NSMutableArray new];

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
        return [_currentClasses count];
    } else {
        return [_currentMeetings count];
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
    
    if (indexPath.section == 0) {

        [cell.meetingClassName setHidden:YES];
        
        NSString *classNameFirstHalf = [_currentClasses[indexPath.row] componentsSeparatedByString:@"/"][0];
        NSString *classNameSecondHalf = [[_currentClasses[indexPath.row] componentsSeparatedByString:@"/"][1] componentsSeparatedByString:@"&"][0];
        NSString *timeFirstHalf = [[_currentClasses[indexPath.row] componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@"|"][0];
        NSString *timeSecondHalf = [[_currentClasses[indexPath.row] componentsSeparatedByString:@"|"][1] componentsSeparatedByString:@"?"][0];
        NSString *weeklyOccurence = [_currentClasses[indexPath.row] componentsSeparatedByString:@"?"][1];
        
        cell.classNameLabel.text = [NSString stringWithFormat:@"%@ - %@", classNameFirstHalf, classNameSecondHalf];
        cell.classTimeLabel.text = [NSString stringWithFormat:@"%@ - %@",timeFirstHalf, timeSecondHalf];
        cell.classOccurenceLabel.text = weeklyOccurence;
        
        cell.classNameLabel.textColor = [UIColor whiteColor];
        cell.classTimeLabel.textColor = [UIColor whiteColor];
        cell.classOccurenceLabel.textColor = [UIColor whiteColor];

    } else {
        
        [cell.meetingClassName setHidden:NO];
    
        cell.classNameLabel.text = appDelegate.myMeetings[indexPath.row][@"meetingName"];
        
        NSArray *timeArray = [appDelegate.myMeetings[indexPath.row][@"dateAndTime"] componentsSeparatedByString:@" "];
        cell.classTimeLabel.text = [NSString stringWithFormat:@"%@ %@", timeArray[4], timeArray[5]];
        cell.classOccurenceLabel.text = appDelegate.myMeetings[indexPath.row][@"meetingType"];
        
        
        
        NSString *classNameFirstHalf = [appDelegate.myMeetings[indexPath.row][@"className"] componentsSeparatedByString:@"/"][0];
        NSString *classNameSecondHalf = [[appDelegate.myMeetings[indexPath.row][@"className"]  componentsSeparatedByString:@"/"][1] componentsSeparatedByString:@"&"][0];

        cell.meetingClassName.text = [NSString stringWithFormat:@"%@ %@",classNameFirstHalf, classNameSecondHalf];
        
        cell.classNameLabel.textColor = [UIColor whiteColor];
        cell.classTimeLabel.textColor = [UIColor whiteColor];
        cell.classOccurenceLabel.textColor = [UIColor whiteColor];
        cell.meetingClassName.textColor = [UIColor whiteColor];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.selectedClass = _currentClasses[indexPath.row];
        [self performSegueWithIdentifier:@"showDetailClass" sender:nil];
    } else {
        //Present detail view for meeting
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
    [self classesForDate:date];
    [self meetingsForDate:date];
    
    if ([_currentMeetings count] == 0 && [_currentClasses count] == 0) {
        _noEventsLabelTop.text = @"No classes or meetings for";
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        _noEventsLabelBottom.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
}






#pragma mark - Button Methods

- (IBAction)addClassButtonPressed:(UIBarButtonItem *)sender {
    [self presentAddClassView];
}





#pragma mark - Add Class View Methods

-(void)presentAddClassView{
    
    CGFloat classViewWidth = 350;
    CGFloat classViewHeight = 400;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"addClassView" owner:self options:nil];
    self.classView = [[addClassView alloc] init];
    self.classView = [nibContents lastObject];
    self.classView.frame = CGRectMake(self.view.frame.size.width/2 - classViewWidth/2, self.view.frame.size.height, classViewWidth, classViewHeight);
    self.classView.delegateClassView = self;
    [self.view addSubview:_classView];
    
    CGRect newFrame = self.classView.frame;
    newFrame.origin.y = (self.view.frame.size.height/2 - _classView.frame.size.height/2) - 100;
    [UIView animateWithDuration:.3 animations:^{
        _classView.frame = newFrame;
    }];
    
    _addClassButton.enabled = NO;
}



#pragma mark - Add Class View Delegate Methods

-(void)closeAddClassView{
    CGRect newFrame = self.classView.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.classView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self.classView removeFromSuperview];
        self.classView = nil;
        _addClassButton.enabled = YES;
    }];
}




#pragma mark - Helper Methods

-(void)classesForDate:(NSDate *)date{
    
    [_currentClasses removeAllObjects];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"E"];
    NSString *dayOfTheWeek = [dateFormatter stringFromDate:date];
    NSString *firstLetter = [dayOfTheWeek substringToIndex:1];
    
    //Also do S (saturday/Sunday)
    
    if ([firstLetter isEqualToString:@"T"]) {
    
//        NSString *secondLetter = [dayOfTheWeek substringToIndex:];

    } else {
        for (NSString *class in appDelegate.userInfo[@"Schedule"]) {
            NSString *occurence = [class componentsSeparatedByString:@"?"][1];
            if ([occurence containsString:firstLetter]) {
                [_currentClasses addObject:class];
            }
        }
    }
    [_classEventTableView reloadData];
    
    if ([_currentClasses count] == 0) {
        self.noEventsLabelTop.text = @"No classes for";
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        _noEventsLabelBottom.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        
        [_classEventTableView setHidden:YES];
        [_noEventsLabelTop setHidden:NO];
        [_noEventsLabelBottom setHidden:NO];
    } else {
        [_classEventTableView setHidden:NO];
        [_noEventsLabelTop setHidden:YES];
        [_noEventsLabelBottom setHidden:YES];
    }
}
-(void)meetingsForDate:(NSDate *)date {
    
    [_currentMeetings removeAllObjects];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"E"];
    NSString *dayOfTheWeek = [dateFormatter stringFromDate:date];
    NSString *firstLetter = [dayOfTheWeek substringToIndex:1];
    
    if ([firstLetter isEqualToString:@"T"]) {
        
        //        NSString *secondLetter = [dayOfTheWeek substringToIndex:];
        
    } else {
        for (NSDictionary *meeting in appDelegate.myMeetings) {
            NSString *date = meeting[@"dateAndTime"];
            if ([firstLetter isEqualToString:[date substringToIndex:1]]) {
                [_currentMeetings addObject:meeting];
            }
        }
    }
    [_classEventTableView reloadData];
    
    if ([_currentClasses count] == 0) {
        
        [_classEventTableView setHidden:YES];
        [_noEventsLabelTop setHidden:NO];
        [_noEventsLabelBottom setHidden:NO];
    } else {
        [_classEventTableView setHidden:NO];
        [_noEventsLabelTop setHidden:YES];
        [_noEventsLabelBottom setHidden:YES];
    }
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetailClass"]) {
        detailClass *detail = [segue destinationViewController];
        detail.selectedClass = _selectedClass;
    }
}


@end
