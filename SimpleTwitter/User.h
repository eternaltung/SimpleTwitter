//
//  User.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImg;
@property (strong, nonatomic) NSString *desc;
@property (assign, nonatomic) int *followersCount;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
