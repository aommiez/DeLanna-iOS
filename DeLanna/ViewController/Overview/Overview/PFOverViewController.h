//
//  PFOverViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRGradientNavigationBar.h"

#import "PFOverViewCell.h"

#import "PFSettingViewController.h"
#import "PFDetailOverViewController.h"

@protocol PFOverViewControllerDelegate <NSObject>

- (void)resetApp;

- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFOverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,PFOverViewCellDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
