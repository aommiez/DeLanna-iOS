//
//  PFDelannaApi.h
//  DeLanna
//
//  Created by Pariwat on 7/18/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PFDelannaApiDelegate <NSObject>

#pragma mark - Contact Protocal Delegate
- (void)PFDelannaApi:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getContactErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender sendCommentResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse;

@end

@interface PFDelannaApi : NSObject

#pragma mark - Property
@property (assign, nonatomic) id delegate;
@property AFHTTPRequestOperationManager *manager;

#pragma mark - Contact
- (void)getContact;
- (void)sendComment:(NSString *)comment;

@end
