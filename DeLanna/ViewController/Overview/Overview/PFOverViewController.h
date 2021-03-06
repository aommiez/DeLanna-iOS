//
//  PFOverViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import "BBBadgeBarButtonItem.h"

#import "PFDelannaApi.h"

#import "PFOverViewCell.h"
#import "PFSettingViewController.h"
#import "PFNotificationViewController.h"

#import "PFDetailOverViewController.h"
#import "PFLoadingViewController.h"

@protocol PFOverViewControllerDelegate <NSObject>

- (void)resetApp;
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFOverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSMutableArray *ArrImgs;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *feedOffline;
@property NSUserDefaults *feeddetailOffline;

@property (strong, nonatomic) PFLoadingViewController *loadingView;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) IBOutlet UILabel *loadLabel;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *imgscrollview;

@property (strong, nonatomic) IBOutlet PagedImageScrollView *pageScrollView;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
@property (strong, nonatomic) IBOutlet UILabel *descText;

@property (strong, nonatomic) NSMutableArray *arrcontactimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *more;

@property (strong, nonatomic) NSString *refresh;

@end
