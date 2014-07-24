//
//  PFServicefoodViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/22/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollView.h"
#import "AsyncImageView.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFDelannaApi.h"

@protocol PFServicefoodViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFServicefoodViewControllerBack;

@end

@interface PFServicefoodViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet ScrollView *scrollView;
    IBOutlet AsyncImageView *imageView;
    NSMutableArray *images;
    NSArray *imagesName;
    
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;

-(void)ShowDetailView:(UIImageView *)imgView;

- (IBAction)fullimgalbumTapped:(id)sender;

@end
