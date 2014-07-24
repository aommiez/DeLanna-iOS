//
//  PFServiceCell.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFServiceCellDelegate <NSObject>

- (void)ButtonTappedOnCell:(id)sender;

@end

@interface PFServiceCell : UITableViewCell

@property (nonatomic, strong) id <PFServiceCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *Type;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
