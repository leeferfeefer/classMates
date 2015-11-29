//
//  detailMeetingView.m
//  classMates
//
//  Created by Lee Fincher on 11/29/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "detailMeetingView.h"

@implementation detailMeetingView



-(void)didMoveToSuperview {
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    
    
    self.classNameLabel.text = _selectedMeeting[@"className"];
    self.meetingNameLabel.text = _selectedMeeting[@"meetingName"];
    self.meetingType.text = _selectedMeeting[@"meetingType"];
    self.locationLabel.text = _selectedMeeting[@"location"];
    self.dateTimeLabel.text = _selectedMeeting[@"dateAndTime"];
    self.participantsLabel.text = [NSString stringWithFormat:@"%@/%@", _selectedMeeting[@"participants"], _selectedMeeting[@"capacity"]];
}





#pragma mark - Button Methods

- (IBAction)unjoinButtonPressed:(UIButton *)sender {
    
    //Unjoin here
    
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self closeDetailMeetingViewIsEdit:NO];
}






#pragma mark - Close View

-(void)closeDetailMeetingViewIsEdit:(BOOL)edit {
    if (self.delegateDetailMeetingView && [self.delegateDetailMeetingView respondsToSelector:@selector(closeDetailMeetingViewIsEdit:)]) {
        [self.delegateDetailMeetingView closeDetailMeetingViewIsEdit:edit];
    }
}


@end
