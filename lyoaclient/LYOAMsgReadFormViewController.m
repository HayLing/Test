//
//  LYOAMsgReadFormViewController.m
//  lyoaclient
//
//  Created by apple on 14-8-3.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAMsgReadFormViewController.h"
#import "Strings.h"
#import "AppDictionary.h"
#import "SVProgressHUD.h"

NSString *userId;

@interface LYOAMsgReadFormViewController ()

@end

@implementation LYOAMsgReadFormViewController

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
    [SVProgressHUD showWithStatus:@"数据加载中！"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 35, 35);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/bszy_icon__01.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationController.navigationItem.leftBarButtonItem =backBarButton;
    
    NSArray *params = [param componentsSeparatedByString:@","];
    NSString *tieleid = [params objectAtIndex:0];
    NSString *wvFormUrl = [params objectAtIndex:1];
    //标题
    NSString *value = [[AppDictionary getMapString] valueForKey:tieleid];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:value];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
//    self.navigationItem.title = value;
    
    
    //替换地址路径
    NSMutableString *StrUrl = [[NSMutableString alloc] initWithString:wvFormUrl];
    NSRange range = [wvFormUrl rangeOfString:@".do"];
    if (range.location != NSNotFound) {
        [StrUrl insertString:@"ForAndroid" atIndex:range.location];
//        NSLog(@"String1:%@",StrUrl);
    }
    range = [wvFormUrl rangeOfString:@".jsp"];
    if (range.location != NSNotFound) {
        [StrUrl insertString:@"ForAndroid" atIndex:range.location];
//        NSLog(@"String1:%@",StrUrl);
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    userId = [user objectForKey:@"id"];
    
    NSString *path = [NSString stringWithFormat:@"%@/submitFormAction!goToAddFormInfoForAndroid.do?mark=readStdy&jobUrl=%@&isClient=1&userId=%@", webUrl, StrUrl,userId];
    
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
//    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接
}
//加载完数据
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

//返回按钮
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true ];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
