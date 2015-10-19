//
//  detailClass.h
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailClass : UIViewController <UITableViewDataSource, UITableViewDelegate>


//Class Properties
@property (nonatomic, strong) NSMutableArray *classMeetings;
@property (nonatomic, strong) NSString *selectedClass;
@property (strong, nonatomic) IBOutlet UITableView *meetingsTableView;


//Button Properties
@property (strong, nonatomic) IBOutlet UIButton *createMeetingButton;



//Button Methods
- (IBAction)createMeetingButtonPressed:(UIButton *)sender;


//Label
@property (strong, nonatomic) IBOutlet UILabel *classTime;
@property (strong, nonatomic) IBOutlet UILabel *classDayOfWeek;



@end
