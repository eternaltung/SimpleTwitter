//
//  ComposeViewController.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/28/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

- (void)ComposeViewController:(ComposeViewController*)composeViewController didTweet:(Tweet*)tweet;

@end

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) Tweet *originTweet;
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;
@end
