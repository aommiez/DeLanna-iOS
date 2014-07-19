//
//  PFCommentViewController.h
//  DeLanna
//
//  Created by Pariwat on 7/17/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFDelannaApi.h"

@protocol PFCommentViewControllerDelegate <NSObject>

- (void) PFCommentViewControllerBack;

@end

@interface PFCommentViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFDelannaApi *DelannaApi;

//@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *comment;

@end
