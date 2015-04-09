//
//  LYOACategoryViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-23.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOACategoryViewController.h"
#import "AppDictionary.h"
#import "SVProgressHUD.h"


NSString *enterFormType;
NSString *reload;

@interface LYOACategoryViewController ()
@end

@interface UINavigationItem (margin)
@end

//@implementation UINavigationItem (margin)
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
//- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
//{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -12;
//        
//        if (_leftBarButtonItem)
//        {
//            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
//        }
//        else
//        {
//            [self setLeftBarButtonItems:@[negativeSeperator]];
//        }
//        [negativeSeperator release];
//    }
//    else
//    {
//        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
//    }
//}
//
//- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
//{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -12;
//        
//        if (_rightBarButtonItem)
//        {
//            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
//        }
//        else
//        {
//            [self setRightBarButtonItems:@[negativeSeperator]];
//        }
//        [negativeSeperator release];
//    }
//    else
//    {
//        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
//    }
//}
//
//#endif
//@end

@implementation LYOACategoryViewController

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
    
    //[SVProgressHUD showWithStatus:@"数据加载中！"];
    
    //[self.navigationController  setToolbarHidden:YES animated:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 35, 35);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/bszy_icon__01.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    //待办和待阅添加刷新按钮  || [param isEqualToString:@"readlist"]
    if ([param isEqualToString:@"joblist"] ) {
        reload =param;
    }
    
    //加载本地页面
    NSRange range = [pathURL rangeOfString:@"?title"];
    int paramLength = 0;
    if (range.location != NSNotFound) {
        paramLength = (range.length + 1 + param.length);
        NSString *value = [[AppDictionary getMapString] valueForKey:param];
//         NSLog(@"%@",value);
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        [customLab setTextColor:[UIColor whiteColor]];
        [customLab setText:value];
        customLab.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = customLab;
//        self.navigationItem.title=value;
        
    }
    
    //经营指标模块
    NSRange range1 = [pathURL rangeOfString:@"?ch"];
    if (range1.location != NSNotFound) {
        paramLength = (range1.length + 1 + param.length);
        //将http转义字符转化为中文
        NSString *value = [param stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.navigationItem.title = value;
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
            reload =@"announcement";
        }
        //页面跳转Luanchflow
        [self performSegueWithIdentifier:@"Luanchflow" sender:self];
    }
    
    //待办跳转
    if ([rurl hasPrefix:@"js-job://"]) {
        pathURL = [rurl substringFromIndex:9];
        enterFormType = @"jobList";
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"Jobform" sender:self];
    }
    
    //加载页面地址
    if ([rurl hasPrefix:@"js-www://"]) {
        pathURL = [rurl substringFromIndex:16];
        //经营
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        
        //页面跳转
        [self performSegueWithIdentifier:@"Jyattention" sender:self];
    }

    //待阅表单
    if ([rurl hasPrefix:@"readform://"]) {
        pathURL = [rurl substringFromIndex:11];
        
        //根据字典查找标题
        NSRange range = [pathURL rangeOfString:@"?param"];
        if (range.location != NSNotFound) {
            param = [pathURL substringFromIndex:(range.location + range.length+1)];
        }
        reload = @"readform";
        
        //页面跳转Jobform
        [self performSegueWithIdentifier:@"apptoform" sender:self];
    }

    
    return  true;
}

//视图已完全过渡到屏幕上时调用
- (void)viewWillAppear:(BOOL)animated {
    if ([reload isEqualToString:@"joblist"] || [reload isEqualToString:@"announcement"]
        || [reload isEqualToString:@"readform"]) {
        [self.webView reload];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
    UIViewController* view = segue.destinationViewController;
    [view setValue:pathURL forKey:@"pathURL"];
    [view setValue:param forKey:@"param"];
    
    if ([[segue identifier] isEqualToString:@"Jobform"]) {
        [view setValue:enterFormType forKey:@"enterFormType"];
    }
    
}



//返回按钮
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true ];
}

- (void)reload:(UIButton *)sender
{
    [self.webView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
