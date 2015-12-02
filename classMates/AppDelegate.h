//
//  AppDelegate.h
//  classMates
//
//  Created by Lee Fincher on 9/21/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark - DEFINES

//Color with hex value
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >> 0))/255.0 \
alpha:1.0]


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property NSUInteger userID;



@property (strong, nonatomic) NSMutableArray *myMeetings;
@property (strong, nonatomic) NSMutableArray *myClasses;

@property (strong, nonatomic) NSMutableArray *myMeetingIDs;
@property (strong, nonatomic) NSMutableDictionary *idForMeeting;
//@property (strong, nonatomic) NSMutableArray *myClassIDs;

@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *friendClasses;


@end

