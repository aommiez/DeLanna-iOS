//
//  PFRoomTypeViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFRoomTypeViewController.h"

@interface PFRoomTypeViewController ()

@end

@implementation PFRoomTypeViewController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 245;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFRoomTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFRoomTypeCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFRoomTypeCell" owner:self options:nil];
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
    
    PFDetailRoomtypeViewController *detailroomtypeView = [[PFDetailRoomtypeViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController_Wide" bundle:nil];
    } else {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController" bundle:nil];
    }
    detailroomtypeView.delegate = self;
    [self.navController pushViewController:detailroomtypeView animated:YES];
}

/*

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate HideTabbar];
    
    PFDetailRoomtypeViewController *detailroomtypeView = [[PFDetailRoomtypeViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController_Wide" bundle:nil];
    } else {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController" bundle:nil];
    }
    detailroomtypeView.delegate = self;
    [self.navController pushViewController:detailroomtypeView animated:YES];
}
 
*/

- (void) PFDetailRoomtypeViewControllerBack {
    [self.delegate ShowTabbar];
}

@end
