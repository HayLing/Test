//
//  LYOAJyattentionViewController.m
//  lyoaclient
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAJyattentionViewController.h"
#import "Strings.h"
#import "AppDictionary.h"

@interface LYOAJyattentionViewController ()

@end

@implementation LYOAJyattentionViewController


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
    
    NSString *path= @"";
    
    NSRange range = [pathURL rangeOfString:@"?param"];
    if (range.location != NSNotFound) {
        NSString *value =[[pathURL substringToIndex:(range.location)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        [customLab setTextColor:[UIColor whiteColor]];
        [customLab setText:value];
        customLab.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = customLab;
//        self.navigationItem.title = value;
        
        NSArray *params = [param componentsSeparatedByString:@","];
        NSString *reportid = [params objectAtIndex:0];
        NSString *indexListType = [params objectAtIndex:1];
        path = [NSString stringWithFormat:@"%@%@?report.id=%@&indexListType=%@", webUrl, jyreportUrl, reportid, indexListType];
    }
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
//    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接
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
