//
//  MentionViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MentionViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "AppDelegate.h"

@interface MentionViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetArray;
@end

@implementation MentionViewController
NSString *reuseID = @"TweetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:reuseID];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getMentions];
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(MenuTap)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

- (void)MenuTap{
    [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
}

- (void)getMentions{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(20) forKey:@"count"];
    
    [[TwitterClient shareInstance] getMentions:params completion:^(NSArray *tweets, NSError *error) {
        self.tweetArray = [NSMutableArray arrayWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = self.tweetArray[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.tweet = tweet;
    [cell setUIData];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

@end
