//
//  friendCell.h
//  classMates
//
//  Created by Lee Fincher on 11/30/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface friendCell : UITableViewCell



//Label Properties
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;


//Image Properties
@property (strong, nonatomic) IBOutlet UIImageView *friendImage;


//Spinner Properties
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *friendCellSpinner;

@end
