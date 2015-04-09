//
//  LYOAAppViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAAppViewController.h"
#import "sys/utsname.h"
#import "Strings.h"
#import "LYOAAppDelegate.h"
#import "KxMenu.h"
#import "LYOAAppDelegate.h"
#import "PopoverView.h"
#import "WCAlertView.h"

NSString *enterFormType;
BOOL isShow =true;
UIView *popView;
extern NSTimer *myTimer;

@interface LYOAAppViewController ()

@end

@implementation LYOAAppViewController

@synthesize webView;
@synthesize param;
@synthesize pathURL;
//@synthesize myTimer;

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
    
    [self registerNotification];
    
    //左图
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 150, 26);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/login/logo_2.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted = NO;//去掉按钮点击时图片被画深色的功能
    [backButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];//删除所有事件
    [backButton setUserInteractionEnabled:NO];   //记得关
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    //右图
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame =  CGRectMake(0, 0, 30, 30);
    menuButton.backgroundColor = [UIColor clearColor];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"www/images/01icon_2.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = menuBarButton;

    //同步cookie
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString* cookiepath = [NSString stringWithFormat:@"%@%@?loginId=%@&password=%@", webUrl, webloginUrl,[user objectForKey:@"loginId"],[user objectForKey:@"pwd"]];
    NSURL *cookieurl = [NSURL URLWithString:cookiepath];
    NSURLRequest *cookierequest = [NSURLRequest requestWithURL:cookieurl];
    [NSURLConnection sendSynchronousRequest:cookierequest returningResponse:nil error:nil];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        NSLog(@"%@", cookie);
        //设置cookie
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    //webview 加载本地页面
    NSString *path = [[NSBundle mainBundle] pathForResource:@"www/oa_appcenter/appIndex" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接
    
    //每600s调用一次scrollTimer  只循环一次 repeats:NO 为单循环 YES为重复循环
    NSString *nstime =[user objectForKey:@"msgtime"];
    if([nstime isEqualToString:@"0"]){
        //0为不接收，不启动
    }else if (nstime == nil) {//默认为10分钟，以秒为单位600
        myTimer = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSRunLoopCommonModes];
    }else{
        myTimer = [NSTimer timerWithTimeInterval:[nstime intValue] target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSRunLoopCommonModes];
    }

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rurl=[[request URL] absoluteString];
    //oa系统跳转
    if ([rurl hasPrefix:@"js-call://"]) {
        pathURL = [rurl substringFromIndex:10];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //已给出标题
        NSRange range1 = [pathURL rangeOfString:@"?ch"];
        if (range1.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range1.location + range1.length+1)];
        }
        //页面跳转
        [self performSegueWithIdentifier:@"Category" sender:self];
    }
    
    //消息
    if ([rurl hasPrefix:@"js-msg://"]) {
        //页面跳转
        [self performSegueWithIdentifier:@"tomsg" sender:self];
    }

    
    //行为轨迹
    if ([rurl hasPrefix:@"channel://"]) {
        pathURL = [rurl substringFromIndex:10];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //已给出标题
        NSRange range1 = [pathURL rangeOfString:@"?ch"];
        if (range1.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range1.location + range1.length+1)];
        }
        //页面跳转
        [self performSegueWithIdentifier:@"behaviorTraceIndex" sender:self];
    }
    //走访日记
    if ([rurl hasPrefix:@"js-log://"]) {
        pathURL = [rurl substringFromIndex:9];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //页面跳转
        [self performSegueWithIdentifier:@"SearchLog" sender:self];
    }
    //渠道反馈
    if ([rurl hasPrefix:@"feedback://"]) {
        pathURL = [rurl substringFromIndex:11];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
            
        }
        //页面跳转
        [self performSegueWithIdentifier:@"feedback" sender:self];
    }
    //渠道预约
    if ([rurl hasPrefix:@"appointment://"]) {
        pathURL = [rurl substringFromIndex:14];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
            
        }
        //页面跳转
        [self performSegueWithIdentifier:@"appointment" sender:self];
    }

    return  true;
}

//注册通知
- (void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:)
												 name:@"pushNotification" object:nil];
}

-(void)pushNotification:(NSNotification *)notification{
    NSString *msgType = [notification.userInfo objectForKey:@"messageType"];
    NSString *msgId = [notification.userInfo objectForKey:@"msgId"];
    if([msgType isEqualToString:@"1"]){//待办
        enterFormType = @"pushJob";
        NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpClientCommonAction!getData.do?mark=jobInfo&pushMessage.id=%@",webUrl,msgId]];
        
        NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
        [toolbarRequest setURL:toolbarurl];
        [toolbarRequest setHTTPMethod:@"GET"];
        NSHTTPURLResponse* toolbarResponse;
        NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        if (dic == nil) {
//            NSLog(@"json parse failed \r\n");
            return;
        }
        pathURL = [dic objectForKey:@"formUrl"];
        param = [NSString stringWithFormat:@"%@,%@,%@,%@",[dic objectForKey:@"baseId"],[dic objectForKey:@"instanceId"],[dic objectForKey:@"jobId"],[dic objectForKey:@"round"]];
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"appgojob" sender:self];
    }else{//待阅
        
        NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpClientCommonAction!getData.do?mark=daiyue&msgId=%@",webUrl,msgId]];
        NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
        [toolbarRequest setURL:toolbarurl];
        [toolbarRequest setHTTPMethod:@"GET"];
        NSHTTPURLResponse* toolbarResponse;
        NSError *error;
        NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (json == nil) {
//            NSLog(@"json parse failed \r\n");
            return;
        }
        
        for (NSDictionary *asony in json) {
            NSString *formUrl = [asony objectForKey:@"wvFormUrl"];
            param =[@"readform," stringByAppendingString:formUrl];
            [self performSegueWithIdentifier:@"toreadform" sender:self];
            break;
        }
    }
    
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
                NSString *msgId = @"";
                NSString *content;
                if ([type isEqualToString:@"1"]) {
                    content = [NSString stringWithFormat:@"待办应用：接收到工单%@",[asony objectForKey:@"snumber"]];
                    msgId = [asony objectForKey:@"pushId"];
                }
                if ([type isEqualToString:@"2"]) {
                    content =@"待阅应用：收到一条新待阅信息。";
                    msgId = [asony objectForKey:@"msgId"];
                }
                if ([type isEqualToString:@"3"]) {
                    content = [NSString stringWithFormat:@"经营指标：%@",[asony objectForKey:@"reportName"]];
                }
                //创建词典对象，初始化长度为10
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:32];
                //向词典中动态添加数据
                [dictionary setObject:type forKey:@"messageType"];
                [dictionary setObject:msgId forKey:@"msgId"];
                notification.userInfo = dictionary;
                notification.alertBody = [NSString stringWithFormat:@"%@",content];//提示信息 弹出提示框
                [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //注册
                [notification release];
                
            }
        }
        
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
    UIViewController* view = segue.destinationViewController;
    [view setValue:pathURL forKey:@"pathURL"];
    [view setValue:param forKey:@"param"];
    if ([[segue identifier] isEqualToString:@"appgojob"]) {
        [view setValue:enterFormType forKey:@"enterFormType"];
    }
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];

}

//视图已完全过渡到屏幕上时调用
- (void)viewWillAppear:(BOOL)animated {
    //获取待办，待阅数量
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:getWiateReadAndWorkFlowNumber();"];

}


//返回按钮
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true ];
}

- (void)showMenu:(UIButton *)sender
{
    if(isShow){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *menuItems =
        @[
          
          [KxMenuItem menuItem:[user objectForKey:@"name"]
                         image:[UIImage imageNamed:@"www/images/oa_app/04icon1_1"]
                        target:self
                        action:nil],
          
          [KxMenuItem menuItem:@"切换帐号"
                         image:[UIImage imageNamed:@"www/images/oa_app/04icon2_1"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"设置"
                         image: [UIImage imageNamed:@"www/images/oa_app/04icon3_1"]
                        target:self
                        action:@selector(pushMenuItem:)],
        
          [KxMenuItem menuItem:@"退出"
                       image:[UIImage imageNamed:@"www/images/oa_app/04icon4_1"]
                      target:self
                      action:@selector(pushMenuItem:)],

          ];
//        CGRect newFrame = sender.frame;
//        newFrame.size.height = newFrame.size.height - 65;;
        [KxMenu showMenuInView:self.view
                      fromRect:sender.frame
                     menuItems:menuItems];
        
        isShow=false;
    }else{
        [KxMenu dismissMenu];
        isShow=true;
    }
    
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *menuItem = (KxMenuItem *)sender;
    NSString *title = menuItem.title;
    if([title isEqualToString:@"切换帐号"]){
//        [self performSegueWithIdentifier:@"signOut" sender:self];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if ([title isEqualToString:@"设置"]){
        param=nil;
        pathURL=nil;
        [self performSegueWithIdentifier:@"toset" sender:self];
    }else if ([title isEqualToString:@"退出"]){        
        [WCAlertView showAlertWithTitle:@"提示" message:@"确定要退出吗？" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhiteHatched;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 1) {  //确定
                exit(0);
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    isShow=true;
;}

//alert 点击事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
        
    }
}

//退出应用
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    
    [UIView commitAnimations];
    
}


//退出实现方法
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
