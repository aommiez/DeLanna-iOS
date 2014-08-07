//
//  PFDetailRoomtypeViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFDetailRoomtypeViewController.h"

@interface PFDetailRoomtypeViewController ()

@end

@implementation PFDetailRoomtypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.DetailroomtypeOffline = [NSUserDefaults standardUserDefaults];
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
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CALayer *reserveButton = [self.reserveButton layer];
    [reserveButton setMasksToBounds:YES];
    [reserveButton setCornerRadius:7.0f];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *id = [NSString stringWithFormat:@"%@",[self.obj objectForKey:@"id"]];
    [self.DelannaApi getRoomtypeByID:id];

    self.name.text = [self.obj objectForKey:@"name"];
    self.price.text = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"price"]];
    self.baht.text = @"Baht";
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    //1
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"],@"?width=800&height=600"];
    //self.imageView1.imageURL = [NSURL URLWithString:urlimg];
    
    //
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.imageView1.image = [UIImage imageWithData:imgData];
                          }];
    //
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    self.name1.text = [self.obj objectForKey:@"name"];
    self.price1.text = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"price"]];
    self.baht1.text = @"Baht";
    self.detail1.text = [self.obj objectForKey:@"detail"];
    
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

- (void)share {
    
    NSString *urlString = [[NSString alloc]init];
    urlString = [[NSString alloc]initWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addURL:[NSURL URLWithString:urlString]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
//    // Put together the dialog parameters
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"name"]], @"name",
//                                   [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]], @"link",
//                                   nil];
//    
//    // Show the feed dialog
//    [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                           parameters:params
//                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                  if (error) {
//                                                      // An error occurred, we need to handle the error
//                                                      // See: https://developers.facebook.com/docs/ios/errors
//                                                      NSLog(@"Error publishing story: %@", error.description);
//                                                  } else {
//                                                      if (result == FBWebDialogResultDialogNotCompleted) {
//                                                          // User canceled.
//                                                          NSLog(@"User cancelled.");
//                                                      } else {
//                                                          // Handle the publish feed callback
//                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                          
//                                                          if (![urlParams valueForKey:@"post_id"]) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                              
//                                                          } else {
//                                                              // User clicked the Share button
//                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                              NSLog(@"result %@", result);
//                                                          }
//                                                      }
//                                                  }
//                                              }];
    
}

//// A function for parsing URL parameters returned by the Feed Dialog.
//- (NSDictionary*)parseURLParams:(NSString *)query {
//    NSArray *pairs = [query componentsSeparatedByString:@"&"];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *pair in pairs) {
//        NSArray *kv = [pair componentsSeparatedByString:@"="];
//        NSString *val =
//        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        params[kv[0]] = val;
//    }
//    return params;
//}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], touchPoint))
		{
            self.current = [NSString stringWithFormat:@"%d",index];
			[self ShowDetailView:imgView];
			break;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches] anyObject];
	
	for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], [touch locationInView:scrollView]))
		{
			[self ShowDetailView:imgView];
			break;
		}
	}
}

-(void)ShowDetailView:(UIImageView *)imgView
{
	imageView.image = imgView.image;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)PFDelannaApi:(id)sender getRoomtypeByIDResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    [self.DetailroomtypeOffline setObject:response forKey:@"DetailroomtypeArray"];
    
    [self.waitView removeFromSuperview];
    
    NSString *length = [NSString stringWithFormat:@"%@",[response objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(139, 94, 60);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.feature1.frame = CGRectMake(self.feature1.frame.origin.x, self.feature1.frame.origin.y+self.detail1.frame.size.height-10, self.feature1.frame.size.width, self.feature1.frame.size.height);
        
        self.feature1.text = [self.obj objectForKey:@"feature"];
        CGRect frame1 = self.feature1.frame;
        frame1.size = [self.feature1 sizeOfMultiLineLabel];
        [self.feature1 sizeOfMultiLineLabel];
        
        [self.feature1 setFrame:frame1];
        int lines1 = self.feature1.frame.size.height/15;
        self.feature1.numberOfLines = lines1;
        
        UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
        descText1.textColor = RGB(245, 211, 40);
        descText1.text = self.feature1.text;
        descText1.numberOfLines = lines1;
        [descText1 setFont:[UIFont systemFontOfSize:15]];
        self.feature1.alpha = 0;
        [self.headerImgView addSubview:descText1];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height+self.feature1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
    
    } else {
        
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
        
        self.feature.frame = CGRectMake(self.feature.frame.origin.x, self.feature.frame.origin.y+self.detail.frame.size.height-10, self.feature.frame.size.width, self.feature.frame.size.height);
        
        self.feature.text = [self.obj objectForKey:@"feature"];
        CGRect frame1 = self.feature.frame;
        frame1.size = [self.feature sizeOfMultiLineLabel];
        [self.feature sizeOfMultiLineLabel];
        
        [self.feature setFrame:frame1];
        int lines1 = self.feature.frame.size.height/15;
        self.feature.numberOfLines = lines1;
        
        UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
        descText1.textColor = RGB(245, 211, 40);
        descText1.text = self.feature.text;
        descText1.numberOfLines = lines1;
        [descText1 setFont:[UIFont systemFontOfSize:15]];
        self.feature.alpha = 0;
        [self.headerView addSubview:descText1];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height+self.feature.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"],@"?width=800&height=600"];
        //imageView.imageURL = [NSURL URLWithString:urlimg];
        
        //
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        //
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"],@"?width=800&height=600"];
            //img.imageURL = [[NSURL alloc] initWithString:urlimg];
            
            //
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            //
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
}

- (void)PFDelannaApi:(id)sender getRoomtypeByIDErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    NSString *length = [NSString stringWithFormat:@"%@",[[self.DetailroomtypeOffline objectForKey:@"DetailroomtypeArray"] objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(139, 94, 60);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.feature1.frame = CGRectMake(self.feature1.frame.origin.x, self.feature1.frame.origin.y+self.detail1.frame.size.height-10, self.feature1.frame.size.width, self.feature1.frame.size.height);
        
        self.feature1.text = [self.obj objectForKey:@"feature"];
        CGRect frame1 = self.feature1.frame;
        frame1.size = [self.feature1 sizeOfMultiLineLabel];
        [self.feature1 sizeOfMultiLineLabel];
        
        [self.feature1 setFrame:frame1];
        int lines1 = self.feature1.frame.size.height/15;
        self.feature1.numberOfLines = lines1;
        
        UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
        descText1.textColor = RGB(245, 211, 40);
        descText1.text = self.feature1.text;
        descText1.numberOfLines = lines1;
        [descText1 setFont:[UIFont systemFontOfSize:15]];
        self.feature1.alpha = 0;
        [self.headerImgView addSubview:descText1];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height+self.feature1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
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
        
        self.feature.frame = CGRectMake(self.feature.frame.origin.x, self.feature.frame.origin.y+self.detail.frame.size.height-10, self.feature.frame.size.width, self.feature.frame.size.height);
        
        self.feature.text = [self.obj objectForKey:@"feature"];
        CGRect frame1 = self.feature.frame;
        frame1.size = [self.feature sizeOfMultiLineLabel];
        [self.feature sizeOfMultiLineLabel];
        
        [self.feature setFrame:frame1];
        int lines1 = self.feature.frame.size.height/15;
        self.feature.numberOfLines = lines1;
        
        UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
        descText1.textColor = RGB(245, 211, 40);
        descText1.text = self.feature.text;
        descText1.numberOfLines = lines1;
        [descText1 setFont:[UIFont systemFontOfSize:15]];
        self.feature.alpha = 0;
        [self.headerView addSubview:descText1];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height+self.feature.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[[self.DetailroomtypeOffline objectForKey:@"DetailroomtypeArray"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"],@"?width=800&height=600"];
        //imageView.imageURL = [NSURL URLWithString:urlimg];
        
        //
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        //
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[[self.DetailroomtypeOffline objectForKey:@"DetailroomtypeArray"] objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[[self.DetailroomtypeOffline objectForKey:@"DetailroomtypeArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"],@"?width=800&height=600"];
            //img.imageURL = [[NSURL alloc] initWithString:urlimg];
            
            //
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            //
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[[self.DetailroomtypeOffline objectForKey:@"DetailroomtypeArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }

}

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
}

- (IBAction)fullimgalbumTapped:(id)sender {
    
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];
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
        if([self.delegate respondsToSelector:@selector(PFDetailRoomtypeViewControllerBack)]){
            [self.delegate PFDetailRoomtypeViewControllerBack];
        }
    }
}

@end
