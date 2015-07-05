//
//  UserProfileCell.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "UserProfileCell.h"
#import <UIImageView+AFNetworking.h>

@interface UserProfileCell()
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FollowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *FollowingLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UserViewSegmented;
- (IBAction)UserViewChange:(UISegmentedControl *)sender;

@end

@implementation UserProfileCell

- (void)awakeFromNib {
    self.ProfileImg.layer.cornerRadius = 3;
    self.ProfileImg.clipsToBounds = YES;
    self.UserViewSegmented.selectedSegmentIndex = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUIData{
    [self.ProfileImg setImageWithURL:[NSURL URLWithString:self.user.profileImg]];
    self.NameLabel.text = self.user.name;
    self.ScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.FollowingLabel.text = [NSString stringWithFormat:@"%d",self.user.friendsCount];
    self.FollowerLabel.text = [NSString stringWithFormat:@"%d",self.user.followersCount];
}

- (IBAction)UserViewChange:(UISegmentedControl *)sender {
    [self.delegate changeSelectView:(int)sender.selectedSegmentIndex];
}
@end
