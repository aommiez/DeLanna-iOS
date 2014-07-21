//
//  PFDetailOverViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/17/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFWebViewController.h"

@protocol PFDetailOverViewControllerDelegate <NSObject>

- (void) PFDetailOverViewControllerBack;

@end

@interface PFDetailOverViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIButton *reserveButton;

- (IBAction)reserveTapped:(id)sender;

@end