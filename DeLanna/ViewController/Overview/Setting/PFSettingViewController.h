//
//  PFSettingViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFDelannaApi.h"

#import "PFLanguageViewController.h"

@protocol PFSettingViewControllerDelegate <NSObject>

- (void)PFSettingViewControllerBack;

@end

@interface PFSettingViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel *languagesetting;
@property (strong, nonatomic) IBOutlet UILabel *applanguage;
@property (strong, nonatomic) IBOutlet UILabel *contentlanguage;

@property (strong, nonatomic) IBOutlet UILabel *applanguagestatus;
@property (strong, nonatomic) IBOutlet UILabel *contentlanguagestatus;

- (IBAction)appsettingTapped:(id)sender;
- (IBAction)contentsettingTapped:(id)sender;

@end
