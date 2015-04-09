//
//  LYOAJobFormViewController.h
//  lyoaclient
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"

@interface LYOAJobFormViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sc;
@property (strong, nonatomic) IBOutlet UINavigationItem *tabItem;
@property (strong, nonatomic) IBOutlet UINavigationItem *ngItem;
@property (strong, nonatomic) IBOutlet  UINavigationBar *ngBar;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;
@property (strong,nonatomic) NSString *enterFormType;
@end
