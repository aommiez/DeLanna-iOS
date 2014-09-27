//
//  PFDetailFoldertypeViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFDelannaApi.h"

#import "PFFoldertypeCell.h"
#import "PFFoldertype1Cell.h"
#import "PFDetailFoldertype1ViewController.h"
#import "PFServicefoodViewController.h"
#import "PFServiceroomViewController.h"

@protocol PFDetailFoldertypeViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFDetailFoldertypeViewControllerBack;

@end

@interface PFDetailFoldertypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *foldertypeOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *folder_id;

@property (strong, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *checkinternet;

@end
