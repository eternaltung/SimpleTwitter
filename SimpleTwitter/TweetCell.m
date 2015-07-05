//
//  TweetCell.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/27/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>
#import "TwitterClient.h"
#import "TTTAttributedLabel.h"

@interface TweetCell() <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *FromRetweetImg;
@property (weak, nonatomic) IBOutlet UILabel *FromRetweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UserImg;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *TextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MediaImg;
@property (weak, nonatomic) IBOutlet UILabel *ScreenNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MediaImgConstraint;
@property (weak, nonatomic) IBOutlet UILabel *RetweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *FavoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *ReplyBitton;
@property (weak, nonatomic) IBOutlet UIButton *RetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *FavoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserImgTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TimeLabelTopConstraint;
- (IBAction)FavoritePress:(UIButton *)sender;
- (IBAction)RetweetPress:(UIButton *)sender;
- (IBAction)ReplyPress:(UIButton *)sender;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.UserImg.layer.cornerRadius = 3;
    self.UserImg.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)profileImgTap{
    self.tweet.reTweet ? [self.delegate TweetCell:self ProfileImgTapped:self.tweet.reTweet.user] : [self.delegate TweetCell:self ProfileImgTapped:self.tweet.user];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.TextLabel.preferredMaxLayoutWidth = self.TextLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
    self.UserImgTopConstraint.constant = 25;
    self.TimeLabelTopConstraint.constant = 25;
    self.FromRetweetImg.hidden = YES;
    self.FromRetweetLabel.hidden = YES;
}

- (void)setUIData{
    Tweet *showTweet = self.tweet;
    if (self.tweet.reTweet) {
        showTweet = self.tweet.reTweet;
        self.FromRetweetImg.hidden = NO;
        self.FromRetweetLabel.text = [NSString stringWithFormat:@"%@ Retweet",self.tweet.user.screenName];
        self.FromRetweetLabel.hidden = NO;
    }
    else{
        self.UserImgTopConstraint.constant = 8;
        self.TimeLabelTopConstraint.constant = 8;
    }
    
    [self.UserImg setImage:nil];
    [self.UserImg setImageWithURL:[NSURL URLWithString:showTweet.user.profileImg]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImgTap)];
    /*tapGesture.cancelsTouchesInView = YES;
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setNumberOfTapsRequired:1];*/
    [self.UserImg addGestureRecognizer:tapGesture];
    
    [self.MediaImg setImage:nil];
    if (self.tweet.tweetMedia != nil) {
        self.MediaImgConstraint.constant = 130.0;
        [self.MediaImg setImageWithURL:[NSURL URLWithString:showTweet.tweetMedia]];
    }
    else{
        self.MediaImgConstraint.constant = 0.0;
    }
    
    self.TextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.TextLabel.delegate = self;
    self.TextLabel.text = showTweet.text;
    self.NameLabel.text = showTweet.user.name;
    self.ScreenNameLabel.text = [NSString stringWithFormat:@"@%@", showTweet.user.screenName];
    self.TimeLabel.text = showTweet.createdTime.shortTimeAgoSinceNow;
    self.RetweetLabel.text = [NSString stringWithFormat:@"%d", showTweet.retweetCount];
    self.FavoriteLabel.text = [NSString stringWithFormat:@"%d", showTweet.favoriteCount];
    [self.FavoriteButton setImage:[UIImage imageNamed:showTweet.favorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    [self.RetweetButton setImage:[UIImage imageNamed:showTweet.retweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
}

- (IBAction)FavoritePress:(UIButton *)sender {
    self.tweet.favorited = !self.tweet.favorited;
    [self.FavoriteButton setImage:[UIImage imageNamed:self.tweet.favorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    
    //call favorite or unfavorite api
    self.tweet.favorited ? [[TwitterClient shareInstance] Favorite:self.tweet.tweetID completion:^(NSError *error) {
        if (error == nil) {
            [self.delegate TweetCell:self didFavorite:self.tweet.favorited];
        }
    }] :
    [[TwitterClient shareInstance] unFavorite:self.tweet.tweetID completion:^(NSError *error) {
        if (error == nil) {
            [self.delegate TweetCell:self didFavorite:self.tweet.favorited];
        }
    }];
}

- (IBAction)RetweetPress:(UIButton *)sender {
    //can't retweet self
    if ([self.tweet.user.screenName isEqualToString:[User currentUser].screenName] || self.tweet.retweeted)
        return;
    
    self.tweet.retweeted = !self.tweet.retweeted;
    [self.RetweetButton setImage:[UIImage imageNamed:self.tweet.retweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    [[TwitterClient shareInstance] postReTweet:self.tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.delegate TweetCell:self didRetweet:self.tweet.retweeted];
        }
    }];
}

- (IBAction)ReplyPress:(UIButton *)sender {
    [self.delegate TweetReplyCell:self];
}
@end
