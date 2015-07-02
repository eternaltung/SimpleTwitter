//
//  DetailViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/28/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "DetailViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>
#import "TTTAttributedLabel.h"

@interface DetailViewController () <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScreenLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *TweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MediaImg;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *RetweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *FavoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *ReplyButton;
@property (weak, nonatomic) IBOutlet UIButton *RetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *FavoriteButton;
@property (weak, nonatomic) IBOutlet UITextField *ReplyTextBox;
@property (weak, nonatomic) IBOutlet UIImageView *fromRetweetImg;
@property (weak, nonatomic) IBOutlet UILabel *fromRetweetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MediaImgConstraint;
- (IBAction)ReplyPress:(UIButton *)sender;
- (IBAction)RetweetPress:(UIButton *)sender;
- (IBAction)FavoritePress:(UIButton *)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    [self setUIData];
}

- (void)setUIData{
    Tweet *showTweet = self.tweet;
    if (self.tweet.reTweet) {
        showTweet = self.tweet.reTweet;
    }
    
    self.MediaImgConstraint.constant = 0;
    self.ProfileImg.layer.cornerRadius = 3;
    self.ProfileImg.clipsToBounds = YES;
    [self.ProfileImg setImageWithURL:[NSURL URLWithString:showTweet.user.profileImg]];
    self.NameLabel.text = showTweet.user.name;
    self.ScreenLabel.text = [NSString stringWithFormat:@"@%@",showTweet.user.screenName];
    
    //enable label to show hyperlink
    self.TweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.TweetTextLabel.delegate = self;
    self.TweetTextLabel.text = showTweet.text;
    
    if (self.tweet.tweetMedia){ //has media
        [self.MediaImg setImageWithURL:[NSURL URLWithString:showTweet.tweetMedia]];
        self.MediaImgConstraint.constant = 150;
    }
    self.TimeLabel.text = self.tweet.place ? [NSString stringWithFormat:@"%@ from %@", [showTweet.createdTime formattedDateWithFormat:@"YYYY/MM/dd hh:mm:ss a"], showTweet.place] :
        [showTweet.createdTime formattedDateWithFormat:@"YYYY/MM/dd hh:mm:ss a"];
    self.RetweetLabel.text = [NSString stringWithFormat:@"%d", showTweet.retweetCount];
    self.FavoriteLabel.text = [NSString stringWithFormat:@"%d", showTweet.favoriteCount];
    self.ReplyTextBox.text = [NSString stringWithFormat:@"@%@", [User currentUser].name];
    
    [self.FavoriteButton setBackgroundImage:[UIImage imageNamed:showTweet.favorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    [self.RetweetButton setBackgroundImage:[UIImage imageNamed:showTweet.retweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    
    if (self.tweet.reTweet) {
        self.fromRetweetImg.hidden = NO;
        self.fromRetweetLabel.hidden = NO;
        self.fromRetweetLabel.text = [NSString stringWithFormat:@"@%@ Retweet", self.tweet.user.screenName];
    }
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(canelTap)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

- (void)canelTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ReplyPress:(UIButton *)sender {
    if (self.ReplyTextBox.text.length <= 0)
        return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.ReplyTextBox.text forKey:@"status"];
    [param setObject:@([self.tweet.tweetID integerValue]) forKey:@"in_reply_to_status_id"];
    [[TwitterClient shareInstance] postNewTweet:param completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) { //reply success
            [self.delegate DetailView:self didReply:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)RetweetPress:(UIButton *)sender {
    //can't retweet self
    if ([self.tweet.user.screenName isEqualToString:[User currentUser].screenName] || self.tweet.retweeted)
        return;
    
    self.tweet.retweeted = !self.tweet.retweeted;
    [self.RetweetButton setBackgroundImage:[UIImage imageNamed:self.tweet.retweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    [[TwitterClient shareInstance] postReTweet:self.tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.delegate DetailView:self didRetweet:self.tweet.retweeted];
            self.RetweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        }
    }];
}

- (IBAction)FavoritePress:(UIButton *)sender {
    self.tweet.favorited = !self.tweet.favorited;
    [self.FavoriteButton setBackgroundImage:[UIImage imageNamed:self.tweet.favorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    
    //call favorite or unfavorite api
    self.tweet.favorited ? [[TwitterClient shareInstance] Favorite:self.tweet.tweetID completion:^(NSError *error) {
        if (error == nil) {
            [self.delegate DetailView:self didFavorite:self.tweet.favorited];
            self.FavoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        }
    }] :
    [[TwitterClient shareInstance] unFavorite:self.tweet.tweetID completion:^(NSError *error) {
        if (error == nil) {
            [self.delegate DetailView:self didFavorite:self.tweet.favorited];
            self.FavoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
