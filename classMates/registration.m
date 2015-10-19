//
//  registration.m
//  classMates
//
//  Created by Lee Fincher on 10/19/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "registration.h"

@interface registration ()

@end

@implementation registration

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Animate deselection of cell upon returning to registration screen
    [_registrationTableView deselectRowAtIndexPath:[_registrationTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _registrationTableView.delegate = self;
    _registrationTableView.dataSource = self;
    
    
    _recentMajors = [NSMutableArray new];
    _majors = [NSMutableArray new];
    
    [self setUpMajors];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [_recentMajors count];
    } else {
        return [_majors count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"majorCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _recentMajors[indexPath.row];
        return cell;
    } else {
        cell.textLabel.text = _majors[indexPath.row][@"Subject"];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Recently Selected";
    } else {
        return @"All Majors";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        _selectedMajor = _recentMajors[indexPath.row];
    } else {
        _selectedMajor = _majors[indexPath.row];
    }
    [self performSegueWithIdentifier:@"showClasses" sender:nil];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */






#pragma mark - Helper Methods

-(void)setUpMajors{
    for (int i = 0; i < 5; i++) {
        NSMutableDictionary *major = [NSMutableDictionary new];
        if (i == 0) {
            NSMutableArray *classes = [NSMutableArray new];
            [classes addObject:@"CS 2110"];
            [classes addObject:@"CS 1332"];
            [major setObject:classes forKey:@"Classes"];
            [major setObject:@"Computer Science" forKey:@"Subject"];
        } else if (i == 1) {
            NSMutableArray *classes = [NSMutableArray new];
            [classes addObject:@"ME 3345"];
            [classes addObject:@"ME 3322"];
            [classes addObject:@"ME 3210"];
            [major setObject:classes forKey:@"Classes"];
            [major setObject:@"Mechanical Engineering" forKey:@"Subject"];
        }
        [_majors addObject:major];
    }
}





#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showClasses"]) {
        classes *classesVC = [segue destinationViewController];
        classesVC.selectedMajor = _selectedMajor;
    }
}


@end
