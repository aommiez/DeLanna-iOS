//
//  PFRoomTypeCell.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFRoomTypeCell.h"

@implementation PFRoomTypeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    CALayer *bgView = [self.bgView layer];
    [bgView setMasksToBounds:YES];
    [bgView setCornerRadius:7.0f];
    
    [self.bgView.layer setCornerRadius:5.0f];
    self.bgView.layer.shadowOffset = CGSizeMake(0.5, -0.5);
    self.bgView.layer.shadowRadius = 2;
    self.bgView.layer.shadowOpacity = 0.1;
}

@end
