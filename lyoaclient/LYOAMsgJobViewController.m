//
//  LYOAMsgJobViewController.m
//  lyoaclient
//
//  Created by apple on 14-8-3.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "LYOAMsgJobViewController.h"
#import "Strings.h"
#import "SVProgressHUD.h"
#import "GDataXMLNode.h"

NSMutableArray *nsarray;
NSString *baseid, *instanceid, *jobid, *rounid, *formurl;
NSString *formtag= @"0";
UINavigationBar *uiBar;
UISegmentedControl *segmentedController;
UIToolbar *toolbar;
NSString *userId;

@interface LYOAMsgJobViewController ()

@end

@implementation LYOAMsgJobViewController

@synthesize webView;
@synthesize uiSC;
//@synthesize uiBar;
//@synthesize uiItem;
@synthesize toolSC;
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
//    [SVProgressHUD showWithStatus:@"数据加载中！"];
    
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
    [customLab setText:@"待办"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
//    self.navigationItem.title = @"待办";
    
    //给头部segmentedController添加事件
    [self.uiSC addTarget:self action:@selector(scAction:) forControlEvents:UIControlEventValueChanged];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    userId = [user objectForKey:@"id"];
    NSArray *params = [param componentsSeparatedByString:@","];
    
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        baseid = [params objectAtIndex:0];
        instanceid = [params objectAtIndex:1];
        jobid = [params objectAtIndex:2];
        rounid = [params objectAtIndex:3];
        formurl = [params objectAtIndex:4];
    }else{//推送消息进来
        baseid = [params objectAtIndex:0];
        instanceid = [params objectAtIndex:1];
        jobid = [params objectAtIndex:2];
        rounid = [params objectAtIndex:3];
    }
    
//    NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@getWfToolbarByJobAndInstanceId.do?jobId=%@&instanceId=%@&userId=%@&baseId=%@",webUrl,toolBarService,jobid,instanceid,userId,baseid]];
    
    NSURL *toolbarurl = [NSURL URLWithString: [NSString stringWithFormat:@"%@/httpClientCommonAction!getData.do?mark=tooBarService&jobId=%@&instanceId=%@&userId=%@&baseId=%@",webUrl,jobid,instanceid,userId,baseid]];
    
    NSMutableURLRequest* toolbarRequest = [NSMutableURLRequest new];
    [toolbarRequest setURL:toolbarurl];
    [toolbarRequest setHTTPMethod:@"GET"];
    NSHTTPURLResponse* toolbarResponse;
    NSData* data = [NSURLConnection sendSynchronousRequest:toolbarRequest returningResponse:&toolbarResponse error:nil];
    NSString* responseXMLResult = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString: responseXMLResult options:0 error:&error];
    if (doc == nil) { return; }
    NSArray *partyMembers = [doc.rootElement nodesForXPath:@"//response" error:nil];
    
    nsarray = [[NSMutableArray alloc] init];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        NSString *_name;
        NSArray *names = [partyMember nodesForXPath:@"body" error:nil];
        if (names.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            _name = firstName.stringValue;
        } else continue;
        NSData *jsonData = [_name dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (json == nil) {
//            NSLog(@"json parse failed \r\n");
            return;
        }
        
        for (NSDictionary *asony in json) {
            NSDictionary *toolbar = [[asony objectForKey:@"wfActToolbar"] valueForKey:@"wfToolbar"];
            NSString *type = [toolbar objectForKey:@"type"];
            NSString *name = [[asony objectForKey:@"wfActToolbar"] valueForKey:@"name"];
//            NSString *alias = [[asony objectForKey:@"wfActToolbar"] valueForKey:@"alias"];
            if ([type isEqualToString:@"1"]) {//提交
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                backButton.frame =  CGRectMake(0, 0, 70, 30);
                backButton.backgroundColor = [UIColor clearColor];
                
                [backButton setImage:[UIImage imageNamed:@"www/images/01.png"] forState:UIControlStateNormal];
                if ([name isEqualToString:@"办结工单"]) {
                    name = @"办结";
                }
                
                UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 50, 30)];
                [customLab setTextColor:[UIColor whiteColor]];
                [customLab setText:name];
                customLab.font = [UIFont boldSystemFontOfSize:18];
                [backButton addSubview:customLab];
                [backButton setTag:1];
                [backButton addTarget:self action:@selector(toolBarItem1:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                [nsarray addObject: customItem1];
                [nsarray addObject: spaceItem];
            }else if ([type isEqualToString:@"t11"]) {//提交
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                backButton.frame =  CGRectMake(0, 0, 70, 30);
                backButton.backgroundColor = [UIColor clearColor];
                
                [backButton setImage:[UIImage imageNamed:@"www/images/01.png"] forState:UIControlStateNormal];
                
                
                UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 50, 30)];
                [customLab setTextColor:[UIColor whiteColor]];
                [customLab setText:name];
                customLab.font = [UIFont boldSystemFontOfSize:18];
                [backButton addSubview:customLab];
                
                [backButton addTarget:self action:@selector(toolBarItem1:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                [nsarray addObject: customItem1];
                [nsarray addObject: spaceItem];
            }else if ([type isEqualToString:@"3"]) {//委托
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                backButton.frame =  CGRectMake(0, 0, 70, 30);
                backButton.backgroundColor = [UIColor clearColor];
                
                [backButton setImage:[UIImage imageNamed:@"www/images/02.png"] forState:UIControlStateNormal];
                
                
                UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 50, 30)];
                [customLab setTextColor:[UIColor whiteColor]];
                [customLab setText:name];
                customLab.font = [UIFont boldSystemFontOfSize:18];
                [backButton addSubview:customLab];

                [backButton addTarget:self action:@selector(toolBarItem2:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                [nsarray addObject: customItem1];
                [nsarray addObject: spaceItem];
            }else if ([type isEqualToString:@"t10"] ) {//回退
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                backButton.frame =  CGRectMake(0, 0, 70, 30);
                backButton.backgroundColor = [UIColor clearColor];
                
                [backButton setImage:[UIImage imageNamed:@"www/images/03.png"] forState:UIControlStateNormal];
                
                
                UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 50, 30)];
                [customLab setTextColor:[UIColor whiteColor]];
                [customLab setText:[name substringToIndex:2]];
                customLab.font = [UIFont boldSystemFontOfSize:18];
                
                [backButton addSubview:customLab];

                [backButton addTarget:self action:@selector(toolBarItem3:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                [nsarray addObject: customItem1];

            }
            
        }
    }
    
    if ([nsarray count] != 0) {
        toolbar = [[UIToolbar alloc]initWithFrame:
                              CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, 320, 44)];
        [toolbar setBarStyle:UIBarStyleBlack];
        
        [self.view addSubview:toolbar];
        [toolbar setItems:nsarray];
        
    }else{
        [toolbar  setHidden:YES];
        
        CGRect newFrame = self.webView.frame;
        newFrame.size.height = newFrame.size.height + 44;
        self.webView.frame = newFrame;
    }
    NSString *result=@"";
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        result = formurl;
    }else{
        result = pathURL;
    }
    
    //替换地址路径
    NSMutableString *StrUrl = [[NSMutableString alloc] initWithString:result];
    NSRange range = [result rangeOfString:@".do"];
    if (range.location != NSNotFound) {
        [StrUrl insertString:@"ForAndroid" atIndex:range.location];
//        NSLog(@"String1:%@",StrUrl);
    }
    range = [result rangeOfString:@".jsp"];
    if (range.location != NSNotFound) {
        [StrUrl insertString:@"ForAndroid" atIndex:range.location];
//        NSLog(@"String1:%@",StrUrl);
    }
    
    //2014-12-12修改：没有toolbar按钮，表单不可编辑，
    NSString *readonly = @"&isClient=1&isReadonly=0";
    if ([nsarray count] != 0) {
        readonly = @"&isClient=1";
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/submitFormAction!goToAddFormInfoForAndroid.do?mark=joblisting&jobUrl=%@&userId=%@%@", webUrl, StrUrl,userId,readonly];
    
    
    NSURL *weburl = [NSURL URLWithString:path];
    NSURLRequest *webrequest = [NSURLRequest requestWithURL:weburl];
    [self.webView loadRequest:webrequest];
    [self.webView setDelegate: self];
    [self.view addSubview:webView];
//    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止数字链接
//    [SVProgressHUD dismiss];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
//    NSLog(@"%@",url);
    NSString *urlStr = [url absoluteString];
    NSRange range = [urlStr rangeOfString:@"flag=success"];//提交
    NSRange range2 = [urlStr rangeOfString:@"rollbackToDelActList.do"];//回退
    NSRange range3 = [urlStr rangeOfString:@"saveTransmitAndroid.do"];//转交
    NSRange range4 = [urlStr rangeOfString:@"directType=return"];//返回
    NSRange range5 = [urlStr rangeOfString:@"toWfConfirmPluginFormForAndroid.do"];//隐藏titleView
    NSRange range6 = [urlStr rangeOfString:@"toolbarType=3"];//委托
    NSRange range7 = [urlStr rangeOfString:@"toolbarType=t10"];//回退
    NSRange range8 = [urlStr rangeOfString:@"forandroidSuccess.jsp"];//转交
    NSRange range9 = [urlStr rangeOfString:@"toolbarType=1"];//提交按钮
    NSRange range10 = [urlStr rangeOfString:@"toolbarType=t11"];//提交按钮
    NSRange range11 = [urlStr rangeOfString:@"mark=submitOpinion"];//提交-确定按钮
    NSRange range12 = [urlStr rangeOfString:@"mark=entrustSubmit"];//委托-确定按钮
    NSRange range13 = [urlStr rangeOfString:@"mark=rollbackLink"];//回退-确定按钮
    if (range.location != NSNotFound || range2.location!=NSNotFound || range3.location!=NSNotFound || range8.location!=NSNotFound || range11.location!=NSNotFound || range12.location!=NSNotFound || range13.location!=NSNotFound) {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [msg show];
    }
    if (range4.location != NSNotFound ) {
        [toolbar  setHidden:NO];//显示toolbar
        //动态改webview高度
        CGRect newFrame = self.webView.frame;
        newFrame.size.height = newFrame.size.height -44;
        self.webView.frame = newFrame;
        formtag = @"1";
    }
    if (range5.location != NSNotFound || range6.location!=NSNotFound || range7.location!=NSNotFound
        || range9.location!=NSNotFound || range10.location!=NSNotFound) {
        [toolbar  setHidden:YES];//隐藏toolbar
        //动态改webview高度
        CGRect newFrame = self.webView.frame;
        newFrame.size.height = newFrame.size.height + 44;
        self.webView.frame = newFrame;
        formtag = @"2";
    }
    return YES;
}

//alert 点击事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
        formtag = @"0";
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//视图已完全过渡到屏幕上时调用
- (void)viewWillAppear:(BOOL)animated {
    if ([formtag isEqualToString:@"2"]) {
        formtag = @"0";
        [toolbar  setHidden:YES];//隐藏toolbar
    }
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//返回按钮
- (IBAction)backAction:(id)sender
{
    formtag = @"0";
    [self.navigationController popViewControllerAnimated:true ];
}

//头部tabbar事件
-(void)scAction:(id)sender
{
    switch([sender selectedSegmentIndex])
    {
        case 0:
            break;
        case 1:
            //跳转审批记录
            [self performSegueWithIdentifier:@"goJyreportInfo" sender:self];
            self.uiSC.selectedSegmentIndex = 0;
            break;
        default:
//            NSLog(@"无效事件");
            break;
    }
}

//底部tabbar事件
-(void)segmentAction:(id)sender
{
    NSString *toolstr = [nsarray objectAtIndex:[sender selectedSegmentIndex]];
    NSString *url;
    NSString *tag = nil;
    NSString *result=@"";
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        result = formurl;
    }else{
        result = pathURL;
    }
    if([toolstr isEqualToString:@"提交"]){
        tag =@"1";
    }else if([toolstr isEqualToString:@"驳回"]){
        tag =@"7";
    }else if([toolstr isEqualToString:@"暂缓"]){
        tag = @"0";
    }else{
//        NSLog(@"其他:%@",toolstr);
    }
    NSRange range = [result rangeOfString:@"!"];
    NSString *actionUrl = [result substringToIndex:range.location+1];
    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&toolbarType=%@",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,tag];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:formSubmitByUrl('%@');",url]];
}

//view之间传递数据
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",pathURL);
//    NSLog(@"%@",param);
    UIViewController* view = segue.destinationViewController;
    [view setValue:pathURL forKey:@"pathURL"];
    [view setValue:param forKey:@"param"];
    [view setValue:instanceid forKey:@"instanceId"];
    [view setValue:enterFormType forKey:@"enterFormType"];
    
    
}

//类型1、t11的事件
-(IBAction)toolBarItem1:(id)sender{
    NSString *url;
    NSString *tag = @"t11";
    if ([sender tag] == 1) {
        tag = @"1";
    }
    NSString *result=@"";
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        result = formurl;
    }else{
        result = pathURL;
    }
    NSRange range = [result rangeOfString:@"!"];
    NSString *actionUrl = [result substringToIndex:range.location+1];
    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&round=%@&toolbarType=%@&mark=scheduleFlow&userId=%@",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,rounid,tag,userId];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:formSubmitByUrl('%@');",url]];
}

-(IBAction)toolBarItem2:(id)sender{
    NSString *url;
    NSString *tag = @"3";
    NSString *result=@"";
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        result = formurl;
    }else{
        result = pathURL;
    }
    NSRange range = [result rangeOfString:@"!"];
    NSString *actionUrl = [result substringToIndex:range.location+1];
//    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&toolbarType=%@&mark=scheduleFlow",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,tag];
    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&round=%@&toolbarType=%@&mark=scheduleFlow&userId=%@",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,rounid,tag,userId];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:formSubmitByUrl('%@');",url]];

}
-(IBAction)toolBarItem3:(id)sender{
    NSString *url;
    NSString *tag = @"t10";
    NSString *result=@"";
    if ([enterFormType isEqualToString:@"jobList"]) {//从待办进来
        result = formurl;
    }else{
        result = pathURL;
    }
    NSRange range = [result rangeOfString:@"!"];
    NSString *actionUrl = [result substringToIndex:range.location+1];
//    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&toolbarType=%@&mark=scheduleFlow",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,tag];
    url = [NSString stringWithFormat:@"%@%@%@?baseId=%@&instanceId=%@&jobId=%@&round=%@&toolbarType=%@&mark=scheduleFlow&userId=%@",webUrl,actionUrl,approvalformUrl,baseid,instanceid,jobid,rounid,tag,userId];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:formSubmitByUrl('%@');",url]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
