//
//  PFDetailFoldertype1ViewController.m
//  DeLanna
//
//  Created by Pariwat on 8/8/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFDetailFoldertype1ViewController.h"

@interface PFDetailFoldertype1ViewController ()

@end

@implementation PFDetailFoldertype1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.foldertype1Offline = [NSUserDefaults standardUserDefaults];
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
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"en"];
    } else {
        [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"th"];
    }
    
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
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFDelannaApi:(id)sender getServiceFoldertypeResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    //    [self.NoInternetView removeFromSuperview];
    //    self.checkinternet = @"connect";
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self.foldertype1Offline setObject:response forKey:@"foldertypeArray"];
    [self.foldertype1Offline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFDelannaApi:(id)sender getServiceFoldertypeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    //    self.checkinternet = @"error";
    //    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    //    [self.view addSubview:self.NoInternetView];
    
    for (int i=0; i<[[[self.foldertype1Offline objectForKey:@"foldertypeArray"] objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[[self.foldertype1Offline objectForKey:@"foldertypeArray"] objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    if ([price isEqualToString:@"(null)"]) {
        PFFoldertype1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertype1Cell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertype1Cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        //cell.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    } else {
        PFFoldertypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertypeCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertypeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        //cell.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.price.text = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.baht.text = @"Baht";
        
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.NoInternetView removeFromSuperview];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
        if(IS_WIDESCREEN) {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
        } else {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
        }
        foldertypeView.obj = [self.arrObj objectAtIndex:indexPath.row];
        foldertypeView.delegate = self;
        [self.navigationController pushViewController:foldertypeView animated:YES];
        
    }
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"service_food"]) {
        
        PFServicefoodViewController *servicefoodView = [[PFServicefoodViewController alloc] init];
        if(IS_WIDESCREEN) {
            servicefoodView = [[PFServicefoodViewController alloc] initWithNibName:@"PFServicefoodViewController_Wide" bundle:nil];
        } else {
            servicefoodView = [[PFServicefoodViewController alloc] initWithNibName:@"PFServicefoodViewController" bundle:nil];
        }
        servicefoodView.obj = [self.arrObj objectAtIndex:indexPath.row];
        servicefoodView.delegate = self;
        [self.navigationController pushViewController:servicefoodView animated:YES];
        
    }
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"service_room"]) {
        
        PFServiceroomViewController *serviceroomView = [[PFServiceroomViewController alloc] init];
        if(IS_WIDESCREEN) {
            serviceroomView = [[PFServiceroomViewController alloc] initWithNibName:@"PFServiceroomViewController_Wide" bundle:nil];
        } else {
            serviceroomView = [[PFServiceroomViewController alloc] initWithNibName:@"PFServiceroomViewController" bundle:nil];
        }
        serviceroomView.obj = [self.arrObj objectAtIndex:indexPath.row];
        serviceroomView.delegate = self;
        [self.navigationController pushViewController:serviceroomView animated:YES];
        
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFDetailFoldertypeViewControllerBack {
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)PFServicefoodViewControllerBack {
    if ([self.checkinternet isEqualToString:@"error"]) {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    } else {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)PFServiceroomViewControllerBack {
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
        if([self.delegate respondsToSelector:@selector(PFDetailFoldertype1ViewControllerBack)]){
            [self.delegate PFDetailFoldertype1ViewControllerBack];
        }
    }
}


@end
