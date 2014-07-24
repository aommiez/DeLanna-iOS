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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CALayer *reserveButton = [self.reserveButton layer];
    [reserveButton setMasksToBounds:YES];
    [reserveButton setCornerRadius:7.0f];
    
    self.arrObj = [[NSMutableArray alloc] init];

    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *id = [NSString stringWithFormat:@"%@",[self.obj objectForKey:@"id"]];
    [self.DelannaApi getRoomtypeByID:id];
    
    //NSLog(@"%@",self.obj);
    self.name.text = [self.obj objectForKey:@"name"];
    self.price.text = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"price"]];
    /*
     check EN or TH
     */
    self.baht.text = @"Baht";
    
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

    self.titlefeature.frame = CGRectMake(self.titlefeature.frame.origin.x, self.titlefeature.frame.origin.y+self.detail.frame.size.height-10, self.titlefeature.frame.size.width, self.titlefeature.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height+self.feature.frame.size.height-20);
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)share {
    [[[UIAlertView alloc] initWithTitle:@"De Lanna Hotel"
                                message:@"Coming soon."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
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

- (void)PFDelannaApi:(id)sender getRoomtypeByIDResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    scrollView.delegate = self;
	scrollView.scrollEnabled = YES;
	int scrollWidth = 70;
	scrollView.contentSize = CGSizeMake(scrollWidth,70);
    
    int xOffset = 0;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"],@"?width=800&height=600"];
    imageView.imageURL = [NSURL URLWithString:urlimg];
    
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
        img.imageURL = [[NSURL alloc] initWithString:urlimg];
        
		[images insertObject:img atIndex:i];
        
        [self.arrgalleryimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
        
		scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
		[scrollView addSubview:[images objectAtIndex:i]];
		
		xOffset += 70;
    }
}

- (void)PFDelannaApi:(id)sender getRoomtypeByIDErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
}

- (IBAction)fullimgalbumTapped:(id)sender {
    
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];
}

- (IBAction)reserveTapped:(id)sender{
    
    PFWebViewController *webView = [[PFWebViewController alloc] init];
    if(IS_WIDESCREEN) {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController_Wide" bundle:nil];
    } else {
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController" bundle:nil];
    }
    webView.delegate = self;
    [self.navigationController pushViewController:webView animated:YES];
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
