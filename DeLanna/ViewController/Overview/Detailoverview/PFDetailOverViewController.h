//
//  PFDetailOverViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/17/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

#import "PFDelannaApi.h"

#import "PFWebViewController.h"

@protocol PFDetailOverViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void) PFDetailOverViewControllerBack;

@end

@interface PFDetailOverViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;

@property (strong, nonatomic) IBOutlet UILabel *reserve;
@property (strong, nonatomic) IBOutlet UIButton *reserveButton;

- (IBAction)fullimgalbumTapped:(id)sender;
- (IBAction)reserveTapped:(id)sender;

@end
