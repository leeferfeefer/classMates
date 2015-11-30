//
//  friendCell.m
//  classMates
//
//  Created by Lee Fincher on 11/30/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "friendCell.h"

@implementation friendCell

- (void)awakeFromNib {
    _friendNameLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
