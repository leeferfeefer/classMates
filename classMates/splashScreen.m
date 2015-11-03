//
//  ViewController.m
//  classMates
//
//  Created by Lee Fincher on 9/21/15.
//  Copyright © 2015 GT - CS 4261. All rights reserved.
//

#import "splashScreen.h"

@interface splashScreen ()

@end

@implementation splashScreen

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_splashLoading startAnimating];
    
    _backgroundImage.backgroundColor = [UIColor blackColor];
    _classMatesImage.image = [UIImage imageNamed:@"Logo"];
    
    //TODO: REMOVE -- ONLY TEMPORARY
    
    
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_splashLoading stopAnimating];
        [self performSegueWithIdentifier:@"login" sender:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Button Methods






#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
