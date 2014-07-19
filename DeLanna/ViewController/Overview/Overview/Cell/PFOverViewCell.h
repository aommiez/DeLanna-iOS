//
//  PFOverViewCell.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFOverViewCellDelegate <NSObject>

- (void)ButtonTappedOnCell:(id)sender;

@end

@interface PFOverViewCell : UITableViewCell

@property (nonatomic, strong) id <PFOverViewCellDelegate> delegate;

@end
