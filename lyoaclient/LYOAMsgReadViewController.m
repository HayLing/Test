//
//  LYOAMsgReadViewController.m
//  lyoaclient
//
//  Created by apple on 14-8-1.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAMsgReadViewController.h"
#import "AppDictionary.h"

@interface LYOAMsgReadViewController ()<UIWebViewDelegate>

@end

@implementation LYOAMsgReadViewController

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
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"www/%@",[pathURL substringToIndex:index]] ofType:@"html" ];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"www/oa_setting/settingAbout" ofType:@"html"];
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
    
    //待办跳转
    if ([rurl hasPrefix:@"readform://"]) {
        pathURL = [rurl substringFromIndex:11];
       
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"goreadform" sender:self];
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
    [self.navigationController popViewControllerAnimated:true ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
