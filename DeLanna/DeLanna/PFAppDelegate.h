//
//  PFAppDelegate.h
//  DeLanna
//
//  Created by MRG on 7/8/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFTabBarViewController.h"

#import "PFOverViewController.h"
#import "PFRoomTypeViewController.h"
#import "PFServiceViewController.h"
#import "PFContactViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface PFAppDelegate : UIResponder <UIApplicationDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PFTabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFOverViewController *overview;
@property (strong, nonatomic) PFRoomTypeViewController *roomtype;
@property (strong, nonatomic) PFServiceViewController *service;
@property (strong, nonatomic) PFContactViewController *contact;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
