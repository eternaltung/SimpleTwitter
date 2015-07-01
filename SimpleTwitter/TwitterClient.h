//
//  TwitterClient.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient*)shareInstance;

- (void)loginCompleted:(void (^)(User *user, NSError *error))complete;
- (void)openURL:(NSURL*)url;
- (void)getHomeTimeline:(NSDictionary*)param completion:(void (^)(NSArray *array, NSError *error))completion;
- (void)getUserTimeline:(NSDictionary*)param completion:(void (^)(NSArray *array, NSError *error))completion;
- (void)postNewTweet:(NSDictionary*)param completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)postReTweet:(NSString*)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unFavorite:(NSString*)tweetID completion:(void (^)(NSError *error))completion;
- (void)Favorite:(NSString*)tweetID completion:(void (^)(NSError *error))completion;
@end
