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

BOOL loadFolder;
BOOL noDataFolder;
BOOL refreshDataFolder;

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
    
    loadFolder = NO;
    noDataFolder = NO;
    refreshDataFolder = NO;
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"en" limit:@"15" link:@"NO"];
    } else {
        [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"th" limit:@"15" link:@"NO"];
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
    
    self.checkinternet = @"connect";
    
    if (!refreshDataFolder) {
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
        noDataFolder = YES;
    } else {
        noDataFolder = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.foldertype1Offline setObject:response forKey:@"foldertype1Array"];
    [self.foldertype1Offline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFDelannaApi:(id)sender getServiceFoldertypeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    
    if (!refreshDataFolder) {
        for (int i=0; i<[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataFolder = YES;
    } else {
        noDataFolder = NO;
        self.paging = [[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"paging"] objectForKey:@"next"];
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
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
        if(IS_WIDESCREEN) {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
        } else {
            foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
        }
        self.navigationItem.title = @" ";
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
        self.navigationItem.title = @" ";
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
        self.navigationItem.title = @" ";
        serviceroomView.obj = [self.arrObj objectAtIndex:indexPath.row];
        serviceroomView.delegate = self;
        [self.navigationController pushViewController:serviceroomView animated:YES];
        
    }
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
        refreshDataFolder = YES;
        
        self.DelannaApi = [[PFDelannaApi alloc] init];
        self.DelannaApi.delegate = self;
        
        if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
            [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"en" limit:@"15" link:@"NO"];
        } else {
            [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"th" limit:@"15" link:@"NO"];
        }

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
        if (!noDataFolder) {
            refreshDataFolder = NO;
            
            self.DelannaApi = [[PFDelannaApi alloc] init];
            self.DelannaApi.delegate = self;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
                    [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"en" limit:@"NO" link:self.paging];
                } else {
                    [self.DelannaApi getServiceFoldertype:[self.obj objectForKey:@"id"] language:@"th" limit:@"NO" link:self.paging];
                }
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

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFDetailFoldertypeViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];

}

- (void)PFServicefoodViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];

}

- (void)PFServiceroomViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];

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
