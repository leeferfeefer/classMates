//
//  masterTab.m
//  classMates
//
//  Created by Lee Fincher on 10/17/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "masterTab.h"

@interface masterTab ()

@end

@implementation masterTab

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set default tab
    self.selectedViewController = [self.viewControllers objectAtIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
