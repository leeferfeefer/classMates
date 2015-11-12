//
//  scheduleCell.h
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scheduleCell : UITableViewCell


//Labels
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *classOccurrenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetingClassName;


@end
