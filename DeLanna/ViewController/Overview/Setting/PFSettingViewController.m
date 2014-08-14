//
//  PFSettingViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFSettingViewController.h"

@interface PFSettingViewController ()

@end

@implementation PFSettingViewController

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
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
    if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Setting";
        self.languagesetting.text = @"Language Settings";
        self.applanguage.text = @"App Language";
        self.contentlanguage.text = @"Content Language";
        self.applanguagestatus.text = @"EN";
        
        self.notificationsetting.text = @"Notification Setting";
        self.notification.text = @"Notification";
    } else {
        self.navigationItem.title = @"ตั้งค่า";
        self.languagesetting.text = @"ตั้งค่าภาษา";
        self.applanguage.text = @"ภาษาแอพพลิเคชั่น";
        self.contentlanguage.text = @"ภาษาเนื้อหา";
        self.applanguagestatus.text = @"TH";
        
        self.notificationsetting.text = @"ตั้งค่าการแจ้งเตือน";
        self.notification.text = @"การแจ้งเตือน";
    }
    
    if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
        self.contentlanguagestatus.text = @"EN";
    } else {
        self.contentlanguagestatus.text = @"TH";
    }
    
    [self.DelannaApi getNotification];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)pushNotificationChange:(id)sender {
    if (self.pushNotification.on){
        NSLog(@"1");
        [self.DelannaApi setOnNotification];
    } else {
        NSLog(@"0");
        [self.DelannaApi setOffNotification];
    }
}

- (void)PFDelannaApi:(id)sender getNotificationResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[response objectForKey:@"has"] intValue] == 0) {
        self.pushNotification.on = NO;
    } else {
        self.pushNotification.on = YES;
    }
}

- (void)PFDelannaApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)appsettingTapped:(id)sender{
    
    PFLanguageViewController *languageView = [[PFLanguageViewController alloc] init];
    if(IS_WIDESCREEN) {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController_Wide" bundle:nil];
    } else {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    languageView.delegate = self;
    languageView.statusSetting = @"app";
    [self.navigationController pushViewController:languageView animated:YES];
}

- (IBAction)contentsettingTapped:(id)sender{
    
    PFLanguageViewController *languageView = [[PFLanguageViewController alloc] init];
    if(IS_WIDESCREEN) {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController_Wide" bundle:nil];
    } else {
        languageView = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    languageView.delegate = self;
    languageView.statusSetting = @"content";
    [self.navigationController pushViewController:languageView animated:YES];
}

- (void)BackSetting {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFSettingViewControllerBack)]){
            [self.delegate PFSettingViewControllerBack];
        }
    }
    
}

@end
