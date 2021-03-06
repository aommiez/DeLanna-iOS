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

#pragma mark - Notification
- (void)getNotification {
    
    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    NSString *lang = [self.userDefaults objectForKey:@"contentlanguage"];
    
    NSDictionary *parameters = @{@"key":key,@"type":type,@"lang":lang};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@device",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getNotificationErrorResponse:[error localizedDescription]];
    }];
}

- (void)Notification:(NSString *)limit link:(NSString *)link {
    
    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    NSString *lang = [self.userDefaults objectForKey:@"contentlanguage"];
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@notify?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    NSDictionary *parameters = @{@"key":key,@"type":type,@"lang":lang};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self NotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self NotificationErrorResponse:[error localizedDescription]];
    }];
}

- (void)setNotification {
    
    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    NSString *lang = [self.userDefaults objectForKey:@"contentlanguage"];
    
    NSDictionary *parameters = @{@"key":key,@"type":type,@"lang":lang};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@device",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getNotificationErrorResponse:[error localizedDescription]];
    }];
}

- (void)setOnNotification {

    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    NSString *admit = @"1";
    NSString *lang = [self.userDefaults objectForKey:@"contentlanguage"];
    
    NSDictionary *parameters = @{@"key":key,@"type":type,@"admit":admit,@"lang":lang};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@device",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)setOffNotification {
    
    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    NSString *admit = @"0";
    NSString *lang = [self.userDefaults objectForKey:@"contentlanguage"];
    
    NSDictionary *parameters = @{@"key":key,@"type":type,@"admit":admit,@"lang":lang};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@device",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)checkBadge {
    
    if (![[self.userDefaults objectForKey:@"deviceToken"] length] == 0) {
        NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
        NSString *type = [self.userDefaults objectForKey:@"type"];
        
        NSDictionary *parameters = @{@"key":key,@"type":type};
        NSString *strUrl = [[NSString alloc] initWithFormat:@"%@notify/unopened",API_URL];
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
        [self.manager  GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFDelannaApi:self checkBadgeResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFDelannaApi:self checkBadgeErrorResponse:[error localizedDescription]];
        }];
    }

}

- (void)display_notify_number {
    
    NSString *key = [self.userDefaults objectForKey:@"deviceToken"];
    NSString *type = [self.userDefaults objectForKey:@"type"];
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@device/reset/display_notify_number",API_URL];
    
    NSDictionary *parameters = @{@"type":type , @"key":key};
    
    [self.manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}

#pragma mark - Overview
- (void)getFeed:(NSString *)language limit:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@feed?limit=%@&lang=%@",API_URL,limit,language];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getFeedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getFeedErrorResponse:[error localizedDescription]];
    }];
}

- (void)getFeedById:(NSString *)news_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@feed/%@",API_URL,news_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getFeedByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getFeedByIdErrorResponse:[error localizedDescription]];
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
- (void)getRoomtype:(NSString *)language limit:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@roomtype?limit=%@&lang=%@",API_URL,limit,language];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
- (void)getService:(NSString *)language limit:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@node?limit=%@&lang=%@",API_URL,limit,language];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFDelannaApi:self getServiceResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFDelannaApi:self getServiceErrorResponse:[error localizedDescription]];
    }];
}

- (void)getServiceFoldertype:(NSString *)servicefoldertype_id language:(NSString *)language limit:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@node/%@/children?limit=%@&lang=%@",API_URL,servicefoldertype_id,limit,language];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

@end
