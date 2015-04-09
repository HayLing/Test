//
//  LYOAMsgReportInfoViewController.m
//  lyoaclient
//
//  Created by apple on 14-8-3.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAMsgReportInfoViewController.h"
#import "SVProgressHUD.h"
#import "Strings.h"

NSString *htmlUrl;
NSString *htmlName;
UIAlertView *alert1;
UIAlertView*  alert2;

@interface LYOAMsgReportInfoViewController ()

@end

@implementation LYOAMsgReportInfoViewController

@synthesize webView;
@synthesize pathURL;
@synthesize param;
@synthesize enterFormType;
@synthesize instanceId;
@synthesize connectionData;
@synthesize connection;


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
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"审批轨迹"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
//    self.navigationItem.title = @"审批记录";
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"www/oa_joblist/recordlist" ofType:@"html" ];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接
    [SVProgressHUD dismiss];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:loadData('%@');",instanceId]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rurl=[[request URL] absoluteString];
    // Will execute this block only when links are clicked
    if ([rurl hasPrefix:@"url://"]) {
        rurl = [rurl substringFromIndex:13];
        NSArray *params = [rurl componentsSeparatedByString:@","];
        htmlUrl = [params objectAtIndex:0];
        htmlName = [[params objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"Download"];
        NSString *savePath=[myDirectory stringByAppendingPathComponent:htmlName];
        if ([fileManager fileExistsAtPath:savePath]) {
            alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@已下载，是否重新下载？",htmlName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        }else{
            alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要下载%@？",htmlName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        }
        
        [alert1 show];
        
    }
    return  true;
}

//alert 点击事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == alert1){
        if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
            //构建NSURL
            NSURL *fileUrl=[NSURL URLWithString:htmlUrl];
            //构建nsurlrequest
            NSURLRequest *request=[[NSURLRequest alloc]initWithURL:fileUrl];
            //建立连接
            NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
            //初始化connectionData;
            connectionData=[[NSMutableData alloc]init ];
        }
    }
    
    if(alertView == alert2){
        if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
            [self performSegueWithIdentifier:@"gofileview" sender:self];
        }
    }
    
}

//接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //获取服务器传递的数据
    [connectionData appendData:data];
}
//接收数据成功
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connectionData.length>0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"Download"];
        [fileManager createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];//创建Download目录
        
        NSString *savePath=[myDirectory stringByAppendingPathComponent:htmlName];
        //当数据写入的时候
        if ([connectionData writeToFile:savePath atomically:YES]) {
            alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下载成功,是否打开附件管理？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert2 show];
//            NSLog(@"保存成功");
        }else{
//            NSLog(@"保存失败");
        }
    }
}
//接收数据失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"error:%@",error);
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
