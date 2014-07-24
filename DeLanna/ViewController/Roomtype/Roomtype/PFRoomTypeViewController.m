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

BOOL loadRoomtype;
BOOL noDataRoomtype;
BOOL refreshDataRoomtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.roomtypeOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    self.tableView.tableFooterView = fv;
    
    loadRoomtype = NO;
    noDataRoomtype = NO;
    refreshDataRoomtype = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    [self.DelannaApi getRoomtype];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFDelannaApi:(id)sender getRoomtypeResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataRoomtype) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.roomtypeOffline setObject:response forKey:@"roomtypeArray"];
    
    if ( [[response objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataRoomtype = YES;
    } else {
        noDataRoomtype = NO;
        self.paging = [[response objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)PFDelannaApi:(id)sender getRoomtypeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataRoomtype) {
        for (int i=0; i<[[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataRoomtype = YES;
    } else {
        noDataRoomtype = NO;
        self.paging = [[[self.roomtypeOffline objectForKey:@"roomtypeArray"] objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataRoomtype){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
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
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;

    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    cell.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];
   
    cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.price.text = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"]];
    /*
     check EN or TH
     */
    cell.baht.text = @"Baht";
    
    return cell;
}

- (void)ButtonTappedOnCell:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [self.delegate HideTabbar];
    
    PFDetailRoomtypeViewController *detailroomtypeView = [[PFDetailRoomtypeViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController_Wide" bundle:nil];
    } else {
        detailroomtypeView = [[PFDetailRoomtypeViewController alloc] initWithNibName:@"PFDetailRoomtypeViewController" bundle:nil];
    }
    detailroomtypeView.obj = [self.arrObj objectAtIndex:indexPath.row];
    detailroomtypeView.delegate = self;
    [self.navController pushViewController:detailroomtypeView animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f",scrollView.contentOffset.y);
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y < 0.0f ) {
        //NSLog(@"refreshData < 0.0f");
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha =1;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataRoomtype = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        [self.DelannaApi getRoomtype];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
            self.act.alpha =1;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        self.tableView.frame = CGRectMake(0, 60, 320, self.tableView.frame.size.height);
		[UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
            self.act.alpha =1;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataRoomtype) {
            refreshDataRoomtype = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            [self.DelannaApi getRoomtype];
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void) PFDetailRoomtypeViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

@end
