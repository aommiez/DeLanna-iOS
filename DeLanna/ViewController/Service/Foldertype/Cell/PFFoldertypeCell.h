//
//  PFFoldertypeCell.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol PFFoldertypeCellDelegate <NSObject>

- (void)ButtonTappedOnCell:(id)sender;

@end

@interface PFFoldertypeCell : UITableViewCell

@property (nonatomic, strong) id <PFFoldertypeCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;


@end
