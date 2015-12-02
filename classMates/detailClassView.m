//
//  detailClassView.m
//  classMates
//
//  Created by Lee Fincher on 11/29/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "detailClassView.h"

@implementation detailClassView



-(void)didMoveToSuperview {
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    
    
    _classNameLabel.text = _selectedClass[@"className"];
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@", _selectedClass[@"timeStart"], _selectedClass[@"timeEnd"]];
    _weeklyOccurrenceLabel.text = _selectedClass[@"weeklyOccurrence"];


    [_viewFriendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_viewMeetingsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    if (_selectedClass[@"friends"] == nil) {
        [_viewFriendsButton setTitle:@"No Friends" forState:UIControlStateNormal];
        [_viewFriendsButton setEnabled:NO];
        [_viewFriendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else {
        _friendIcon.image = [UIImage imageNamed:@"friendIcon"];
    }
}



#pragma mark - Button Methods

- (IBAction)viewFriendsButtonPressed:(UIButton *)sender {
    [self closeDetailClassViewIsfriends:YES isMeetings:NO];
}

- (IBAction)viewMeetingsButtonPressed:(UIButton *)sender {
    [self closeDetailClassViewIsfriends:NO isMeetings:YES];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self closeDetailClassViewIsfriends:NO isMeetings:NO];
}



#pragma mark - Close View

-(void)closeDetailClassViewIsfriends:(BOOL)friends isMeetings:(BOOL)meetings {
    if (self.delegateDetailClassView && [self.delegateDetailClassView respondsToSelector:@selector(closeDetailClassViewIsFriends:isMeetings:)]) {
        [self.delegateDetailClassView closeDetailClassViewIsFriends:friends isMeetings:meetings];
    }
}



@end
