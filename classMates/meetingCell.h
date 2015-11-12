//
//  meetingCell.h
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface meetingCell : UITableViewCell


//Labels
@property (strong, nonatomic) IBOutlet UILabel *meetingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetingLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetingTypeLabel;



@end
