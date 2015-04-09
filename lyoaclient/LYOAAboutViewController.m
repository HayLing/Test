//
//  LYOAAboutViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAAboutViewController.h"
#import "LYOAAppDelegate.h"
#import "AppDictionary.h"
#import "Strings.h"

extern NSTimer *myTimer;
NSString *num;

@interface LYOAAboutViewController ()

@end

@implementation LYOAAboutViewController

@synthesize webView;
@synthesize pathURL;
@synthesize param;

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 35, 35);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/bszy_icon__01.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationController.navigationItem.leftBarButtonItem =backBarButton;
    
    num=@"0";
    //加载本地页面
    NSRange range = [pathURL rangeOfString:@"?title"];
    int paramLength = 0;
    if (range.location != NSNotFound) {
        paramLength = (range.length + 1 + param.length);
        NSString *value = [[AppDictionary getMapString] valueForKey:param];
//        NSLog(@"%@",value);
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        [customLab setTextColor:[UIColor whiteColor]];
        [customLab setText:value];
        customLab.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = customLab;
//        self.navigationItem.title = value;
    }
    
    //webview 加载本地页面
    int index = pathURL.length-5-paramLength;
//    NSLog(@"%@",pathURL);
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"www/%@",[pathURL substringToIndex:index]] ofType:@"html" ];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time;
    if ([param isEqualToString:@"pushMsg"]) {
        if([num isEqualToString:@"0"]){
            time =[user objectForKey:@"msgtime"];
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:loadQdInfo(%@);",time]];
            num =@"1";//锁定,只调用一次
        }
        
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rurl=[[request URL] absoluteString];
    if ([rurl hasPrefix:@"js-call://"]) {
        NSString *path = [rurl substringFromIndex:17];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:path forKey:@"msgtime"];
        if([path isEqualToString:@"0"]){
            if (myTimer) {
                if([myTimer isValid]) {
                    [myTimer invalidate];
                }
                myTimer=nil;
            }
        }else{
            if (myTimer) {
                if([myTimer isValid]) {
                    [myTimer invalidate];
                }
                myTimer=nil;
            }
            myTimer = [NSTimer timerWithTimeInterval:[path intValue] target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSRunLoopCommonModes];
        }
        
    }
    //onload事件
    if ([rurl hasPrefix:@"onload://"]) {
         NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//        NSLog(@"版本号：%@",version);
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:getName('%@');",version]];
    }

   
    return  true;
}

- (void)scrollTimer{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpClientCommonAction!getData.do?mark=showMsg&pushMessage.userid=%@&pushMessage.msgstatus=1",webUrl,[user objectForKey:@"id"]]];
    
    NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
    [toolbarRequest setURL:toolbarurl];
    [toolbarRequest setHTTPMethod:@"GET"];
    NSHTTPURLResponse* toolbarResponse;
    NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json != nil) {
        for (NSDictionary *asony in json) {
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                
                NSDate *now=[NSDate new];
//                NSLog(@"now:%@",now);
                notification.fireDate=[now dateByAddingTimeInterval:1];//1秒后通知
                
                //循环次数，kCFCalendarUnitWeekday一周一次
                notification.repeatInterval = 0;
                
                notification.timeZone=[NSTimeZone localTimeZone];
                notification.soundName= UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber = 0;
                
                NSString *type = [asony objectForKey:@"messageType"];
                NSString *content;
                if ([type isEqualToString:@"1"]) {
                    content = [NSString stringWithFormat:@"待办应用：接收到工单%@",[asony objectForKey:@"snumber"]];
                }
                if ([type isEqualToString:@"2"]) {
                    content =@"待阅应用：收到一条新待阅信息。";
                }
                if ([type isEqualToString:@"3"]) {
                    content = [NSString stringWithFormat:@"经营指标：%@",[asony objectForKey:@"reportName"]];
                }
                notification.alertBody = [NSString stringWithFormat:@"%@",content];//提示信息 弹出提示框
                [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //注册
                [notification release];
                
            }
        }
        
    }
    
}

//返回按钮
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
