//
//  PFOverViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFOverViewController.h"

@interface PFOverViewController ()

@end

@implementation PFOverViewController

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
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navItem.leftBarButtonItem = leftButton;
    
    self.tableView.tableHeaderView = self.headerView;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    self.tableView.tableFooterView = fv;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setting {
    
    [self.delegate HideTabbar];
    
    PFSettingViewController *settingView = [[PFSettingViewController alloc] init];
    if(IS_WIDESCREEN) {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController_Wide" bundle:nil];
    } else {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController" bundle:nil];
    }
    settingView.delegate = self;
    [self.navController pushViewController:settingView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFOverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFOverViewCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFOverViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.delegate = self;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)ButtonTappedOnCell:(id)sender {
    NSIndexPath *indepath = [self.tableView indexPathForCell:sender];
    NSLog(@"%@",indepath);
    
    [self.delegate HideTabbar];
    
    PFDetailOverViewController *detailoverView = [[PFDetailOverViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController_Wide" bundle:nil];
    } else {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController" bundle:nil];
    }
    detailoverView.delegate = self;
    [self.navController pushViewController:detailoverView animated:YES];
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate HideTabbar];
    
    PFDetailOverViewController *detailoverView = [[PFDetailOverViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController_Wide" bundle:nil];
    } else {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController" bundle:nil];
    }
    detailoverView.delegate = self;
    [self.navController pushViewController:detailoverView animated:YES];
}
*/

- (void) PFSettingViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void) PFDetailOverViewControllerBack {
    [self.delegate ShowTabbar];
}

@end
