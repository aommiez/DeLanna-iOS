//
//  PFRoomTypeCell.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFRoomTypeCellDelegate <NSObject>

- (void)ButtonTappedOnCell:(id)sender;

@end

@interface PFRoomTypeCell : UITableViewCell

@property (nonatomic, strong) id <PFRoomTypeCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
