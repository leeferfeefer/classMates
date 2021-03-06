//
//  meetings.h
//  classMates
//
//  Created by Lee Fincher on 11/1/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "meetingCell.h"
#import "addMeetingView.h"
#import "UIImage+CL.h"


@interface meetings : UIViewController <UITableViewDataSource, UITableViewDelegate, addMeetingViewDelegate>

//Class properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *selectedClass;
@property (strong, nonatomic) IBOutlet UITableView *meetingsTableView;
@property (strong, nonatomic) NSMutableArray *meetings;
@property (strong, nonatomic) addMeetingView *meetingView;
@property (strong, nonatomic) NSMutableArray *meetingsToBeDeleted;


//Spinners
@property (strong, nonatomic) UIActivityIndicatorView *meetingSpinner;

//Button Properties
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addMeetingButton;


//Button Methods
- (IBAction)addMeetingButtonPressed:(UIBarButtonItem *)sender;


@end
