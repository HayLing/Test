//
//  LYOAMessageViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAMessageViewController.h"
#import "Strings.h"

@interface LYOAMessageViewController ()<UIWebViewDelegate>

@end

@implementation LYOAMessageViewController

@synthesize webView;
@synthesize pathURL;
@synthesize param;
@synthesize enterFormType;

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
    
//    [self registerNotification];
    
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(20, 20, 30, 25);
//    [backButton setImage:[UIImage imageNamed:@"www/images/oa_ts1.png"] forState:UIControlStateNormal];
//    
//    [backButton setTitle:@"消息" forState:UIControlStateNormal];
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(1, -55, 0, -35)];
//    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
//    backButton.adjustsImageWhenHighlighted = NO;//去掉按钮点击时图片被画深色的功能
//    [backButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];//删除所有事件
//    [backButton setUserInteractionEnabled:NO];   //记得关 
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 35, 35);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/bszy_icon__01.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;

    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"消息"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    //webview 加载本地页面
    NSString *path = [[NSBundle mainBundle] pathForResource:@"www/oa_message/message" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rurl=[[request URL] absoluteString];
    
    //待阅
    if ([rurl hasPrefix:@"goread://"]) {
        pathURL = [rurl substringFromIndex:9];
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //页面跳转Luanchflow
        [self performSegueWithIdentifier:@"goread" sender:self];
    }
    
    //待阅表单
    if ([rurl hasPrefix:@"readform://"]) {
        pathURL = [rurl substringFromIndex:11];
        
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"msgtoform" sender:self];
    }
    
    
    //待办
    if ([rurl hasPrefix:@"gojob://"]) {
        pathURL = [rurl substringFromIndex:8];
        enterFormType = @"jobList";
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?title"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"gojob" sender:self];
    }
    
    //经营
    if ([rurl hasPrefix:@"goattention://"]) {
        pathURL = [rurl substringFromIndex:21];
        
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        
        //页面跳转
        [self performSegueWithIdentifier:@"gojyattention" sender:self];
    }
    
    //经营
    if ([rurl hasPrefix:@"js-alert://"]) {
        UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert1 show];
    }

    
    return  true;
}

//alert 点击事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:delPushMessage();"];
    }
    
}

//视图已完全过渡到屏幕上时调用
- (void)viewWillAppear:(BOOL)animated {
    [self.webView reload];
    
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
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([msgType isEqualToString:@"1"]){//待办
        enterFormType = @"pushJob";
        NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpPushMessageAction!getPushMessageById.do?pushMessage.id=%@",webUrl,msgId]];
        
        NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
        [toolbarRequest setURL:toolbarurl];
        [toolbarRequest setHTTPMethod:@"GET"];
        NSHTTPURLResponse* toolbarResponse;
        NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        
        pathURL = [dic objectForKey:@"formUrl"];
        param = [NSString stringWithFormat:@"%@,%@,%@,%@",[dic objectForKey:@"baseId"],[dic objectForKey:@"instanceId"],[dic objectForKey:@"jobId"],[dic objectForKey:@"round"]];
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"gojob" sender:self];
    }else{//待阅
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:getWfMsg('%@');",msgId]];
        pathURL = @"oa_readlist/readwaite.html?title=readlist";
        param =@"readlist";
        
        [self performSegueWithIdentifier:@"goread" sender:self];
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
    UIViewController* view = segue.destinationViewController;
    [view setValue:pathURL forKey:@"pathURL"];
    [view setValue:param forKey:@"param"];
    if ([[segue identifier] isEqualToString:@"gojob"]) {
        [view setValue:enterFormType forKey:@"enterFormType"];
    }
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}


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

@interface UIWebView (JavaScriptAlert)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame;

//-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame;
@end

@implementation UIWebView (JavaScriptAlert)

//static BOOL diagStat = NO;

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame{
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [dialogue show];
//    [dialogue autorelease];
}

/*-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame{
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:NSLocalizedString(@"Cancel", @"Cancel"), nil];
    [dialogue show];
    while (dialogue.hidden==NO && dialogue.superview!=nil) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
//    [dialogue release];
    
    return diagStat;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        diagStat=YES;
    }else if(buttonIndex==1){
        diagStat=NO;
    }
}*/
@end
