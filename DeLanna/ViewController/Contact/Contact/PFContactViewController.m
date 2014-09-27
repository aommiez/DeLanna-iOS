//
//  PFContactViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFContactViewController.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

BOOL loadContact;
BOOL noDataContact;
BOOL refreshDataContact;

int contactInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.contactOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Reservation";
        self.ReservationTxt.text = @"Hotel Reservation";
    } else {
        self.navItem.title = @"สำรองห้องพัก";
        self.ReservationTxt.text = @"สำรองห้องพัก";
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
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",@"18.789622",@",",@"98.982788",@"&zoom=16&size=640x360&sensor=false&markers=color:red%7Clabel:Satit%7C",@"18.789622",@",",@"98.982788"];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImage.image = [UIImage imageWithData:imgData];
                          }];
    
    CALayer *buttonView = [self.buttonView layer];
    [buttonView setMasksToBounds:YES];
    [buttonView setCornerRadius:7.0f];
    
    CALayer *reserveButton = [self.reserveButton layer];
    [reserveButton setMasksToBounds:YES];
    [reserveButton setCornerRadius:7.0f];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullimage:)];
    [self.mapofflineImage addGestureRecognizer:singleTap];
    [self.mapofflineImage setMultipleTouchEnabled:YES];
    [self.mapofflineImage setUserInteractionEnabled:YES];
    
    self.mapofflineImage.layer.masksToBounds = YES;
    self.mapofflineImage.contentMode = UIViewContentModeScaleAspectFill;
    
    loadContact = NO;
    noDataContact = NO;
    refreshDataContact = NO;
    
    [self.DelannaApi getContact];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFDelannaApi:(id)sender getContactResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.contactOffline setObject:response forKey:@"contactOffline"];
    [self.contactOffline synchronize];
    
    self.phoneTxt.text = [response objectForKey:@"phone"];
    self.faxTxt.text = [response objectForKey:@"fax"];
    self.websiteTxt.text = [response objectForKey:@"website"];
    self.emailTxt.text = [response objectForKey:@"email"];
    
    NSString *getheight = [[response objectForKey:@"picture"] objectForKey:@"height"];
    int height = [getheight intValue];
    
    NSString *getwidth = [[response objectForKey:@"picture"] objectForKey:@"width"];
    int width = [getwidth intValue];
    if (width == 300) {
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, 300, height);
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, 320, 450+height-10);
        
        [DLImageLoader loadImageFromURL:[[response objectForKey:@"picture"] objectForKey:@"url"]
                              completed:^(NSError *error, NSData *imgData) {
                                  self.mapofflineImage.image = [UIImage imageWithData:imgData];
                              }];
        
        self.tableView.tableHeaderView = self.headerView;
    } else {
        int sumheight = (height*300)/width;
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, 300, sumheight);
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, 320, 450+sumheight-10);
        
        [DLImageLoader loadImageFromURL:[[response objectForKey:@"picture"] objectForKey:@"url"]
                              completed:^(NSError *error, NSData *imgData) {
                                  self.mapofflineImage.image = [UIImage imageWithData:imgData];
                              }];
        
        self.tableView.tableHeaderView = self.headerView;
    }
    
    self.tableView.tableFooterView = self.footerView;

}

- (void)PFDelannaApi:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    contactInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.phoneTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"phone"];
    self.faxTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"fax"];
    self.websiteTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"website"];
    self.emailTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"email"];
    
    NSString *getheight = [[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"picture"] objectForKey:@"height"];
    int height = [getheight intValue];
    
    NSString *getwidth = [[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"picture"] objectForKey:@"width"];
    int width = [getwidth intValue];
    if (width == 300) {
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, 300, height);
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, 320, 450+height-10);
        
        [DLImageLoader loadImageFromURL:[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"picture"] objectForKey:@"url"]
                              completed:^(NSError *error, NSData *imgData) {
                                  self.mapofflineImage.image = [UIImage imageWithData:imgData];
                              }];
        
        self.tableView.tableHeaderView = self.headerView;
    } else {
        int sumheight = (height*300)/width;
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, 300, sumheight);
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, 320, 450+sumheight-10);
        
        [DLImageLoader loadImageFromURL:[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"picture"] objectForKey:@"url"]
                              completed:^(NSError *error, NSData *imgData) {
                                  self.mapofflineImage.image = [UIImage imageWithData:imgData];
                              }];
        
        self.tableView.tableHeaderView = self.headerView;
    }
    
    self.tableView.tableFooterView = self.footerView;
    
}

- (void)countDown {
    contactInt -= 1;
    if (contactInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)fullimage:(UIGestureRecognizer *)gesture {
    [self.delegate PFImageViewController:self viewPicture:[[self.obj objectForKey:@"picture"] objectForKey:@"url"]];
}

- (IBAction)mapTapped:(id)sender{
    
    [self.delegate HideTabbar];
    [self.NoInternetView removeFromSuperview];
    
    PFMapViewController *mapView = [[PFMapViewController alloc] init];
    if(IS_WIDESCREEN) {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
    } else {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    mapView.delegate = self;
    [self.navController pushViewController:mapView animated:YES];
}

- (IBAction)phoneTapped:(id)sender{
    NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",self.phoneTxt.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (IBAction)websiteTapped:(id)sender{
    NSString *website = [[NSString alloc] initWithFormat:@"%@",self.websiteTxt.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
}

- (IBAction)emailTapped:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                    initWithTitle:@"Select Menu"
                                    delegate:self
                                    cancelButtonTitle:@"cancel"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        [self.delegate HideTabbar];
        NSLog(@"Send Email");
        // Email Subject
        NSString *emailTitle = nil;
        // Email Content
        NSString *messageBody = nil;
        // To address
        NSArray *toRecipents = [self.emailTxt.text componentsSeparatedByString: @","];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:212.0f/255.0f green:185.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.delegate ShowTabbar];
}

- (IBAction)reserveTapped:(id)sender{
    
    [self.delegate HideTabbar];
    [self.NoInternetView removeFromSuperview];
    
    PFWebViewController *webView = [[PFWebViewController alloc] init];
    if(IS_WIDESCREEN) {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController_Wide" bundle:nil];
    } else {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];
}

- (IBAction)powerbyTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
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
        refreshDataContact = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        [self.DelannaApi getContact];
        
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
        if (!noDataContact) {
            refreshDataContact = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            [self.DelannaApi getContact];
            
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void) PFMapViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Reservation";
    } else {
        self.navItem.title = @"สำรองห้องพัก";
    }
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void) PFWebViewControllerBack {
    [self.delegate ShowTabbar];
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Reservation";
    } else {
        self.navItem.title = @"สำรองห้องพัก";
    }
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

@end
