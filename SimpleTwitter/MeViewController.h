//
//  MeViewController.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MeViewController : UIViewController
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL isComeFromMenu;
@end
