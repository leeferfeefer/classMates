//
//  classes.h
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface classes : UIViewController <UITableViewDelegate, UITableViewDataSource>






//Class Properties
@property (nonatomic, strong) NSMutableDictionary *selectedMajor;
@property (strong, nonatomic) IBOutlet UITableView *classesTableView;
@property (strong, nonatomic) IBOutlet UITableView *signedUpClassesTableView;
@property (nonatomic, strong) NSMutableArray *signedUpClasses;






//Buttons
@property (strong, nonatomic) IBOutlet UIButton *enrollButton;



//Button Methods
- (IBAction)enrollButtonPressed:(UIButton *)sender;




@end
