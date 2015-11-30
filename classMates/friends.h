//
//  friends.h
//  classMates
//
//  Created by Lee Fincher on 11/30/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendCell.h"
#import "UIImage+CL.h"


@interface friends : UITableViewController


//Class Properties
@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) NSMutableDictionary *selectedClass;
@property (strong, nonatomic) NSMutableDictionary *friends;
@property (strong, nonatomic) NSArray *friendIDs;



//Spinner properties
@property (strong, nonatomic) UIActivityIndicatorView *friendSpinner;



@end
