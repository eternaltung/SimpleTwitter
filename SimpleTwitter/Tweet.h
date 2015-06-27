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
@property (assign, nonatomic) int tweetID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) User *user;

- (id)initWithDictionary:(NSDictionary*)dict;

+ (NSArray*)tweetsWithArray:(NSArray*)array;
@end
