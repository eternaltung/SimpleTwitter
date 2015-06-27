//
//  TwitterClient.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient*)shareInstance;

- (void)loginCompleted:(void (^)(User *user, NSError *error))complete;
- (void)openURL:(NSURL*)url;

- (void)getHomeTimeline:(void (^)(NSArray *array, NSError *error))complete;
@end
