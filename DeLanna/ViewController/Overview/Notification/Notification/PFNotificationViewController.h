//
//  PFNotificationViewController.h
//  DeLanna
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFNotificationCell.h"

#import "PFDetailOverViewController.h"

#import "PFDelannaApi.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFNotificationViewControllerBack;

@end

@interface PFNotificationViewController : UIViewController

@property AFHTTPRequestOperationManager *manager;
@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@end
