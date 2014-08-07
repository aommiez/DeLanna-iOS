//
//  PFServiceroomViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/22/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFServiceroomViewController.h"

@interface PFServiceroomViewController ()

@end

@implementation PFServiceroomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.serviceroomOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *id = [NSString stringWithFormat:@"%@",[self.obj objectForKey:@"id"]];
    [self.DelannaApi getServiceRoom:id];
    
    self.name.text = [self.obj objectForKey:@"name"];
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    //
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

- (void)PFDelannaApi:(id)sender getServiceRoomResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    [self.serviceroomOffline setObject:response forKey:@"serviceroomArray"];
    
    [self.waitView removeFromSuperview];
//    [self.NoInternetView removeFromSuperview];
//    self.checkinternet = @"connect";
    
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
        descText.textAlignment = NSTextAlignmentCenter;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height-20);
        
        
        self.tableView.tableHeaderView = self.headerImgView;
        
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
        descText.textAlignment = NSTextAlignmentCenter;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        
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
- (void)PFDelannaApi:(id)sender getServiceRoomErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
//    self.checkinternet = @"error";
//    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
//    [self.view addSubview:self.NoInternetView];
    
    NSString *length = [NSString stringWithFormat:@"%@",[[self.serviceroomOffline objectForKey:@"serviceroomArray"] objectForKey:@"length"]];
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
        descText.textAlignment = NSTextAlignmentCenter;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height-20);
        
        
        self.tableView.tableHeaderView = self.headerImgView;
        
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
        descText.textAlignment = NSTextAlignmentCenter;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[[self.serviceroomOffline objectForKey:@"serviceroomArray"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"],@"?width=800&height=600"];
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
        
        for (int i=0; i<[[[self.serviceroomOffline objectForKey:@"serviceroomArray"] objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[[self.serviceroomOffline objectForKey:@"serviceroomArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"],@"?width=800&height=600"];
            //img.imageURL = [[NSURL alloc] initWithString:urlimg];
            
            //
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            //
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[[self.serviceroomOffline objectForKey:@"serviceroomArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFServiceroomViewControllerBack)]){
            [self.delegate PFServiceroomViewControllerBack];
        }
    }
}

@end
