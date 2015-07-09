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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setUIData];
}

- (void)setUIData{
    [self.MediaImg setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.tweet.tweetMedia]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.MediaImg.alpha = 0;
        self.MediaImg.transform = CGAffineTransformMakeScale(0.4, 0.4);
        self.MediaImg.image = image;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.MediaImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.MediaImg.alpha = 1;
        } completion:nil];
    } failure:nil];
}

- (IBAction)BackPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
