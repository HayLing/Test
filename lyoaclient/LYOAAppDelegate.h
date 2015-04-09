//
//  LYOAAppDelegate.h
//  lyoaclient
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYOAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (strong,nonatomic) NSTimer *myTimer;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
