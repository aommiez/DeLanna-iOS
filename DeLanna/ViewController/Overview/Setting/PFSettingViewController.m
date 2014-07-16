//
//  PFSettingViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFSettingViewController.h"

@interface PFSettingViewController ()

@end

@implementation PFSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Setting";
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)settingTapped:(id)sender{
    
    PFLanguageViewController *languageView = [[PFLanguageViewController alloc] init];
    if(IS_WIDESCREEN) {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController_Wide" bundle:nil];
    } else {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController" bundle:nil];
    }
    languageView.delegate = self;
    [self.navigationController pushViewController:languageView animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFSettingViewControllerBack)]){
            [self.delegate PFSettingViewControllerBack];
        }
    }
    
}

@end
