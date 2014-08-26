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

BOOL loadFeed;
BOOL noDataFeed;
BOOL refreshDataFeed;

int promotionInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.feedOffline = [NSUserDefaults standardUserDefaults];
        self.feeddetailOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Promotion";
    } else {
        self.navItem.title = @"โปรโมชั่น";
    }
    
    [self.DelannaApi checkBadge];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkN:) userInfo:nil repeats:YES];

    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    [self BarButtonItem];
    
    loadFeed = NO;
    noDataFeed = NO;
    refreshDataFeed = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.arrcontactimg = [[NSMutableArray alloc] init];
    self.ArrImgs = [[NSMutableArray alloc] init];
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        [self.DelannaApi getFeedGallery];
        [self.DelannaApi getFeedDetail:@"en"];
        [self.DelannaApi getFeed:@"en" limit:@"0"];
    } else {
        [self.DelannaApi getFeedGallery];
        [self.DelannaApi getFeedDetail:@"th"];
        [self.DelannaApi getFeed:@"th" limit:@"0"];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.imgscrollview addGestureRecognizer:singleTap];
    
    self.current = @"0";
    self.more = @"0";
    
    UITapGestureRecognizer *moredetailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moredetailTap:)];
    [self.headerView addGestureRecognizer:moredetailTap];
    
    if (![self.refresh isEqualToString:@"refresh"]) {
        [self.delegate HideTabbar];
        self.loadingView = [[PFLoadingViewController alloc] init];
        //splash screen
        if(IS_WIDESCREEN) {
            self.loadingView = [[PFLoadingViewController alloc] initWithNibName:@"PFLoadingViewController_Wide" bundle:nil];
        } else {
            self.loadingView = [[PFLoadingViewController alloc] initWithNibName:@"PFLoadingViewController" bundle:nil];
        }
        
        [self.view addSubview:self.loadingView.view];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)BarButtonItem {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *badge = [[NSString alloc] initWithFormat:@"%@",[def objectForKey:@"badge"]];
    
    //notification if (noti = 0) else
    if ([[def objectForKey:@"badge"] intValue] == 0) {
    
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notification_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
        self.navItem.rightBarButtonItem = rightButton;
        
    } else {
        
        UIButton *toggleKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleKeyboardButton.bounds = CGRectMake( 0, 0, 21, 21 );
        [toggleKeyboardButton setTitle:badge forState:UIControlStateNormal];
        [toggleKeyboardButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [toggleKeyboardButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        toggleKeyboardButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [toggleKeyboardButton setBackgroundColor:[UIColor clearColor]];
        [toggleKeyboardButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [toggleKeyboardButton.layer setBorderWidth: 1.0];
        [toggleKeyboardButton.layer setCornerRadius:10.0f];
        [toggleKeyboardButton addTarget:self action:@selector(notify) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:toggleKeyboardButton];
        self.navItem.rightBarButtonItem = rightButton;
        
    }
    
    self.navItem.leftBarButtonItem = leftButton;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setting {

    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    PFSettingViewController *settingView = [[PFSettingViewController alloc] init];
    if(IS_WIDESCREEN) {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController_Wide" bundle:nil];
    } else {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    settingView.delegate = self;
    [self.navController pushViewController:settingView animated:YES];

}

- (void)notify {
    
    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    PFNotificationViewController *notifyView = [[PFNotificationViewController alloc] init];
    if(IS_WIDESCREEN) {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    notifyView.delegate = self;
    [self.navController pushViewController:notifyView animated:YES];
}

-(void)checkN:(NSTimer *)timer
{
    [self.DelannaApi checkBadge];
}

- (void)PFDelannaApi:(id)sender checkBadgeResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    NSLog(@"%@",[response objectForKey:@"length"]);
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"badge"] intValue] == [[response objectForKey:@"length"] intValue]) {

    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
        [defaults synchronize];
        [self BarButtonItem];
    }
}
- (void)PFDelannaApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];
}

- (void)PagedImageScrollView:(id)sender current:(NSString *)current{
    self.current = current;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    int sum;
    sum = [self.current intValue]/32;
    NSString *num = [NSString stringWithFormat:@"%d",sum];
    [self.delegate PFGalleryViewController:self sum:self.arrcontactimg current:num];
    
}

- (NSArray *)imageToArray:(NSDictionary *)images {
    int countPicture = [[images objectForKey:@"data"] count];
    for (int i = 0; i < countPicture; i++) {
        
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",[[[images objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"],@"?width=320&height=180"];
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        
        NSData *data = [NSData dataWithContentsOfURL : url];
        UIImage *image = [UIImage imageWithData: data];
        [self.ArrImgs addObject:image];
    }
    return self.ArrImgs;
}

- (void)PFDelannaApi:(id)sender getTimeUpdateResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.NoInternetView removeFromSuperview];
    
    NSString *timeupdate = [[NSString alloc] initWithFormat:@"%@",[response objectForKey:@"feed_gallery"]];
    
    if (![[self.feedOffline objectForKey:@"checkTimeUpdate"] isEqualToString:timeupdate]) {
        [self.feedOffline setObject:timeupdate forKey:@"checkTimeUpdate"];
        [self.pageScrollView removeFromSuperview];
        
        self.refresh = @"refresh";
        
        [self viewDidLoad];
    }
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        [self.DelannaApi getFeedDetail:@"en"];
        [self.DelannaApi getFeed:@"en" limit:@"0"];
    } else {
        [self.DelannaApi getFeedDetail:@"th"];
        [self.DelannaApi getFeed:@"th" limit:@"0"];
    }
}

- (void)PFDelannaApi:(id)sender getTimeUpdateErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);

    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    promotionInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    promotionInt -= 1;
    if (promotionInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)PFDelannaApi:(id)sender getFeedGalleryResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);

    //splash screen
    [self.delegate ShowTabbar];
    [self.loadingView.view removeFromSuperview];
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrcontactimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
    }
    
    self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    self.pageScrollView.delegate = self;
    [self.pageScrollView setScrollViewContents:[self imageToArray:response]];
    self.pageScrollView.pageControlPos = PageControlPositionCenterBottom;
    [self.imgscrollview addSubview:self.pageScrollView];
    
    self.tableView.tableHeaderView = self.headerView;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    self.tableView.tableFooterView = fv;
    
    [self reloadData:YES];
}

- (void)PFDelannaApi:(id)sender getFeedGalleryErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);

    //splash screen
    [self.delegate ShowTabbar];
    [self.loadingView.view removeFromSuperview];
    
    self.tableView.tableHeaderView = self.headerView;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    self.tableView.tableFooterView = fv;
    
    [self reloadData:YES];
}

- (void)PFDelannaApi:(id)sender getFeedDetailResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.feeddetailOffline setObject:[response objectForKey:@"detail"] forKey:@"feeddetail"];
    
    self.detail.text = [response objectForKey:@"detail"];
    
}

- (void)PFDelannaApi:(id)sender getFeedDetailErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
     self.detail.text = [self.feeddetailOffline objectForKey:@"feeddetail"];
}

- (void)PFDelannaApi:(id)sender getFeedResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);

    //splash screen
    [self.delegate ShowTabbar];
    [self.loadingView.view removeFromSuperview];
    
    if (!refreshDataFeed) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.feedOffline setObject:response forKey:@"feedArray"];
    [self.feedOffline synchronize];
    
    if ( [[response objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataFeed = YES;
    } else {
        noDataFeed = NO;
        self.paging = [[response objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)PFDelannaApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    //splash screen
    [self.delegate ShowTabbar];
    [self.loadingView.view removeFromSuperview];
    
    if (!refreshDataFeed) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataFeed = YES;
    } else {
        noDataFeed = NO;
        self.paging = [[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataFeed){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

- (void)moredetailTap:(UITapGestureRecognizer *)gesture
{
    if ([self.more isEqualToString:@"0"]) {
        self.more = @"1";
        
        //ยืด
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        self.descText = [[UILabel alloc] initWithFrame:frame];
        self.descText.textColor = RGB(139, 94, 60);
        self.descText.text = self.detail.text;
        self.descText.numberOfLines = lines;
        [self.descText setFont:[UIFont systemFontOfSize:15]];
        
        if (lines >= 3) {
            self.detail.alpha = 0;
            [self.headerView addSubview:self.descText];
            
            self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.descText.frame.size.height-40);
            
            self.tableView.tableHeaderView = self.headerView;
            UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
            self.tableView.tableFooterView = fv;
            
            [self reloadData:YES];
        }
    } else {
        self.more = @"0";
        //หด
        
        self.detail.alpha = 1;
        self.descText.alpha = 0;

        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, 262);
        
        self.tableView.tableHeaderView = self.headerView;
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        self.tableView.tableFooterView = fv;
        
        [self reloadData:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.thumbnails.image = [UIImage imageWithData:imgData];
                          }];

    cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    PFDetailOverViewController *detailoverView = [[PFDetailOverViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController_Wide" bundle:nil];
    } else {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    detailoverView.obj = [self.arrObj objectAtIndex:indexPath.row];
    detailoverView.delegate = self;
    [self.navController pushViewController:detailoverView animated:YES];
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
        refreshDataFeed = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        [self.DelannaApi getTimeUpdate];
        
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
        if (!noDataFeed) {
            refreshDataFeed = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            [self.DelannaApi getTimeUpdate];

        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFSettingViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Promotion";
    } else {
        self.navItem.title = @"โปรโมชั่น";
    }
    
    if ([[self.DelannaApi getReset] isEqualToString:@"YES"]) {
        [self.delegate resetApp];
    }
}

- (void)PFNotificationViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Promotion";
    } else {
        self.navItem.title = @"โปรโมชั่น";
    }
}

- (void)PFDetailOverViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Promotion";
    } else {
        self.navItem.title = @"โปรโมชั่น";
    }
}

-(void)resetApp {
    [self.delegate resetApp];
}

@end
