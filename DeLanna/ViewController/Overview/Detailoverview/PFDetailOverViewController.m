//
//  PFDetailOverViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/17/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFDetailOverViewController.h"

@interface PFDetailOverViewController ()

@end

@implementation PFDetailOverViewController

#define ASYNC_IMAGE_TAG 9999

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.imageOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.reserve.text = @"Reserve";
    } else {
        self.reserve.text = @"สำรองห้องพัก";
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CALayer *reserveButton = [self.reserveButton layer];
    [reserveButton setMasksToBounds:YES];
    [reserveButton setCornerRadius:7.0f];
    
    self.thumbnails.layer.masksToBounds = YES;
    self.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"],@"?width=800&height=600"];
    self.thumbnails.tag = ASYNC_IMAGE_TAG;
    self.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];

    self.name.text = [self.obj objectForKey:@"name"];
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    CGRect frame = self.detail.frame;
    frame.size = [self.detail sizeOfMultiLineLabel];
    [self.detail sizeOfMultiLineLabel];
    
    [self.detail setFrame:frame];
    int lines = self.detail.frame.size.height/15;
    self.detail.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.textColor = RGB(139, 94, 60);
    descText.text = self.detail.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.detail.alpha = 0;
    [self.headerView addSubview:descText];
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-10);
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    UIImage* retImage = [self.staticImageDictionary objectForKey:imageNamed];
    if (retImage == nil)
        {
            retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
            if (cache)
                {
                    if (self.staticImageDictionary == nil)
                        self.staticImageDictionary = [NSMutableDictionary new];
                    
                    [self.staticImageDictionary setObject:retImage forKey:imageNamed];
                    }
            }
    return retImage;
}

- (void)share {

    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"name"]], @"name",
                                   [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]], @"link",
                                   nil];
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User canceled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)fullimgalbumTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
}

- (IBAction)reserveTapped:(id)sender{
    
    [self.NoInternetView removeFromSuperview];
    
    PFWebViewController *webView = [[PFWebViewController alloc] init];
    if(IS_WIDESCREEN) {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController_Wide" bundle:nil];
    } else {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController" bundle:nil];
    }
    webView.delegate = self;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)PFWebViewControllerBack {
    
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFDetailOverViewControllerBack)]){
            [self.delegate PFDetailOverViewControllerBack];
        }
    }
}

@end
