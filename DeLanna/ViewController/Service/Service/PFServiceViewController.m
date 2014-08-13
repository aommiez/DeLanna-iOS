//
//  PFServiceViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFServiceViewController.h"

@interface PFServiceViewController ()

@end

@implementation PFServiceViewController

BOOL loadService;
BOOL noDataService;
BOOL refreshDataService;

int serviceInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.serviceOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Service";
    } else {
        self.navItem.title = @"บริการ";
    }
    
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
    
    loadService = NO;
    noDataService = NO;
    refreshDataService = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.arrObj1 = [[NSMutableArray alloc] init];
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        [self.DelannaApi getService:@"en"];
    } else {
        [self.DelannaApi getService:@"th"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFDelannaApi:(id)sender getServiceResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataService) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.serviceOffline setObject:response forKey:@"serviceArray"];
    [self.serviceOffline synchronize];
    
    if ( [[response objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataService = YES;
    } else {
        noDataService = NO;
        self.paging = [[response objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)PFDelannaApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    serviceInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataService) {
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataService = YES;
    } else {
        noDataService = NO;
        self.paging = [[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)countDown {
    serviceInt -= 1;
    if (serviceInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataService){
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
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFServiceCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFServiceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    cell.Type.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
        if(IS_WIDESCREEN) {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
        } else {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
        }
        self.navItem.title = @" ";
        foldertypeView.obj = [self.arrObj objectAtIndex:indexPath.row];
        foldertypeView.folder_id = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"];
        foldertypeView.delegate = self;
        [self.navController pushViewController:foldertypeView animated:YES];
        
    }
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"service_food"]) {
        
        PFServicefoodViewController *servicefoodView = [[PFServicefoodViewController alloc] init];
        if(IS_WIDESCREEN) {
            servicefoodView = [[PFServicefoodViewController alloc] initWithNibName:@"PFServicefoodViewController_Wide" bundle:nil];
        } else {
            servicefoodView = [[PFServicefoodViewController alloc] initWithNibName:@"PFServicefoodViewController" bundle:nil];
        }
        self.navItem.title = @" ";
        servicefoodView.obj = [self.arrObj objectAtIndex:indexPath.row];
        servicefoodView.delegate = self;
        [self.navController pushViewController:servicefoodView animated:YES];
        
    }
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"service_room"]) {
        
        PFServiceroomViewController *serviceroomView = [[PFServiceroomViewController alloc] init];
        if(IS_WIDESCREEN) {
            serviceroomView = [[PFServiceroomViewController alloc] initWithNibName:@"PFServiceroomViewController_Wide" bundle:nil];
        } else {
            serviceroomView = [[PFServiceroomViewController alloc] initWithNibName:@"PFServiceroomViewController" bundle:nil];
        }
        self.navItem.title = @" ";
        serviceroomView.obj = [self.arrObj objectAtIndex:indexPath.row];
        serviceroomView.delegate = self;
        [self.navController pushViewController:serviceroomView animated:YES];
        
    }
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
        refreshDataService = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
            [self.DelannaApi getService:@"en"];
        } else {
            [self.DelannaApi getService:@"th"];
        }
        
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
        self.tableView.frame = CGRectMake(0, 50, 320, self.tableView.frame.size.height);
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
        if (!noDataService) {
            refreshDataService = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
                [self.DelannaApi getService:@"en"];
            } else {
                [self.DelannaApi getService:@"th"];
            }
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void) PFDetailFoldertypeViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Service";
    } else {
        self.navItem.title = @"บริการ";
    }
}

- (void) PFServicefoodViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Service";
    } else {
        self.navItem.title = @"บริการ";
    }
}

- (void) PFServiceroomViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Service";
    } else {
        self.navItem.title = @"บริการ";
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

@end
