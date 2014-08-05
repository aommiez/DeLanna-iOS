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
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Reset
- (void)saveReset:(NSString *)reset {
    [self.userDefaults setObject:reset forKey:@"reset"];
}

- (NSString *)getReset {
    return [self.userDefaults objectForKey:@"reset"];
}

#pragma mark - App Language
- (void)saveLanguage:(NSString *)language {
    [self.userDefaults setObject:language forKey:@"language"];
}

- (NSString *)getLanguage {
    return [self.userDefaults objectForKey:@"language"];
}

#pragma mark - Content Language
- (void)saveContentLanguage:(NSString *)contentlanguage {
    [self.userDefaults setObject:contentlanguage forKey:@"contentlanguage"];
}

- (NSString *)getContentLanguage {
    return [self.userDefaults objectForKey:@"contentlanguage"];
}

#pragma mark - Overview
- (void)getFeed:(NSString *)language limit:(NSString *)limit{
    NSString *urlStr = [[NSString alloc] init];
    
    if ([limit isEqualToString:@""]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@feed?lang=%@",API_URL,language];
    } else {
        urlStr = [[NSString alloc] initWithFormat:@"%@feed?limit=%@&lang=%@",API_URL,limit,language];
    }
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getFeedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getFeedErrorResponse:[error localizedDescription]];
    }];
}

- (void)getFeedDetail:(NSString *)language {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@feed/detail?lang=%@",API_URL,language];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getFeedDetailResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getFeedDetailErrorResponse:[error localizedDescription]];
    }];
}

- (void)getFeedGallery {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@feed/gallery",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getFeedGalleryResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getFeedGalleryErrorResponse:[error localizedDescription]];
    }];
}

- (void)getTimeUpdate {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@timeupdate",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getTimeUpdateResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getTimeUpdateErrorResponse:[error localizedDescription]];
    }];
}

#pragma mark - Roomtype
- (void)getRoomtype:(NSString *)language {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@roomtype?lang=%@",API_URL,language];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getRoomtypeResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getRoomtypeErrorResponse:[error localizedDescription]];
    }];
}

- (void)getRoomtypeByID:(NSString *)roomtype_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@roomtype/%@/pictures",API_URL,roomtype_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getRoomtypeByIDResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getRoomtypeByIDErrorResponse:[error localizedDescription]];
    }];
}

#pragma mark - Service
- (void)getService:(NSString *)language {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@node?lang=%@",API_URL,language];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getServiceResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getServiceErrorResponse:[error localizedDescription]];
    }];
}

- (void)getServiceFoldertype:(NSString *)servicefoldertype_id language:(NSString *)language {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@node/%@/children?lang=%@",API_URL,servicefoldertype_id,language];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getServiceFoldertypeResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getServiceFoldertypeErrorResponse:[error localizedDescription]];
    }];
}

- (void)getServiceFood:(NSString *)servicefood_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@service/%@/pictures",API_URL,servicefood_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getServiceFoodResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getServiceFoodErrorResponse:[error localizedDescription]];
    }];
}

- (void)getServiceRoom:(NSString *)serviceroom_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@service/%@/pictures",API_URL,serviceroom_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getServiceRoomResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getServiceRoomErrorResponse:[error localizedDescription]];
    }];
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
