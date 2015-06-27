//
//  TwitterClient.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const consumerKey = @"";
NSString * const consumerSercet = @"";
NSString * const baseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (strong, nonatomic) void (^loginCompleted)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient*)shareInstance{
    static TwitterClient *instance = nil;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] consumerKey:consumerKey consumerSecret:consumerSercet];
        }
    });
    return instance;
}

- (void)loginCompleted:(void (^)(User *user, NSError *error))complete{
    self.loginCompleted = complete;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"raytwitter://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]]];
    } failure:^(NSError *error) {
        NSLog(@"error");
        self.loginCompleted(nil, error);
    }];
}

- (void)openURL:(NSURL*)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        NSLog(@"accessToken:%@",accessToken.token);
        
        //get user
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            self.loginCompleted(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail to get user");
            self.loginCompleted(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"fail to get access token");
    }];
}

- (void)getHomeTimeline:(void (^)(NSArray *array, NSError *error))complete{
    
    [[TwitterClient shareInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        complete(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to get timeline");
        complete(nil, error);
    }];
}

@end
