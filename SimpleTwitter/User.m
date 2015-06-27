//
//  User.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "User.h"

@implementation User
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.screenName = dict[@"screen_name"];
        self.profileImg = dict[@"profile_image_url"];
        self.desc = dict[@"description"];
    }
    return self;
}
@end
