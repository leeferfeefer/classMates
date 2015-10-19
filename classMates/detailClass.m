//
//  detailClass.m
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "detailClass.h"

@interface detailClass ()

@end

@implementation detailClass


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [_selectedClass componentsSeparatedByString:@", "][0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _classTime.text = [_selectedClass componentsSeparatedByString:@", "][2];
    _classDayOfWeek.text = [_selectedClass componentsSeparatedByString:@", "][1];
    
    
    _meetingsTableView.delegate = self;
    _meetingsTableView.dataSource = self;
    
    
    _classMeetings = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Button Methods

- (IBAction)createMeetingButtonPressed:(UIButton *)sender {
    
    //Create meeting
    //Show view here
    
    
}







#pragma mark - Table View Methods


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_classMeetings count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meetingCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _classMeetings[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    _selectedClass = _schedule[[self sectionNameForSectionNumber:indexPath.section]][indexPath.row];
//    [self performSegueWithIdentifier:@"showDetail" sender:nil];
}





@end
