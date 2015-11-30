//
//  friends.m
//  classMates
//
//  Created by Lee Fincher on 11/30/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "friends.h"

@interface friends ()

@end

@implementation friends

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _friendsTableView.delegate = self;
    _friendsTableView.dataSource = self;
    _friendsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage calendarBackgroundImage:_friendsTableView.frame.size.height]];
    
    
    CGFloat spinnerWidth = 37;
    _friendSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_friendSpinner setHidesWhenStopped:YES];
    _friendSpinner.frame = CGRectMake(self.view.frame.size.width/2 - spinnerWidth/2, self.view.frame.size.height/2 - spinnerWidth/2, spinnerWidth, spinnerWidth);
    [_friendsTableView addSubview:_friendSpinner];
    [_friendSpinner startAnimating];
    
    //Pull Facebook friends in class
    [self pullFriends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendIDs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"friendCell";
    friendCell *cell = (friendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[friendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *friendID = _friendIDs[indexPath.row];
    NSMutableDictionary *friendInfo = _friends[friendID];
    
    cell.friendNameLabel.text = friendInfo[@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Call the sdwebimage here
    
    
    return cell;
}








#pragma mark - Helper Methods

-(void)pullFriends{
    NSMutableArray *friendIDs = [NSMutableArray new];
    for (NSString *friend in _selectedClass[@"friends"]) {
        [friendIDs addObject:[friend componentsSeparatedByString:@" - "][1]];
    }
    
    NSString *friends = [friendIDs componentsJoinedByString:@","];
    NSLog(@"the friends is %@", friends);
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/?ids=%@",friends]
                                  parameters:@{@"fields": @"name, picture"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        if (!error) {
            self.friends = result;
            self.friendIDs = [self.friends allKeys];
        }
        [_friendsTableView reloadData];
        [_friendSpinner stopAnimating];
        NSLog(@"the error is %@", error);
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
