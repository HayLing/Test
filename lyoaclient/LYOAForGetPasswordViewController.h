//
//  LYOAForGetPasswordViewController.h
//  lyoaclient
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"

@interface LYOAForGetPasswordViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;
@end
