//
//  PFOverViewCell.h
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFOverViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
