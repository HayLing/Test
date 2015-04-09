//
//  LYOAMsgJobViewController.h
//  lyoaclient
//
//  Created by apple on 14-8-3.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"

@interface LYOAMsgJobViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationBar *uiBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *uiItem;
@property (strong, nonatomic) IBOutlet UISegmentedControl *uiSC;
@property (strong, nonatomic) UISegmentedControl *toolSC;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;
@property (strong,nonatomic) NSString *enterFormType;
@end
