//
//  XXOAFileTableViewController.h
//  xxoaclient
//
//  Created by apple on 14-8-21.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXOAFileTableViewController : UITableViewController<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,retain) NSMutableArray *mdata;
@property (strong, nonatomic) IBOutlet UITableView *fileview;

@end
