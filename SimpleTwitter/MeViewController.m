//
//  MeViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetCell.h"
#import "UserProfileCell.h"
#import <UIImageView+AFNetworking.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import <JVFloatingDrawerViewController.h>

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource, UserProfileCellDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableArray *tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *BannerImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BannerImgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BannerImgTopConstraint;
@property (strong, nonatomic) UIVisualEffectView *blurView;     //for banner blur effect
@property (assign, nonatomic) BOOL isBannerBlur;

@end

@implementation MeViewController
NSString *selfreuseID = @"TweetCell";
NSString *profilereuseID = @"ProfileCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    
    self.isBannerBlur = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:selfreuseID];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellReuseIdentifier:profilereuseID];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //add pan gesture
    UIPanGestureRecognizer *tablePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    tablePanGesture.delegate = self;
    tablePanGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tablePanGesture];
    
    [self getBanner];
    [self getUserTimeLine:0];
}

//get user banner
- (void)getBanner{
    if (self.user.profileBannerImg == nil) {
        [[TwitterClient shareInstance] getUserBanner:self.user.userID completion:^(NSDictionary *bannerData, NSError *error) {
            if (bannerData != nil) {
                //have banner img
                self.user.profileBannerImg = [bannerData valueForKeyPath:@"sizes.mobile_retina.url"];
                [self.BannerImg setImageWithURL:[NSURL URLWithString:self.user.profileBannerImg]];
            }
            else{
                //not have banner img
                [self.BannerImg setImage:[UIImage imageNamed:@"bannerBG"]];
            }
        }];
    }
}

- (void)getUserTimeLine:(int)sourceID{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(20) forKey:@"count"];
    [params setObject:self.user.screenName forKey:@"screen_name"];
    
    if (sourceID == 0) {    //user timeline
        [[TwitterClient shareInstance] getUserTimeline:params completion:^(NSArray *array, NSError *error) {
            self.tweetArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];
    }
    else if (sourceID == 1){    //media timeline
        [[TwitterClient shareInstance] getUserMedia:params completion:^(NSArray *array, NSError *error) {
            self.tweetArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];
    }
    else if (sourceID == 2){    //favorite timeline
        [[TwitterClient shareInstance] getUserFavorites:params completion:^(NSArray *array, NSError *error) {
            self.tweetArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }];
    }
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];

    //show menu or back icon
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:self.isComeFromMenu ? @"menu" : @"back"] style:UIBarButtonItemStylePlain target:self action:@selector(MenuTap)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

//user change view source
-(void)changeSelectView:(int)index{
    switch (index) {
        case 0:
            [self getUserTimeLine:0];
            break;
        case 1:
            [self getUserTimeLine:1];
            break;
        case 2:
            [self getUserTimeLine:2];
            break;
        default:
            break;
    }
}

//handle gesture while tableview scroll still working
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:profilereuseID];
        cell.user = self.user;
        [cell setUIData];
        cell.delegate = self;
        return cell;
    }
    
    Tweet *tweet = self.tweetArray[(int)indexPath.row - 1];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:selfreuseID];
    cell.tweet = tweet;
    [cell setUIData];
    return cell;
}

- (void)MenuTap{
    if (self.isComeFromMenu) {
        [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// table view pan gesture
- (void)onPan:(UIPanGestureRecognizer*)sender{
    CGPoint translation = [sender translationInView:self.view];
    //CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"begin:%f",translation.y);
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
        if (self.tableView.contentOffset.y < 0) {
            //pull down
            self.TableTopConstraint.constant = 155 + translation.y;
            self.BannerImgHeightConstraint.constant = 100 + translation.y;
        }
        else if (self.BannerImgHeightConstraint.constant > 50){
            //scroll down
            self.TableTopConstraint.constant = 155 + translation.y;
            self.BannerImgHeightConstraint.constant = 100 + translation.y;
            //NSLog(@"offset:%f",self.tableView.contentOffset.y);
            //NSLog(@"tran:%f",translation.y);
        }
        else if (self.BannerImgHeightConstraint.constant <= 50 ){
            //add blur if scroll down more than 50
            
            if (self.tableView.contentOffset.y <= 50) {
                //restore blur and size
                //NSLog(@"con:%f",self.tableView.contentOffset.y);
                self.TableTopConstraint.constant = self.TableTopConstraint.constant + self.tableView.contentOffset.y;
                self.BannerImgHeightConstraint.constant = self.BannerImgHeightConstraint.constant + self.tableView.contentOffset.y;
                [self.blurView removeFromSuperview];
                self.isBannerBlur = NO;
            }
            else{
                [self addBlurEffectView];
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
        //NSIndexPath *visibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
        if (self.BannerImgHeightConstraint.constant > 100 ) {
            self.TableTopConstraint.constant = 155;
            self.BannerImgHeightConstraint.constant = 100;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*NSIndexPath *visibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];

    if (visibleIndexPath.row > 3){
        [self addBlurEffectView];
    }
    else{
        [self.blurView removeFromSuperview];
        self.isBannerBlur = NO;
    }*/
}

- (void)addBlurEffectView{
    if (!self.isBannerBlur) {
        self.isBannerBlur = YES;
        //self.BannerImgHeightConstraint.constant = 50;
        //self.TableTopConstraint.constant = 105;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.blurView setFrame:self.BannerImg.bounds];
        
        UILabel *label = [UILabel new];
        label.text = self.user.name;
        label.center = self.BannerImg.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.frame = self.blurView.bounds;
        
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurEffect]];
        //vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        vibrancyEffectView.frame = self.blurView.bounds;
        [vibrancyEffectView addSubview: label];
        [self.blurView.contentView addSubview:vibrancyEffectView];
        [self.BannerImg addSubview:self.blurView];
        NSLog(@"%f",label.frame.size.width);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
