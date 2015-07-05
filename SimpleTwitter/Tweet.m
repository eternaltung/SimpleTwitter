//
//  Tweet.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dict[@"user"]];
        self.tweetID = dict[@"id_str"];
        self.text = dict[@"text"];
        self.favorited = [dict[@"favorited"] boolValue];
        self.retweeted = [dict[@"retweeted"] boolValue];
        self.retweetCount = [dict[@"retweet_count"] intValue];
        self.favoriteCount = [dict[@"favorite_count"] intValue];
        if ([dict valueForKeyPath:@"entities.media.media_url"] != nil) {
            self.tweetMedia = [dict valueForKeyPath:@"entities.media.media_url"][0];
        }
        if ([dict valueForKeyPath:@"place.full_name"] != [NSNull null]) {
            self.place = [dict valueForKeyPath:@"place.full_name"];
        }
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdTime = [format dateFromString:dict[@"created_at"]];
        
        //is retweet
        if (dict[@"retweeted_status"] != nil) {
            self.reTweet = [[Tweet alloc] initWithDictionary:dict[@"retweeted_status"]];
        }
    }
    return self;

}

+ (NSArray*)tweetsWithArray:(NSArray*)array{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    return tweets;
}

+ (NSArray*)tweetsWithMedia:(NSArray*)array{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        if ([dict valueForKeyPath:@"entities.media.media_url"] != nil && [self checkImgExtension:[dict valueForKeyPath:@"entities.media.media_url"][0]]) {
            [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
        }
    }
    return tweets;
}

+ (BOOL)checkImgExtension:(NSString*)mediaUrl{
    NSArray *imageExtension = [NSArray arrayWithObjects:@".jpg", @".png", @".jpeg", @".gif", nil];
    for (int i = 0; i < imageExtension.count; i++) {
        if ([mediaUrl hasSuffix:[NSString stringWithFormat:@"%@", imageExtension[i]]]) {
            return YES;
        }
    }
    return NO;
}
@end
