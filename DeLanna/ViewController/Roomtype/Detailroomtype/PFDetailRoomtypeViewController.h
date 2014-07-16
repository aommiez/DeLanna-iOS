//
//  PFDetailRoomtypeViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollView.h"

#import "PFWebViewController.h"

@protocol PFDetailRoomtypeViewControllerDelegate <NSObject>

- (void) PFDetailRoomtypeViewControllerBack;

@end

@interface PFDetailRoomtypeViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIButton *reserveButton;

- (IBAction)reserveTapped:(id)sender;

@end
