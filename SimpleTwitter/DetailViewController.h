//
//  DetailViewController.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/28/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)DetailView:(DetailViewController*)DetailView didRetweet:(BOOL)value;
- (void)DetailView:(DetailViewController*)DetailView didReply:(Tweet*)replyTweet;
- (void)DetailView:(DetailViewController*)DetailView didFavorite:(BOOL)value;

@end

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) NSIndexPath *index;
@property (weak, nonatomic) id<DetailViewControllerDelegate> delegate;

@end
