//
//  detailMeetingView.m
//  classMates
//
//  Created by Lee Fincher on 11/29/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "detailMeetingView.h"

@implementation detailMeetingView

@synthesize appDelegate;


-(void)didMoveToSuperview {
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    
    
    self.classNameLabel.text = _selectedMeeting[@"className"];
    self.meetingNameLabel.text = _selectedMeeting[@"meetingName"];
    self.meetingType.text = _selectedMeeting[@"meetingType"];
    self.locationLabel.text = _selectedMeeting[@"location"];
    self.dateTimeLabel.text = _selectedMeeting[@"dateAndTime"];
    self.participantsLabel.text = [NSString stringWithFormat:@"%@/%@", _selectedMeeting[@"participants"], _selectedMeeting[@"capacity"]];
    
    
    if ([_selectedMeeting[@"owner"] integerValue] == appDelegate.userID) {
        [self.unjoinButton setTitle:@"Delete" forState:UIControlStateNormal];
    }
    
    NSLog(@"the meeting object is  %@", _selectedMeeting);

}





#pragma mark - Button Methods

- (IBAction)unjoinButtonPressed:(UIButton *)sender {
    
    if ([self.unjoinButton.titleLabel.text isEqualToString:@"Delete"]) {
        
        [QBRequest deleteObjectWithID:_selectedMeeting[@"MeetingID"] className:@"Meetings" successBlock:^(QBResponse * _Nonnull response) {
            
            [QBRequest deleteObjectWithID:appDelegate.idForMeeting[_selectedMeeting] className:@"userMeetings" successBlock:^(QBResponse * _Nonnull response) {
                
                NSUInteger deletedIndex = [appDelegate.myMeetings indexOfObject:_selectedMeeting];
                //Remove meeting from list of meetings
                [appDelegate.myMeetings removeObjectAtIndex:deletedIndex];
                [appDelegate.myMeetingIDs removeObjectAtIndex:deletedIndex];
                [appDelegate.idForMeeting removeObjectForKey:_selectedMeeting];
                
                [self closeDetailMeetingViewIsEdit:NO didUnJoin:NO didDelete:YES];

            } errorBlock:^(QBResponse * _Nonnull response) {
                NSLog(@"error deleting user meeting");
            }];
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"error deleting Meeting");
        }];
        
    } else {
        //Update meeting object
        QBCOCustomObject *meetingObject = [QBCOCustomObject customObject];
        meetingObject.className = @"Meetings";
        meetingObject.ID = _selectedMeeting[@"MeetingID"];
        
        NSMutableDictionary *operators = [NSMutableDictionary new];
        [operators setObject:@(-1) forKey:@"inc[participants]"];
        
        [QBRequest updateObject:meetingObject specialUpdateOperators:operators successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            
            NSInteger indexOfDeletedMeeting = [appDelegate.myMeetings indexOfObject:_selectedMeeting];
            
            [QBRequest deleteObjectWithID:[appDelegate.myMeetingIDs objectAtIndex:indexOfDeletedMeeting] className:@"userMeetings" successBlock:^(QBResponse * _Nonnull response) {
                
                [appDelegate.myMeetings removeObjectAtIndex:indexOfDeletedMeeting];
                [appDelegate.myMeetingIDs removeObjectAtIndex:indexOfDeletedMeeting];
                [appDelegate.idForMeeting removeObjectForKey:_selectedMeeting];
                
                [self closeDetailMeetingViewIsEdit:NO didUnJoin:YES didDelete:NO];
                
            } errorBlock:^(QBResponse * _Nonnull response) {
                NSLog(@"error deleting user meeting obejct when unjoining meeting");
            }];
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"error updating participants in meeting object");
        }];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self closeDetailMeetingViewIsEdit:NO didUnJoin:NO didDelete:NO];
}






#pragma mark - Close View

-(void)closeDetailMeetingViewIsEdit:(BOOL)edit didUnJoin:(BOOL)unjoin didDelete:(BOOL)deleteMeeting{
    if (self.delegateDetailMeetingView && [self.delegateDetailMeetingView respondsToSelector:@selector(closeDetailMeetingViewIsEdit:isUnJoin:isDelete:)]) {
        [self.delegateDetailMeetingView closeDetailMeetingViewIsEdit:edit isUnJoin:unjoin isDelete:deleteMeeting];
    }
}


@end
