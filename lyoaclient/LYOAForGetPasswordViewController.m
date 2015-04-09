//
//  LYOAForGetPasswordViewController.m
//  lyoaclient
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAForGetPasswordViewController.h"
#import "AppDictionary.h"

@interface LYOAForGetPasswordViewController ()

@end

@implementation LYOAForGetPasswordViewController

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
  
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"重置密码"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
//    self.navigationItem.title = @"重置密码";
    
    
    //webview 加载本地页面
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"www/oa_forgetpassword/forgetpassword" ofType:@"html" ];
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
    
    //加载本地html
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
        
        //公告管理
        NSRange range2 = [pathURL rangeOfString:@"?param"];
        if (range2.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range2.location + range2.length+1)];
        }
        //页面跳转Luanchflow
        [self performSegueWithIdentifier:@"Luanchflow" sender:self];
    }
    
    
    return  true;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
    UIViewController* view = segue.destinationViewController;
    [view setValue:pathURL forKey:@"pathURL"];
    [view setValue:param forKey:@"param"];
}


//返回按钮
- (IBAction)backAction:(id)sender
{
//    [self.navigationController popViewControllerAnimated:true ];
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
