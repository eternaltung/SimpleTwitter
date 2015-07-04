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
        
        //get user
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompleted(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail to get user");
            self.loginCompleted(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"fail to get access token");
    }];
}

- (void)getHomeTimeline:(NSDictionary*)param completion:(void (^)(NSArray *array, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to get timeline");
        completion(nil, error);
    }];
}

- (void)getUserTimeline:(NSDictionary*)param completion:(void (^)(NSArray *array, NSError *error))completion{
    [self GET:@"1.1/statuses/user_timeline.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to get timeline");
        completion(nil, error);
    }];
}

- (void)postNewTweet:(NSDictionary*)param completion:(void (^)(Tweet *tweet, NSError *error))completion{
    [self POST:@"1.1/statuses/update.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to post tweet");
        completion(nil, error);
    }];
}

- (void)Favorite:(NSString*)tweetID completion:(void (^)(NSError *error))completion{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([tweetID integerValue]) forKey:@"id"];
    [self POST:@"1.1/favorites/create.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to unFavorite");
        completion(error);
    }];
}

- (void)unFavorite:(NSString*)tweetID completion:(void (^)(NSError *error))completion{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([tweetID integerValue]) forKey:@"id"];
    [self POST:@"1.1/favorites/destroy.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to unFavorite");
        completion(error);
    }];
}

- (void)postReTweet:(NSString*)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion{
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject],nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail to retweet");
        completion(nil,error);
    }];
}

@end
