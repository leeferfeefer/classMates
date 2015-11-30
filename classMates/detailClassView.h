//
//  detailClassView.h
//  classMates
//
//  Created by Lee Fincher on 11/29/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol detailClassViewDelegate <NSObject>

@optional
-(void)closeDetailClassViewIsFriends:(BOOL)friends isMeetings:(BOOL)meetings;
@end

@interface detailClassView : UIView


//Protocol Properties
@property (strong, nonatomic) id <detailClassViewDelegate> delegateDetailClassView;



//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *selectedClass;




//Label Properties



//Button Properties
@property (strong, nonatomic) IBOutlet UIButton *viewFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *viewMeetingsButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;



//Button Methods
- (IBAction)viewFriendsButtonPressed:(UIButton *)sender;
- (IBAction)viewMeetingsButtonPressed:(UIButton *)sender;
- (IBAction)doneButtonPressed:(UIButton *)sender;




@end
