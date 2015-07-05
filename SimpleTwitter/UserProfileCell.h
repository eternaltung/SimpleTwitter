//
//  UserProfileCell.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class UserProfileCell;

@protocol UserProfileCellDelegate<NSObject>

- (void)changeSelectView:(int)index;

@end

@interface UserProfileCell : UITableViewCell

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<UserProfileCellDelegate> delegate;
- (void)setUIData;
@end
