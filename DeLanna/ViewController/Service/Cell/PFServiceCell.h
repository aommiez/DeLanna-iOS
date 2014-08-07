//
//  PFServiceCell.h
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFServiceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UIImageView *bgType;
@property (strong, nonatomic) IBOutlet UILabel *Type;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
