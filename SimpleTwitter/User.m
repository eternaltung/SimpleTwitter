//
//  User.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

//NSString * const userLoginNotification = @"userLoginNotification";
NSString * const userLogoutNotification = @"userLogoutNotification";

@interface User()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation User
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.dictionary = dict;
        self.userID = dict[@"id"];
        self.name = dict[@"name"];
        self.screenName = dict[@"screen_name"];
        self.profileImg = dict[@"profile_image_url"];
        self.desc = dict[@"description"];
        self.followersCount = [dict[@"followers_count"] intValue];
        self.friendsCount = [dict[@"friends_count"] intValue];
        self.location = dict[@"location"];
        self.profileBannerImg = dict[@"profile_banner_image"];
    }
    return self;
}

static User *currentUser = nil;
NSString * const currentUserKey = @"UserKey";

+ (User*)currentUser{
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserKey];
        if (data != nil) {
            currentUser = [[User alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User*)user{
    currentUser = user;
    
    if (currentUser != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization dataWithJSONObject:user.dictionary options:0 error:nil] forKey:currentUserKey];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:currentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout{
    [User setCurrentUser:nil];
    [[TwitterClient shareInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:userLogoutNotification object:nil];
}

@end
