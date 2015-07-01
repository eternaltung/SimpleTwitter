//
//  User.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString * const userLoginNotification;
extern NSString * const userLogoutNotification;

@interface User : NSObject
@property (assign, nonatomic) int userID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImg;
@property (strong, nonatomic) NSString *desc;
@property (assign, nonatomic) int followersCount;
@property (assign, nonatomic) int friendsCount;
@property (strong, nonatomic) NSString *location;

- (id)initWithDictionary:(NSDictionary*)dict;
+ (User*)currentUser;
+ (void)setCurrentUser:(User*)user;
+ (void)logout;
@end
