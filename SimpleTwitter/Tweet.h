//
//  Tweet.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *tweetID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL favorited;
@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) int retweetCount;
@property (strong, nonatomic) NSString *tweetMedia;
@property (assign, nonatomic) int favoriteCount;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) Tweet *reTweet;

- (id)initWithDictionary:(NSDictionary*)dict;

+ (NSArray*)tweetsWithArray:(NSArray*)array;

+ (NSArray*)tweetsWithMedia:(NSArray*)array;
@end
