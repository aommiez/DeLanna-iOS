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
#define ASYNC_IMAGE_TAG 9999

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
        self.navItem.title = @"Overview";
    } else {
        self.navItem.title = @"ภาพรวม";
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
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navItem.leftBarButtonItem = leftButton;
    
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

- (void)PFDelannaApi:(id)sender getFeedGalleryResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    
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
    
    [self.waitView removeFromSuperview];
    
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
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
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataFeed) {
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
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    if (!refreshDataFeed) {
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
    
    cell.delegate = self;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    cell.thumbnails.tag = ASYNC_IMAGE_TAG;
    cell.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];

    cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
}

- (void)ButtonTappedOnCell:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    PFDetailOverViewController *detailoverView = [[PFDetailOverViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController_Wide" bundle:nil];
    } else {
        detailoverView = [[PFDetailOverViewController alloc] initWithNibName:@"PFDetailOverViewController" bundle:nil];
    }
    detailoverView.obj = [self.arrObj objectAtIndex:indexPath.row];
    detailoverView.checkinternet = self.checkinternet;
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
        
//        self.DelannaApi = [[PFDelannaApi alloc] init];
//        self.DelannaApi.delegate = self;
//        
//        if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
//            [self.DelannaApi getFeedDetail:@"en"];
//            [self.DelannaApi getFeed:@"en" limit:@"2"];
//        } else {
//            [self.DelannaApi getFeedDetail:@"th"];
//            [self.DelannaApi getFeed:@"th" limit:@"2"];
//        }
        
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
            
//            self.DelannaApi = [[PFDelannaApi alloc] init];
//            self.DelannaApi.delegate = self;
//            
//            if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
//                [self.DelannaApi getFeedDetail:@"en"];
//                [self.DelannaApi getFeed:@"en" limit:@""];
//            } else {
//                [self.DelannaApi getFeedDetail:@"th"];
//                [self.DelannaApi getFeed:@"th" limit:@""];
//            }
        }
    }
}

- (void)resizeTable {
    [self.pageScrollView removeFromSuperview];
    [self viewDidLoad];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
    [self.pageScrollView removeFromSuperview];
    //[self viewDidLoad];
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFSettingViewControllerBack {
    [self.delegate ShowTabbar];
    
    if ([[self.DelannaApi getReset] isEqualToString:@"YES"]) {
        [self.delegate resetApp];
    }
}

- (void)PFDetailOverViewControllerBack {
    [self.delegate ShowTabbar];
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

-(void)resetApp {
    [self.delegate resetApp];
}

@end
