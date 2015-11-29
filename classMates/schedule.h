//
//  schedule.h
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLWeeklyCalendarView.h"
#import "addClassView.h"
#import "meetings.h"
#import "scheduleCell.h"
#import "detailClassView.h"
#import "detailMeetingView.h"

@interface schedule : UIViewController <CLWeeklyCalendarViewDelegate, classViewDelegate, UITableViewDataSource, UITableViewDelegate, detailClassViewDelegate, detailMeetingViewDelegate>


//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) CLWeeklyCalendarView *calendarView;
@property (strong, nonatomic) addClassView *classView;
@property (strong, nonatomic) detailMeetingView *detailMeetingView;
@property (strong, nonatomic) detailClassView *detailClassView;
@property (strong, nonatomic) UITableView *classEventTableView;
@property (strong, nonatomic) NSMutableDictionary *selectedClass;
@property (strong, nonatomic) NSMutableDictionary *selectedMeeting;
@property (strong, nonatomic) NSMutableArray *classesForDay;
@property (strong, nonatomic) NSMutableArray *meetingsForDay;
@property (strong, nonatomic) NSDate *selectedDate;
@property BOOL matched;


//Button Properties
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addClassButton;



//Button Methods
- (IBAction)addClassButtonPressed:(UIBarButtonItem *)sender;


//Labels
@property (strong, nonatomic) UILabel *noEventsLabelTop;
@property (strong, nonatomic) UILabel *noEventsLabelBottom;


@end
