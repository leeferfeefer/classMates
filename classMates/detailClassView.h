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
-(void)closeDetailClassView;
@end

@interface detailClassView : UIView


//Protocol Properties
@property (strong, nonatomic) id <detailClassViewDelegate> delegateDetailClassView;

@end
