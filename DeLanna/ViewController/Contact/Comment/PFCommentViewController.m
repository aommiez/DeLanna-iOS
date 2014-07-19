//
//  PFCommentViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/17/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFCommentViewController.h"

@interface PFCommentViewController ()

@end

@implementation PFCommentViewController

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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sent" style:UIBarButtonItemStyleDone target:self action:@selector(sentcomment)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.DelannaApi = [[PFDelannaApi alloc] init];
    self.DelannaApi.delegate = self;
    
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
//    NSString *dateString = [dateFormat stringFromDate:today];
//    self.date.text = dateString;
    
    [self.comment becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)sentcomment {
    if (self.comment.text.length > 10) {
        [self.DelannaApi sendComment:self.comment.text];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"De Lanna Hotel"
                                    message:@"Please fill more than 10 characters."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)PFDelannaApi:(id)sender sendCommentResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)PFDelannaApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.comment resignFirstResponder];
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFCommentViewControllerBack)]){
            [self.delegate PFCommentViewControllerBack];
        }
    }
}

@end
