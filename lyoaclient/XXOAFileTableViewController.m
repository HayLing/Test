//
//  XXOAFileTableViewController.m
//  xxoaclient
//
//  Created by apple on 14-8-21.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "XXOAFileTableViewController.h"

NSIndexPath *indexCell;
UIDocumentInteractionController *controller;
NSFileManager *fileManager;

@interface XXOAFileTableViewController ()

@end

@implementation XXOAFileTableViewController

@synthesize mdata;
@synthesize fileview;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 35, 35);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"www/images/bszy_icon__01.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"附件管理"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
//    self.navigationItem.title = @"附件管理";
    
    fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    　NSString *documentDir = [documentPaths objectAtIndex:0] ;
    NSString *myDirectory = [documentDir stringByAppendingPathComponent:@"Download"];
    　　NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    　　fileList = [fileManager contentsOfDirectoryAtPath:myDirectory error:&error];
    //        　　以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        　NSString *path = [documentDir stringByAppendingPathComponent:file];
        　[fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        　　if (!isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
//    　　NSLog(@"All folders:%@",dirArray);
    
    self.mdata = dirArray;
    //    UITableViewStyleGrouped  UITableViewStylePlain
    self.fileview = [[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain] init];
    // 设置tableView的数据源
    self.fileview.dataSource = self;
    // 设置tableView的委托
    self.fileview.delegate = self;
    //    self.fileview = tableView;
    //    fileview.allowsSelection=true;
    //    tableView.delaysContentTouches = NO;
    //    [self.view addSubview:tableView];
    //    self.view.userInteractionEnabled = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.mdata.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    //当表视图需要绘制一行时,会优先使用表视图里的可重用队列里的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:SimpleTableIdentifier];
    }
    
    //根据表视图的行数,从数组里获取对应索引的数据
    NSInteger mRow = [indexPath row];
    
    NSString *filestr = [self.mdata objectAtIndex:mRow];
    if (filestr.length >= 20) {
        NSString *headstr = [filestr substringToIndex:8];
        NSString *footstr = [filestr substringFromIndex:filestr.length-8];
        filestr = [NSString stringWithFormat:@"%@...%@",headstr,footstr];
    }
    
    cell.textLabel.text = filestr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中行背景颜色不变
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexCell = indexPath;
    fileview = tableView;
    //    [self.fileview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除文件" otherButtonTitles:@"打开", @"打开方式", nil];
    [actionSheet showInView:self.view];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *error = nil;
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0] ;
        NSString *myDirectory = [documentDir stringByAppendingPathComponent:@"Download"];
        NSInteger mRow = [indexPath row];
        NSString *fileToOpen = [self.mdata objectAtIndex:mRow];
        NSString *path = [myDirectory stringByAppendingPathComponent:fileToOpen];
        
        [self.mdata removeObjectAtIndex:indexPath.row];//删除数据源数据
        tableView.editing = NO;
        [tableView reloadData];
        [fileManager removeItemAtPath:path error:&error];//删除真实路径数据
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0] ;
    NSString *myDirectory = [documentDir stringByAppendingPathComponent:@"Download"];
    NSInteger mRow = [indexCell row];
    NSString *fileToOpen = [self.mdata objectAtIndex:mRow];
    NSString *path = [myDirectory stringByAppendingPathComponent:fileToOpen];
    
    controller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    controller.delegate = self;
    //    controller.UTI =@"public.png";
    CGRect rect = self.view.frame;
    
    if (buttonIndex == 0) {
//        NSLog(@"%@:%@",@"删除文件",fileToOpen);
        [self.mdata removeObjectAtIndex:mRow];//删除数据源数据
//        NSLog(@"All folders:%@",mdata);
        self.fileview.editing = NO;
        [self.fileview reloadData];
        [fileManager removeItemAtPath:path error:&error];//删除真实路径数据
    }else if (buttonIndex == 1) {
//        NSLog(@"%@",@"打开");
        [controller presentOptionsMenuFromRect:rect inView:self.view animated:YES];
    }else if(buttonIndex == 2) {
//        NSLog(@"%@",@"打开方式");
        [controller presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    }else if(buttonIndex == 3) {
//        NSLog(@"%@",@"取消");
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//返回按钮
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
