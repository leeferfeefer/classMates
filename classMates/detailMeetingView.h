//
//  detailMeetingView.h
//  classMates
//
//  Created by Lee Fincher on 11/29/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol detailMeetingViewDelegate <NSObject>

@optional
-(void)closeDetailMeetingViewIsEdit:(BOOL)edit isUnJoin:(BOOL)unjoin isDelete:(BOOL)deleteMeeting;
@end

@interface detailMeetingView : UIView


//Protocol Properties
@property (strong, nonatomic) id <detailMeetingViewDelegate> delegateDetailMeetingView;

//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *selectedMeeting;



//Label Properties
@property (strong, nonatomic) IBOutlet UILabel *meetingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *participantsLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetingType;




//Button Properties
@property (strong, nonatomic) IBOutlet UIButton *unjoinButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;



//Button Methods
- (IBAction)unjoinButtonPressed:(UIButton *)sender;
- (IBAction)doneButtonPressed:(UIButton *)sender;
- (IBAction)editButtonPressed:(UIButton *)sender;



@end
