//
//  PFNotificationViewController.m
//  DeLanna
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFNotificationViewController.h"

@interface PFNotificationViewController ()

@end

@implementation PFNotificationViewController

BOOL loadNoti;
BOOL noDataNoti;
BOOL refreshDataNoti;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.manager = [AFHTTPRequestOperationManager manager];
        self.notifyOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Notification";

    } else {
        self.navigationItem.title = @"การแจ้งเตือน";

    }
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    loadNoti = NO;
    noDataNoti = NO;
    refreshDataNoti = NO;
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    [self.DelannaApi display_notify_number];
    [self.DelannaApi Notification:@"15" link:@"NO"];
    
    self.arrObj = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)PFDelannaApi:(id)sender NotificationResponse:(NSDictionary *)response {
    NSLog(@"noti %@",response);
    self.obj = response;
    
    self.checkinternet = @"connect";
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataNoti) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataNoti = YES;
    } else {
        noDataNoti = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.notifyOffline setObject:response forKey:@"notificationArray"];
    [self.notifyOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFDelannaApi:(id)sender NotificationErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    
    if (!refreshDataNoti) {
        for (int i=0; i<[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataNoti = YES;
    } else {
        noDataNoti = NO;
        self.paging = [[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.tableView reloadData];
}

- (void)PFDelannaApi:(id)sender getFeedByIdResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    PFDetailOverViewController *mmdetail = [[PFDetailOverViewController alloc] init];
    
    if(IS_WIDESCREEN){
        mmdetail = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController_Wide" bundle:nil];
    } else {
        mmdetail = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    mmdetail.obj = response;
    mmdetail.delegate = self;
    
    [self.navigationController pushViewController:mmdetail animated:YES];
}

- (void)PFDelannaApi:(id)sender getFeedByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFNotificationCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.topicLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_header"];
    
    NSString *myDate = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    NSString *mySmallerDate = [myDate substringToIndex:16];
    cell.timeLabel.text = mySmallerDate;
    
    cell.msgLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_content"];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"opened"] intValue] == 0) {
        cell.bg.image = [UIImage imageNamed:@"NotBoxNoReadIp5"];
    } else {
        cell.bg.image = [UIImage imageNamed:@"NotBoxReadedIp5"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"type"];
    
    if ( [type isEqualToString:@"news"]) {
        [self.DelannaApi getFeedById:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"id"]];
    }
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@notify/opened/%@",API_URL,[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
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
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataNoti = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        [self.DelannaApi Notification:@"15" link:@"NO"];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataNoti) {
            refreshDataNoti = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.DelannaApi Notification:@"NO" link:self.paging];
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

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFDetailOverViewControllerBack {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFNotificationViewControllerBack)]){
            [self.DelannaApi Notification:@"15" link:@"NO"];
            [self.delegate PFNotificationViewControllerBack];
        }
    }
}

@end
