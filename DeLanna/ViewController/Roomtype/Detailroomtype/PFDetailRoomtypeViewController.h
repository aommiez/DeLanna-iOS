//
//  PFDetailRoomtypeViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PFDelannaApi.h"

#import "PFWebViewController.h"

@protocol PFDetailRoomtypeViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void) PFDetailRoomtypeViewControllerBack;

@end

@interface PFDetailRoomtypeViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet ScrollView *scrollView;
    IBOutlet AsyncImageView *imageView;
    NSMutableArray *images;
    NSArray *imagesName;
    
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *DetailroomtypeOffline;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerImgView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
@property (strong, nonatomic) IBOutlet UILabel *titlefeature;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *feature;

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel *name1;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *baht1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *feature1;

@property (strong, nonatomic) IBOutlet UILabel *reserve;
@property (strong, nonatomic) IBOutlet UIButton *reserveButton;

@property (strong, nonatomic) NSString *checkinternet;

-(void)ShowDetailView:(UIImageView *)imgView;

- (IBAction)fullimgTapped:(id)sender;
- (IBAction)fullimgalbumTapped:(id)sender;
- (IBAction)reserveTapped:(id)sender;

@end
