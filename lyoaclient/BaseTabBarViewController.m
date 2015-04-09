//
//  BaseTabBarViewController.m
//  lyoaclient
//
//  Created by apple on 14-6-10.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

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

    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor blackColor]];
    [customLab setText:@"应用"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;

    //高亮的时候，或者点击后的颜色设置。
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置字体的颜色。
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
//    [self.tabBarController setSelectedIndex:2];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString *title;
    if(item.tag == 1){
        //NSLog(@"TestOneController");
        title=@"应用";
    }else if(item.tag == 2){
//        NSLog(@"TestTwoController");
        title=@"消息";
    }else {
//        NSLog(@"TestThirdController");
        title=@"设置";
    }
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor blackColor]];
    [customLab setText:title];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
