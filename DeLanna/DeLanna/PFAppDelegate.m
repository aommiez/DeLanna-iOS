//
//  PFAppDelegate.m
//  DeLanna
//
//  Created by MRG on 7/8/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFAppDelegate.h"

@implementation PFAppDelegate

BOOL newMedia;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.overview = [[PFOverViewController alloc] init];
    self.roomtype = [[PFRoomTypeViewController alloc] init];
    self.service = [[PFServiceViewController alloc] init];
    self.contact = [[PFContactViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        self.overview = [[PFOverViewController alloc] initWithNibName:@"PFOverViewController_Wide" bundle:nil];
        self.roomtype = [[PFRoomTypeViewController alloc] initWithNibName:@"PFRoomTypeViewController_Wide" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController_Wide" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController_Wide" bundle:nil];
        
    } else {
        self.overview = [[PFOverViewController alloc] initWithNibName:@"PFOverViewController" bundle:nil];
        self.roomtype = [[PFRoomTypeViewController alloc] initWithNibName:@"PFRoomTypeViewController" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController" bundle:nil];
        
    }
    
    self.tabBarViewController = [[PFTabBarViewController alloc] initWithBackgroundImage:nil viewControllers:self.overview,self.roomtype,self.service,self.contact,nil];
    
    self.overview.delegate = self;
    self.roomtype.delegate = self;
    self.service.delegate = self;
    self.contact.delegate = self;
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        if(IS_WIDESCREEN){
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"en_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"en_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"en_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"en_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"en_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"en_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"en_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"en_resevation_off"]];
            
        }else{
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"en_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"en_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"en_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"en_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"en_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"en_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"en_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"en_resevation_off"]];
            
        }
    } else {
        if(IS_WIDESCREEN){
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"th_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"th_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"th_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"th_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"th_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"th_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"th_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"th_resevation_off"]];
            
        }else{
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"th_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"th_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"th_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"th_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"th_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"th_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"th_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"th_resevation_off"]];
            
        }
    }

    [self.tabBarViewController setSelectedIndex:3];
    [self.tabBarViewController setSelectedIndex:2];
    [self.tabBarViewController setSelectedIndex:1];
    [self.tabBarViewController setSelectedIndex:0];
    
    [self.window setRootViewController:self.tabBarViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is : %@", dt);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dt forKey:@"deviceToken"];
    [defaults setObject:@"ios" forKey:@"type"];
    [defaults setObject:@"EN" forKey:@"contentlanguage"];
    [defaults synchronize];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    [self.DelannaApi getNotification];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:63];
    
    for (int i=0; i<63; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(36) % [letters length]]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"deviceToken"] length] == 0) {
        [defaults setObject:randomString forKey:@"deviceToken"];
    }
    [defaults setObject:@"no" forKey:@"type"];
    [defaults setObject:@"EN" forKey:@"contentlanguage"];
    [defaults synchronize];
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    [self.DelannaApi getNotification];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] forKey:@"badge"];
    [defaults synchronize];
	NSLog(@"Received notification: %@", [[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
}

- (void)PFDelannaApi:(id)sender getNotificationResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
}

- (void)PFDelannaApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFDelannaApi:(id)sender checkBadgeResponse:(NSDictionary *)response {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
    [defaults synchronize];
}

- (void)PFDelannaApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DeLanna" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DeLanna.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskAll);
}

- (void)HideTabbar {
    [self.tabBarViewController hideTabBarWithAnimation:YES];
}

- (void)ShowTabbar {
    [self.tabBarViewController showTabBarWithAnimation:YES];
}

- (void)resetApp {
    [self.DelannaApi saveReset:@"NO"];
    [self.DelannaApi setNotification];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.overview = [[PFOverViewController alloc] init];
    self.roomtype = [[PFRoomTypeViewController alloc] init];
    self.service = [[PFServiceViewController alloc] init];
    self.contact = [[PFContactViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        self.overview = [[PFOverViewController alloc] initWithNibName:@"PFOverViewController_Wide" bundle:nil];
        self.roomtype = [[PFRoomTypeViewController alloc] initWithNibName:@"PFRoomTypeViewController_Wide" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController_Wide" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController_Wide" bundle:nil];
        
    } else {
        self.overview = [[PFOverViewController alloc] initWithNibName:@"PFOverViewController" bundle:nil];
        self.roomtype = [[PFRoomTypeViewController alloc] initWithNibName:@"PFRoomTypeViewController" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController" bundle:nil];
        
    }
    
    self.tabBarViewController = [[PFTabBarViewController alloc] initWithBackgroundImage:nil viewControllers:self.overview,self.roomtype,self.service,self.contact,nil];
    
    self.overview.delegate = self;
    self.roomtype.delegate = self;
    self.service.delegate = self;
    self.contact.delegate = self;
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        if(IS_WIDESCREEN){
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"en_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"en_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"en_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"en_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"en_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"en_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"en_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"en_resevation_off"]];
            
        }else{
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"en_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"en_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"en_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"en_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"en_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"en_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"en_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"en_resevation_off"]];
            
        }
    } else {
        if(IS_WIDESCREEN){
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"th_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"th_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"th_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"th_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"th_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"th_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"th_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"th_resevation_off"]];
            
        }else{
            
            PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
            [item0 setHighlightedImage:[UIImage imageNamed:@"th_promotion_on"]];
            [item0 setStanbyImage:[UIImage imageNamed:@"th_promotion_off"]];
            
            PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
            [item1 setHighlightedImage:[UIImage imageNamed:@"th_roomtype_on"]];
            [item1 setStanbyImage:[UIImage imageNamed:@"th_roomtype_off"]];
            
            PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
            [item2 setHighlightedImage:[UIImage imageNamed:@"th_services_on"]];
            [item2 setStanbyImage:[UIImage imageNamed:@"th_services_off"]];
            
            PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
            [item3 setHighlightedImage:[UIImage imageNamed:@"th_resevation_on"]];
            [item3 setStanbyImage:[UIImage imageNamed:@"th_resevation_off"]];
            
        }
    }
    
    [self.tabBarViewController setSelectedIndex:3];
    [self.tabBarViewController setSelectedIndex:2];
    [self.tabBarViewController setSelectedIndex:1];
    [self.tabBarViewController setSelectedIndex:0];
    
    [self.window setRootViewController:self.tabBarViewController];
    [self.window makeKeyAndVisible];

}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:link]];
    [photos addObject:photo];
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    
    for (int i=0; i<[sum count]; i++) {
        NSString *t = [[NSString alloc] initWithFormat:@"%@",[sum objectAtIndex:i]];
        photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:t]];
        [photos addObject:photo];
    }
    
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:[current intValue]];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser DoneTappedDelegate:(NSUInteger)index {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //[self showTabbar];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser uploadTappedDelegate:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Profile Picture"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Camera Roll", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        [self useCamera];
    } else if ( buttonIndex == 1 ) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            [self useCameraRoll];
        }];
        
    }
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:   UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        imagePicker.navigationBarHidden=YES;
        imagePicker.view.userInteractionEnabled=YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    image = [self squareImageWithImage:image scaledToSize:CGSizeMake(640, 640)];
    [picker dismissViewControllerAnimated:YES completion:^{
        //accView.thumUser.image = image;
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
