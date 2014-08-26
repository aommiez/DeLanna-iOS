//
//  PFLoadingViewController.m
//  DeLanna
//
//  Created by Pariwat on 8/26/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFLoadingViewController.h"

@interface PFLoadingViewController ()

@end

@implementation PFLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IS_WIDESCREEN) {
        self.splashImage.image = [UIImage imageNamed:@"loading_delanna@2x"];
    } else {
        self.splashImage.image = [UIImage imageNamed:@"loading_delanna"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
