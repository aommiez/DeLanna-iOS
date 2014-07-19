//
//  PFDelannaApi.m
//  DeLanna
//
//  Created by Pariwat on 7/18/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFDelannaApi.h"

@implementation PFDelannaApi

- (id) init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

#pragma mark - contact
- (void)getContact {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@contact",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getContactErrorResponse:[error localizedDescription]];
    }];
}

- (void)sendComment:(NSString *)comment {
    NSLog(@"%@",comment);
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@contact/comment",API_URL];
    NSDictionary *parameters = @{@"message":comment };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self sendCommentResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self sendCommentErrorResponse:[error localizedDescription]];
    }];
}

@end
