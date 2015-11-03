//
//  scheduleView.m
//  classMates
//
//  Created by Lee Fincher on 10/18/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "scheduleView.h"

@interface scheduleView ()

@end

@implementation scheduleView


@synthesize appDelegate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //TODO: SWITCH BACK TO TABLE VIEW HERE
    [_scheduleCollectionView setHidden:YES];
    _scheduleCollectionView.alpha = 0;
    
//    self.collectionViewCalendarLayout = (MSCollectionViewCalendarLayout *)self.scheduleCollectionView.collectionViewLayout;
//    self.collectionViewCalendarLayout.delegate = self;
    
    //Animate deselection of cell upon returning to schedule screen
    [_scheduleTableView deselectRowAtIndexPath:[_scheduleTableView indexPathForSelectedRow] animated:YES];
    
    //If class data has not been initialized yet
    if (!_schedule) {
        [self breakDataIntoSections];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _navBarImage.backgroundColor = [UIColor grayColor];
    
    //Save data - Maybe make a data manager
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    
    
    //Create and register column header class
    //Create and register row header class
    //Create and register event cell class

    
//    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;

    
    //Set delegates
    _scheduleTableView.delegate = self;
    _scheduleTableView.dataSource = self;
    _scheduleCollectionView.delegate = self;
    _scheduleCollectionView.dataSource = self;
    
    
    
    //TODO: REMOVE - ONLY TEMPORARY
    _scheduleCollectionView.backgroundColor = [UIColor orangeColor];
    _scheduleTableView.backgroundColor = [UIColor yellowColor];
    
    //TODO: SWITCH BACK TO LIST VIEW HERE
    [_changeViewButton setTitle:@"Calendar" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Button Methods

- (IBAction)changeViewButtonPressed:(UIButton *)sender {

//    //Enable Calendar View
//    if ([_changeViewButton.titleLabel.text isEqualToString:@"Calendar"]) {
//        [_changeViewButton setTitle:@"List" forState:UIControlStateNormal];
//        [self enableCalendarView];
//        
//    //Enable List View
//    } else if ([_changeViewButton.titleLabel.text isEqualToString:@"List"]) {
//        [_changeViewButton setTitle:@"Calendar" forState:UIControlStateNormal];
//        [self enableListView];
//    }
}













#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_schedule[[self sectionNameForSectionNumber:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
     
    cell.textLabel.text = _schedule[[self sectionNameForSectionNumber:indexPath.section]][indexPath.row];
    return cell;
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionNameForSectionNumber:section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedClass = _schedule[[self sectionNameForSectionNumber:indexPath.section]][indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
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





#pragma mark - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [appDelegate.userInfo[@"Schedule"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *view;
//    if (kind == MSCollectionElementKindDayColumnHeader) {
//        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
//        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
//        NSDate *currentDay = [self currentTimeComponentsForCollectionView:_scheduleCollectionView layout:self.collectionViewCalendarLayout];
//        
//        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
//        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
//        
//        dayColumnHeader.day = day;
//        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
//        
//        view = dayColumnHeader;
//    } else if (kind == MSCollectionElementKindTimeRowHeader) {
//        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
//        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
//        view = timeRowHeader;
//    }
//    return view;
//}



#pragma mark - MSCollectionViewCalendarLayout

//- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
//{
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
//    MSEvent *event = [sectionInfo.objects firstObject];
//    return event.day;
//}
//
//- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MSEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    return event.start;
//}
//
//- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MSEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    // Most sports last ~3 hours, and SeatGeek doesn't provide an end time
//    return [event.start dateByAddingTimeInterval:(60 * 60 * 3)];
//}
//
//- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
//{
//    return [NSDate date];
//}



/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */






#pragma mark - Schedule View Methods

-(void)enableListView{
    
    [_scheduleTableView setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        _scheduleCollectionView.alpha = 0;
        _scheduleTableView.alpha = 1;
    } completion:^(BOOL finished) {
        [_scheduleCollectionView setHidden:YES];
    }];
}
-(void)enableCalendarView{
    
    [_scheduleCollectionView setHidden:NO];

    [UIView animateWithDuration:.3 animations:^{
        _scheduleCollectionView.alpha = 1;
        _scheduleTableView.alpha = 0;
    } completion:^(BOOL finished) {
        [_scheduleTableView setHidden:YES];
    }];
}


#pragma mark - Helper Methods

-(void)breakDataIntoSections{
    
    _schedule = [NSMutableDictionary new];
    for (int i = 0; i < 7; i++) {
        NSMutableArray *classes = [NSMutableArray new];
        [_schedule setObject:classes forKey:[self sectionNameForSectionNumber:i]];
    }
    
//    NSLog(@"Schedule before is %@", _schedule);
    
    for (NSString *class in appDelegate.userInfo[@"Schedule"]) {
        
        NSString *date = [class componentsSeparatedByString:@", "][1];
        
        if ([date isEqualToString:@"MWF"]) {
            [self setMWFClasses:class];
        } else if ([date isEqualToString:@"TTH"]) {
            [self setTTHClasses:class];
        } else if ([date isEqualToString:@"F"]) {
            [self setFClasses:class];
        }
    }
    
    [self sortClassesByTime];
}


-(void)setMWFClasses:(NSString *)class{
    [_schedule[@"Monday"] addObject:class];
    [_schedule[@"Wednesday"] addObject:class];
    [_schedule[@"Friday"] addObject:class];
}
-(void)setTTHClasses:(NSString *)class{
    [_schedule[@"Tuesday"] addObject:class];
    [_schedule[@"Thursday"] addObject:class];
}
-(void)setFClasses:(NSString *)class{
    [_schedule[@"Friday"] addObject:class];
}

//Bubble sort
-(void)sortClassesByTime{
    for (int i = 0; i < 7; i++) {
        NSMutableArray *classesForDay = _schedule[[self sectionNameForSectionNumber:i]];
        if ([classesForDay count] > 1) {
            for (int j = 1; j < [classesForDay count]; j++) {
                
                NSString *class = classesForDay[j];
                NSString *timeRange = [class componentsSeparatedByString:@", "][2];
                NSString *startTime = [timeRange componentsSeparatedByString:@" - "][0];
                
                NSString *time = [startTime componentsSeparatedByString:@" "][0];
                NSString *amPM = [startTime componentsSeparatedByString:@" "][1];
//                NSLog(@"the startTime is %@", startTime);
//                NSLog(@"the time is %@", time);
//                NSLog(@"the amPM is %@", amPM);

                //Class before
                NSString *classBefore = classesForDay[j-1];
                NSString *timeRangeBefore = [classBefore componentsSeparatedByString:@", "][2];
                NSString *startTimeBefore = [timeRangeBefore componentsSeparatedByString:@" - "][0];
                
                NSString *timeBefore = [startTimeBefore componentsSeparatedByString:@" "][0];
                NSString *amPMBefore = [startTimeBefore componentsSeparatedByString:@" "][1];
                //NSLog(@"the startTimeBefore is %@", startTimeBefore);
//                NSLog(@"the timeBefore is %@", timeBefore);
//                NSLog(@"the amPMBefore is %@", amPMBefore);

                //Class starts before
                if ([amPMBefore isEqualToString:@"pm"] && [amPM isEqualToString:@"am"]) {
                    [classesForDay replaceObjectAtIndex:j-1 withObject:class];
                    [classesForDay replaceObjectAtIndex:j withObject:classBefore];
                //Class starts after
                } else {
                    
                }
            }
        }
    }
}


-(NSString *)sectionNameForSectionNumber:(NSInteger)section{
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"EEEE"];
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = [dateFormatter stringFromDate:todayDate];
            break;
        case 1:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:24*60*60]];
            break;
        case 2:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:48*60*60]];
            break;
        case 3:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:72*60*60]];
            break;
        case 4:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:96*60*60]];
            break;
        case 5:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:120*60*60]];
            break;
        case 6:
            sectionName = [dateFormatter stringFromDate:[todayDate dateByAddingTimeInterval:144*60*60]];
            break;
        default:
            sectionName = @"";
            break;
            
    }
    return sectionName;
}












#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        detailClass *detailVC = [segue destinationViewController];
        detailVC.selectedClass = _selectedClass;
    }
}

@end
