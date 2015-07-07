//
//  TweetCell.h
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)TweetCell:(TweetCell*)cell didRetweet:(BOOL)value;
- (void)TweetReplyCell:(TweetCell*)cell;
- (void)TweetCell:(TweetCell*)cell didFavorite:(BOOL)value;
- (void)TweetCell:(TweetCell*)cell ProfileImgTapped:(User*)user;
- (void)TweetCell:(TweetCell*)cell mediaImgTapped:(Tweet*)tweet;

@end

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;
- (void)setUIData;
@end
