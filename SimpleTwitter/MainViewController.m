//
//  MainViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MainViewController.h"
#import "Tweet.h"
#import "User.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <JVFloatingDrawerViewController.h>
#import "AppDelegate.h"
#import "MeViewController.h"
#import "ImageViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate, DetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetArray;
@property (assign, nonatomic) BOOL isInfiniteLoading;

- (IBAction)HandlePanGesture:(UIPanGestureRecognizer *)sender;

@end

@implementation MainViewController
NSString * const mediaReuseID = @"TweetCell";
NSString * const textReuseID = @"textCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:mediaReuseID];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:textReuseID];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addNavigationBar];
    [self addRefreshControl];
    self.isInfiniteLoading = NO;
    [self getHomeTimeLine];
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}*/

- (void)addRefreshControl{
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self getHomeTimeLine];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        self.isInfiniteLoading = YES;
        [self getHomeTimeLine];
    }];
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(MenuTap)];
    navitems.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(composeTweet)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

- (void)MenuTap{
    [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
}

//compose button tap
- (void)composeTweet{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComposeViewController *composeView = [sb instantiateViewControllerWithIdentifier:@"ComposeView"];
    composeView.delegate = self;
    [self showDetailViewController:composeView sender:self];
}

- (void)getHomeTimeLine{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(15) forKey:@"count"];
    if (self.isInfiniteLoading) {
        [params setObject:@([((Tweet*)[self.tweetArray lastObject]).tweetID integerValue] - 1) forKey:@"max_id"];
    }
    
    [[TwitterClient shareInstance] getHomeTimeline:params completion:^(NSArray *array, NSError *error) {
        if (!self.isInfiniteLoading) {
            self.tweetArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
            
            //update refresh control
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            [self.tableView.pullToRefreshView setSubtitle:[formatter stringFromDate:[NSDate date]] forState:SVPullToRefreshStateAll];
            [self.tableView.pullToRefreshView stopAnimating];
        }
        else{   //infinite loading
            [self.tweetArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }
            
        self.isInfiniteLoading = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma cell delegate
//click cell favorite button
- (void)TweetCell:(TweetCell *)cell didFavorite:(BOOL)value{
    [self reloadTableRow:[self.tableView indexPathForCell:cell] kind:@"Favorite" value:value];
}

//click cell reply button
-(void)TweetReplyCell:(TweetCell *)cell{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComposeViewController *composeView = [sb instantiateViewControllerWithIdentifier:@"ComposeView"];
    composeView.delegate = self;
    composeView.originTweet = self.tweetArray[[self.tableView indexPathForCell:cell].row];
    [self showDetailViewController:composeView sender:self];
}

//click cell retweet button
- (void)TweetCell:(TweetCell *)cell didRetweet:(BOOL)value{
    [self reloadTableRow:[self.tableView indexPathForCell:cell] kind:@"Retweet" value:value];
}

//click cell profile img
- (void)TweetCell:(TweetCell *)cell ProfileImgTapped:(User *)user{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeViewController *meView = [sb instantiateViewControllerWithIdentifier:@"MeView"];
    meView.user = user;
    [self showDetailViewController:meView sender:self];
}

//click cell media img
- (void)TweetCell:(TweetCell *)cell mediaImgTapped:(Tweet *)tweet{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageViewController *imgView = [sb instantiateViewControllerWithIdentifier:@"ImageView"];
    imgView.tweet = tweet;
    [self showDetailViewController:imgView sender:self];
}

#pragma detail view delegate
//detail view favorite click
- (void)DetailView:(DetailViewController *)DetailView didFavorite:(BOOL)value{
    [self reloadTableRow:DetailView.index kind:@"Favorite" value:value];
}

//detail view reply a tweet
- (void)DetailView:(DetailViewController *)DetailView didReply:(Tweet *)replyTweet{
    [self insertObjectToTimeline:0 tweet:replyTweet];
}

- (void)DetailView:(DetailViewController *)DetailView didRetweet:(BOOL)value{
    [self reloadTableRow:DetailView.index kind:@"Retweet" value:value];
}

//add new tweet on top
- (void)ComposeViewController:(ComposeViewController*)composeViewController didTweet:(Tweet*)tweet{
    [self insertObjectToTimeline:0 tweet:tweet];
}

#pragma private helper
//reload specific table view cell
- (void)reloadTableRow:(NSIndexPath*)index kind:(NSString*)kind value:(BOOL)value{
    if ([kind isEqualToString:@"Favorite"]) {
        value ? ((Tweet*)self.tweetArray[index.row]).favoriteCount++ : ((Tweet*)self.tweetArray[index.row]).favoriteCount--;
    }
    else if ([kind isEqualToString:@"Retweet"]){
        value ? ((Tweet*)self.tweetArray[index.row]).retweetCount++ : ((Tweet*)self.tweetArray[index.row]).retweetCount--;
    }
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertObjectToTimeline:(int)index tweet:(Tweet*)tweet{
    [self.tweetArray insertObject:tweet atIndex:index];
    [self.tableView reloadData];
}

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.tweetArray.count - 1) {
        //infinite loading
        [self.tableView triggerInfiniteScrolling];
    }
    
    Tweet *tweet = self.tweetArray[indexPath.row];
    //media tweet or text tweet
    TweetCell *cell = tweet.tweetMedia != nil ? [tableView dequeueReusableCellWithIdentifier:mediaReuseID] : [tableView dequeueReusableCellWithIdentifier:textReuseID];
    cell.tweet = tweet;
    cell.delegate = self;
    [cell setUIData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = self.tweetArray[indexPath.row];
    if (tweet.tweetMedia != nil && tweet.reTweet) {
        return 250.0;
    }
    else if (tweet.tweetMedia){
        return 200.0;
    }
    else {
        return 100.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.tweet = self.tweetArray[indexPath.row];
    detailview.index = indexPath;
    detailview.delegate = self;
    //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:detailview];
    [self showDetailViewController:detailview sender:self];
    
}

- (IBAction)HandlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        [self MenuTap];
    }
}
@end
