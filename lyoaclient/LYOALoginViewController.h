//
//  LYOALoginViewController.h
//  lyoaclient
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYOALoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;
@end
