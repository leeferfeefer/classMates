//
//  scheduleCell.m
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "scheduleCell.h"

@implementation scheduleCell

- (void)awakeFromNib {
    _friendImage.image = [UIImage imageNamed:@"friendIcon"];
    
    _classNameLabel.textColor = [UIColor whiteColor];
    _classTimeLabel.textColor = [UIColor whiteColor];
    _classOccurrenceLabel.textColor = [UIColor whiteColor];
    _meetingClassName.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
