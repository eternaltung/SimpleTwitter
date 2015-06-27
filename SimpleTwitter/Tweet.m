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
        self.tweetID = (int)dict[@"id"];
        self.text = dict[@"text"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"EEE MMM d HH:mm:ss Z Y";
        self.createdTime = [format dateFromString:dict[@"created_at"]];
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
@end
