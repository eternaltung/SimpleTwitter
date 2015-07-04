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

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController
NSString *selfreuseID = @"TweetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:selfreuseID];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)addNavigationBar{
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    navbar.tintColor = [UIColor whiteColor];
    
    UINavigationItem *navitems = [[UINavigationItem alloc] init];
    navitems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(MenuTap)];
    navbar.items = @[navitems];
    
    [self.view addSubview:navbar];
}

#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tweet *tweet = self.tweetArray[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:selfreuseID];
    cell.tweet = tweet;
    [cell setUIData];
    return cell;
}

- (void)MenuTap{
    [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
