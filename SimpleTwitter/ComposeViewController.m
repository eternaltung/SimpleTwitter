//
//  ComposeViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/28/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "Tweet.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import <MapKit/MapKit.h>

@interface ComposeViewController () <UITextViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImg;
@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;
@property (weak, nonatomic) IBOutlet UIButton *GeoButton;
- (IBAction)GeoPress:(UIButton *)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) BOOL isGeoOn;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContentTextView.delegate = self;
    self.isGeoOn = NO;
    [self addNavigationBar];
    [self setUIData];
    [self getCurrentLocation];
}

- (void)getCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = [locations lastObject];
    [manager stopUpdatingLocation];
}

- (void)setUIData{
    self.ProfileImg.layer.cornerRadius = 3;
    self.ProfileImg.clipsToBounds = YES;
    [self.ProfileImg setImageWithURL:[NSURL URLWithString:[User currentUser].profileImg]];
    self.NameLabel.text = [User currentUser].name;
    self.ScreenNameLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].screenName];
    if (self.originTweet) {
        self.ContentTextView.text = [NSString stringWithFormat:@"@%@", self.originTweet.user.screenName];
        [self textViewDidChange:self.ContentTextView];
    }
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(canelTap)];
    navitems.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sentTap)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

- (void)canelTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//post tweet
- (void)sentTap{
    if (self.ContentTextView.text.length <= 0)
        return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.ContentTextView.text forKey:@"status"];
    [dict setObject:@(true) forKey:@"display_coordinates"];
    if (self.isGeoOn && self.currentLocation.coordinate.latitude && self.currentLocation.coordinate.longitude) {
        [dict setObject:@(self.currentLocation.coordinate.latitude) forKey:@"lat"];
        [dict setObject:@(self.currentLocation.coordinate.longitude) forKey:@"long"];
    }
    
    //whether it's reply or new tweet
    if (self.originTweet) {
        [dict setObject:@([self.originTweet.tweetID integerValue]) forKey:@"in_reply_to_status_id"];
    }
    
    [[TwitterClient shareInstance] postNewTweet:dict completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.delegate ComposeViewController:self didTweet:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 140)
        return;
    
    self.CountLabel.text = [NSString stringWithFormat:@"%d", (int)(140 - textView.text.length)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return !(textView.text.length >= 140 && range.length == 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)GeoPress:(UIButton *)sender {
    self.isGeoOn = !self.isGeoOn;
    [self.GeoButton setImage:[UIImage imageNamed:self.isGeoOn ? @"geo_blue" : @"geo_grey"] forState:UIControlStateNormal];
}
@end
