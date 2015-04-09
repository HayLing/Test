//
//  BaseNavigationController.m
//  gzprma
//
//  Created by apple on 14-1-12.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
//    [self.navigationController.navigationBar  setBackgroundImage: [UIImage imageNamed:@"www/images/01nav_mid.png"] forBarMetrics:UIBarMetricsDefault];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.view.bounds = CGRectMake(0, -20, 0, 0);
//    }
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    
//    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end