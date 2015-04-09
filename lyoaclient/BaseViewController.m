//
//  BaseViewController.m
//  lyoaclient
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.view.bounds = CGRectMake(0, 20, 0,0 );
//    }
//    [self.navigationController.navigationBar  setBackgroundImage: [UIImage imageNamed:@"www/images/01nav_mid.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setBackgroundImage: [UIImage imageNamed:@"www/images/bgzzcolor.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
