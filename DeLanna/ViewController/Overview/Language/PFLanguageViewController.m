//
//  PFLanguageViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFLanguageViewController.h"

@interface PFLanguageViewController ()

@end

@implementation PFLanguageViewController

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
    
    if ([self.statusSetting isEqualToString:@"app"]) {
        
        if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
            
            self.navigationItem.title = @"App Language";
            
            self.checkTH.hidden = YES;
            self.thai.textColor = RGB(170, 170, 170);
            self.thai.text = @"Thai (TH)";
            self.english.textColor = RGB(0, 0, 0);
            self.english.text = @"English (EN)";
            self.statusLanguage = @"EN";
            self.save.text = @"save";
        } else {
            
            self.navigationItem.title = @"ภาษาแอพพลิเคชั่น";
            
            self.checkEN.hidden = YES;
            self.thai.textColor = RGB(0, 0, 0);
            self.thai.text = @"ภาษาไทย (TH)";
            self.english.textColor = RGB(170, 170, 170);
            self.english.text = @"ภาษาอังกฤษ (EN)";
            self.statusLanguage = @"TH";
            self.save.text = @"บันทึก";
        }
    } else {
        if (![[self.DelannaApi getLanguage] isEqualToString:@"TH"]) {
            self.navigationItem.title = @"Content Language";
            self.thai.text = @"Thai (TH)";
            self.english.text = @"English (EN)";
            self.save.text = @"save";
        } else {
            self.navigationItem.title = @"ภาษาเนื้อหา";
            self.thai.text = @"ภาษาไทย (TH)";
            self.english.text = @"ภาษาอังกฤษ (EN)";
            self.save.text = @"บันทึก";
        }
        
        if (![[self.DelannaApi getContentLanguage] isEqualToString:@"TH"]) {
            
            self.checkTH.hidden = YES;
            self.statusLanguage = @"EN";
            self.thai.textColor = RGB(170, 170, 170);
            self.english.textColor = RGB(0, 0, 0);
        } else {
            
            self.checkEN.hidden = YES;
            self.statusLanguage = @"TH";
            self.thai.textColor = RGB(0, 0, 0);
            self.english.textColor = RGB(170, 170, 170);
        }
    }
    
    CALayer *saveButton = [self.saveButton layer];
    [saveButton setMasksToBounds:YES];
    [saveButton setCornerRadius:7.0f];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)ThaiTapped:(id)sender{
    self.checkEN.hidden = YES;
    self.checkTH.hidden = NO;
    self.thai.textColor = RGB(0, 0, 0);
    self.english.textColor = RGB(170, 170, 170);
    self.statusLanguage = @"TH";
}

- (IBAction)EnglishTapped:(id)sender{
    self.checkTH.hidden = YES;
    self.checkEN.hidden = NO;
    self.thai.textColor = RGB(170, 170, 170);
    self.english.textColor = RGB(0, 0, 0);
    self.statusLanguage = @"EN";
}

- (IBAction)saveTapped:(id)sender{
    if ([self.statusSetting isEqualToString:@"app"]) {
        [self.DelannaApi saveLanguage:self.statusLanguage];
        [self.delegate BackSetting];
        [self.DelannaApi saveReset:@"YES"];
    } else {
        [self.DelannaApi saveContentLanguage:self.statusLanguage];
        [self.delegate BackSetting];
        [self.DelannaApi saveReset:@"YES"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
