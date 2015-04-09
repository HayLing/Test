//
//  LYOAMsgReportInfoViewController.h
//  lyoaclient
//
//  Created by apple on 14-8-3.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "BaseViewController.h"

@interface LYOAMsgReportInfoViewController : BaseViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSMutableData *connectionData;
    NSURLConnection *connection;
}

@property (nonatomic,retain) NSMutableData *connectionData;
@property (nonatomic,retain) NSURLConnection *connection;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *pathURL;
@property (strong,nonatomic) NSString *param;
@property (strong,nonatomic) NSString *enterFormType;
@property (strong,nonatomic) NSString *instanceId;
@end
