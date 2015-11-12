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
#import "detailClass.h"
#import "scheduleCell.h"

@interface schedule : UIViewController <CLWeeklyCalendarViewDelegate, classViewDelegate, UITableViewDataSource, UITableViewDelegate>


//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) CLWeeklyCalendarView *calendarView;
@property (strong, nonatomic) addClassView *classView;
@property (strong, nonatomic) UITableView *classEventTableView;
@property (strong, nonatomic) NSMutableDictionary *selectedClass;
@property (strong, nonatomic) NSMutableArray *classesForDay;
@property (strong, nonatomic) NSMutableArray *meetingsForDay;

//Button Properties
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addClassButton;



//Button Methods
- (IBAction)addClassButtonPressed:(UIBarButtonItem *)sender;


//Labels
@property (strong, nonatomic) UILabel *noEventsLabelTop;
@property (strong, nonatomic) UILabel *noEventsLabelBottom;


@end
