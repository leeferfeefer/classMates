//
//  registration.h
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "classes.h"

@interface registration : UIViewController <UITableViewDataSource, UITableViewDelegate>


//Class propertues
@property (strong, nonatomic) IBOutlet UITableView *registrationTableView;
@property (strong, nonatomic) NSMutableArray *recentMajors;
@property (strong, nonatomic) NSMutableArray *majors;
@property (strong, nonatomic) NSMutableDictionary *selectedMajor;





@end
