//
//  classes.m
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "classes.h"

@interface classes ()

@end

@implementation classes

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = _selectedMajor[@"Subject"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
    _signedUpClassesTableView.delegate = self;
    _signedUpClassesTableView.dataSource = self;
    _classesTableView.delegate = self;
    _classesTableView.dataSource = self;
    
    _signedUpClasses = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _classesTableView) {
        return [_selectedMajor[@"Classes"] count];
    } else {
        return [_signedUpClasses count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _classesTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
        cell.textLabel.text = _selectedMajor[@"Classes"][indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signedUpCell" forIndexPath:indexPath];
        cell.textLabel.text = _signedUpClasses[indexPath.row];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        _selectedMajor = _recentMajors[indexPath.row];
//    } else {
//        _selectedMajor = _majors[indexPath.row];
//    }
//    [self performSegueWithIdentifier:@"showClasses" sender:nil];
}






#pragma mark - Button Methods

- (IBAction)enrollButtonPressed:(UIButton *)sender {
    
    
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
