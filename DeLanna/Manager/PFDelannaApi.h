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

#pragma mark - Overview Protocal Delegate
- (void)PFDelannaApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getFeedGalleryResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getFeedGalleryErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getFeedDetailResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getFeedDetailErrorResponse:(NSString *)errorResponse;

#pragma mark - Roomtype Protocal Delegate
- (void)PFDelannaApi:(id)sender getRoomtypeResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getRoomtypeErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getRoomtypeByIDResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getRoomtypeByIDErrorResponse:(NSString *)errorResponse;

#pragma mark - Service Protocal Delegate
- (void)PFDelannaApi:(id)sender getServiceResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getServiceFoodResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getServiceFoodErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getServiceFoldertypeResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getServiceFoldertypeErrorResponse:(NSString *)errorResponse;

- (void)PFDelannaApi:(id)sender getServiceRoomResponse:(NSDictionary *)response;
- (void)PFDelannaApi:(id)sender getServiceRoomErrorResponse:(NSString *)errorResponse;

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

#pragma mark - Overview
- (void)getFeed;
- (void)getFeedGallery;
- (void)getFeedDetail;

#pragma mark - Roomtype
- (void)getRoomtype;
- (void)getRoomtypeByID:(NSString *)roomtype_id;

#pragma mark - Service
- (void)getService;
- (void)getServiceFoldertype:(NSString *)servicefoldertype_id;
- (void)getServiceFood:(NSString *)servicefood_id;
- (void)getServiceRoom:(NSString *)serviceroom_id;

#pragma mark - Contact
- (void)getContact;
- (void)sendComment:(NSString *)comment;

@end
