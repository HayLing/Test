//
//  LYOALoginViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOALoginViewController.h"
#import "Strings.h"

NSString *isnum = @"0";


@interface LYOALoginViewController ()

@end

@implementation LYOALoginViewController

@synthesize webView;
@synthesize param;
@synthesize pathURL;

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
//    self.navigationItem
//    [self.navigationController  setToolbarHidden:YES animated:YES];
	// Do any additional setup after loading the view.
    //webview 加载本地页面
    NSString *path = [[NSBundle mainBundle] pathForResource:@"www/login/login" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
//    [self.view addSubview:webView];
    self.webView.scrollView.bounces = NO;
    

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rurl=[[request URL] absoluteString];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //登录成功
    if ([rurl hasPrefix:@"js-call://"]) {
        isnum = @"1";
        NSString *param = [rurl substringFromIndex:17];
        NSArray *params = [[param stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
        NSString *id, *loginId, *name, *pwd, *isMemory ,*msisdn;
        id = [params objectAtIndex:0];
        loginId = [params objectAtIndex:1];
        name = [params objectAtIndex:2];
        pwd = [params objectAtIndex:3];
        isMemory = [params objectAtIndex:4];
        //保存用户信息
        [user setObject:id forKey:@"id"];
        [user setObject:loginId forKey:@"loginId"];
        [user setObject:name forKey:@"name"];
        [user setObject:pwd forKey:@"pwd"];
        [user setObject:isMemory forKey:@"isMemory"];
        [user setObject:msisdn forKey:@"msisdn"];
        
       /* NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpUserLoginAction!updateDeviceToken.do?user.deviceToken=%@&user.id=%@",webUrl,[user objectForKey:@"didRegister_deviceToken"],id]];
        
        NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
        [toolbarRequest setURL:toolbarurl];
        [toolbarRequest setHTTPMethod:@"POST"];
        NSHTTPURLResponse* toolbarResponse;
        NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
        NSString* result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        if (result) {
            NSLog(@"修改设备ID成功");
        }else{
            NSLog(@"修改设备ID失败");
        }
        */
        //页面跳转
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
    if ([rurl hasPrefix:@"getpwd://"]) {

        [self performSegueWithIdentifier:@"getpwd" sender:self];
    }

    return  true;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
//    if ([[segue identifier] isEqualToString:@"getpwd"]) {
//        UIViewController* view = segue.destinationViewController;
//        [view setValue:pathURL forKey:@"pathURL"];
//        [view setValue:param forKey:@"param"];
//    }
//    
//}

//视图已完全过渡到屏幕上时调用
//- (void)viewWillAppear:(BOOL)animated {
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@",[user objectForKey:@"didRegister_deviceToken"]);
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setDevice('%@');",[user objectForKey:@"didRegister_deviceToken"]]];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
