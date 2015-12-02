//
//  meetingCell.m
//  classMates
//
//  Created by Lee Fincher on 11/2/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "meetingCell.h"

@implementation meetingCell

- (void)awakeFromNib {
    _meetingNameLabel.textColor = [UIColor whiteColor];
    _meetingLocationLabel.textColor = [UIColor whiteColor];
    _meetingTimeLabel.textColor = [UIColor whiteColor];
    _meetingTypeLabel.textColor = [UIColor whiteColor];
    _capacityLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
