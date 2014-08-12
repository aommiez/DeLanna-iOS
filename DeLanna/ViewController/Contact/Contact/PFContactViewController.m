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
        self.commentTxt.text = @"Sent us review or comment.";
    } else {
        self.navItem.title = @"สำรองห้องพัก";
        self.ReservationTxt.text = @"สำรองห้องพัก";
        self.commentTxt.text = @"แสดงความคิดเห็น";
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
    
    CALayer *commentView = [self.commentView layer];
    [commentView setMasksToBounds:YES];
    [commentView setCornerRadius:7.0f];
    
    CALayer *reserveButton = [self.reserveButton layer];
    [reserveButton setMasksToBounds:YES];
    [reserveButton setCornerRadius:7.0f];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullimage:)];
    [self.mapofflineImage addGestureRecognizer:singleTap];
    [self.mapofflineImage setMultipleTouchEnabled:YES];
    [self.mapofflineImage setUserInteractionEnabled:YES];
    
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
    NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.contactOffline setObject:[response objectForKey:@"phone"] forKey:@"phone"];
    [self.contactOffline setObject:[response objectForKey:@"website"] forKey:@"website"];
    [self.contactOffline setObject:[response objectForKey:@"email"] forKey:@"email"];
    [self.contactOffline synchronize];
    
    self.phoneTxt.text = [response objectForKey:@"phone"];
    self.websiteTxt.text = [response objectForKey:@"website"];
    self.emailTxt.text = [response objectForKey:@"email"];
    
    NSString *getheight = [[response objectForKey:@"picture"] objectForKey:@"height"];
    int height = [getheight intValue];
    
    NSString *getwidth = [[response objectForKey:@"picture"] objectForKey:@"width"];
    int width = [getwidth intValue];
    if (width == 300) {
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, self.mapofflineImage.frame.size.width, height);
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+height);
    } else {
        int sumheight = (height*300)/width;
        self.mapofflineImage.frame = CGRectMake(self.mapofflineImage.frame.origin.x, self.mapofflineImage.frame.origin.y, self.mapofflineImage.frame.size.width, sumheight);
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+sumheight);
    }
    
    [DLImageLoader loadImageFromURL:[[response objectForKey:@"picture"] objectForKey:@"url"]
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapofflineImage.image = [UIImage imageWithData:imgData];
                          }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;

}

- (void)PFDelannaApi:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.phoneTxt.text = [self.contactOffline objectForKey:@"phone"];
    self.websiteTxt.text = [self.contactOffline objectForKey:@"website"];
    self.emailTxt.text = [self.contactOffline objectForKey:@"email"];
    
}

- (void)fullimage:(UIGestureRecognizer *)gesture {
    [self.delegate PFImageViewController:self viewPicture:[[self.obj objectForKey:@"picture"] objectForKey:@"url"]];
}

- (IBAction)fullimageTapped:(id)sender{
    [self.delegate PFImageMapViewController:self];
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
        NSString *emailTitle = @"De Lanna Hotel";
        // Email Content
        NSString *messageBody = @"De Lanna Hotel!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:self.emailTxt.text];
        
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

- (IBAction)commentTapped:(id)sender{
    
    [self.delegate HideTabbar];
    
    PFCommentViewController *commentView = [[PFCommentViewController alloc] init];
    if(IS_WIDESCREEN) {
        commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController_Wide" bundle:nil];
    } else {
        commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController" bundle:nil];
    }
    commentView.delegate = self;
    [self.navController pushViewController:commentView animated:YES];
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

- (void) PFMapViewControllerBack {
    [self.delegate ShowTabbar];
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void) PFWebViewControllerBack {
    [self.delegate ShowTabbar];
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void) PFCommentViewControllerBack {
    [self.delegate ShowTabbar];
}

@end
