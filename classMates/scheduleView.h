//
//  scheduleView.h
//  classMates
//
//  Created by Lee Fincher on 10/18/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailClass.h"



@interface scheduleView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>



//Class Properties
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *schedule;
@property (strong, nonatomic) IBOutlet UICollectionView *scheduleCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *scheduleTableView;

@property (strong, nonatomic) NSString *selectedClass;


//Images
@property (strong, nonatomic) IBOutlet UIImageView *navBarImage;


//Buttons
@property (strong, nonatomic) IBOutlet UIButton *changeViewButton;


//Button Methods
- (IBAction)changeViewButtonPressed:(UIButton *)sender;

@end
