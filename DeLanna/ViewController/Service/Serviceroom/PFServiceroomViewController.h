//
//  PFServiceroomViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/22/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFDelannaApi.h"

@protocol PFServiceroomViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFServiceroomViewControllerBack;

@end

@interface PFServiceroomViewController : UIViewController < UIScrollViewDelegate > {
    
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

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;

@property (strong, nonatomic) NSString *checkinternet;

-(void)ShowDetailView:(UIImageView *)imgView;

- (IBAction)fullimgalbumTapped:(id)sender;

@end
