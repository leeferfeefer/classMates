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
    self.friendImage.image = [UIImage imageNamed:@"friendIcon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
