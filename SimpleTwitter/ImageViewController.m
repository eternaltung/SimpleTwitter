//
//  ImageViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/7/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "ImageViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MediaImg;
- (IBAction)BackPress:(UIButton *)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUIData{
    [self.MediaImg setImageWithURL:[NSURL URLWithString:self.tweet.tweetMedia]];
}

- (IBAction)BackPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
