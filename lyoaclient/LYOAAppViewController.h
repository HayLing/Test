//
//  LYOAAppViewController.h
//  lyoaclient
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"
#import "PopoverView.h"

@interface LYOAAppViewController : BaseViewController <UIWebViewDelegate,PopoverViewDelegate>{
//    IBOutlet UIWebView* webView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;


@end
