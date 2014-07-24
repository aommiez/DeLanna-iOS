//
//  PFRoomTypeCell.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol PFRoomTypeCellDelegate <NSObject>

- (void)ButtonTappedOnCell:(id)sender;

@end

@interface PFRoomTypeCell : UITableViewCell

@property (nonatomic, strong) id <PFRoomTypeCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;

@end
