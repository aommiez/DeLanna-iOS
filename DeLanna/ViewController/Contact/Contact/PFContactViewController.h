//
//  PFContactViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "PFDelannaApi.h"

#import "PFMapViewController.h"
#import "PFWebViewController.h"
#import "PFCommentViewController.h"

@protocol PFContactViewControllerDelegate <NSObject>

- (void)PFImageMapViewController:(id)sender;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFContactViewController : UIViewController <MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) IBOutlet UILabel *loadLabel;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UILabel *phoneTxt;
@property (strong, nonatomic) IBOutlet UILabel *websiteTxt;
@property (strong, nonatomic) IBOutlet UILabel *emailTxt;

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *commentView;

@property (strong, nonatomic) IBOutlet UILabel *commentTxt;
@property (strong, nonatomic) IBOutlet UILabel *ReservationTxt;
@property (strong, nonatomic) IBOutlet UIButton *reserveButton;

- (IBAction)fullimageTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;
- (IBAction)phoneTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)commentTapped:(id)sender;
- (IBAction)reserveTapped:(id)sender;
- (IBAction)powerbyTapped:(id)sender;

@end
