//
//  LeftDrawerViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import <UIImageView+AFNetworking.h>
#import "User.h"
#import "AppDelegate.h"
#import "MeViewController.h"
#import <JVFloatingDrawerViewController.h>
#import "MainViewController.h"

@interface LeftDrawerViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) UIColor *textColor;
@end

@implementation LeftDrawerViewController
NSString * const identifier = @"MenuCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textColor = [UIColor whiteColor];
    [self addHeader];
    
    self.menuItems = [NSArray arrayWithObjects:@"Me", @"TimeLine", @"Logout", nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0.0, 0.0, 0.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (void)addHeader{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)];
    img.layer.cornerRadius = 3;
    img.clipsToBounds = YES;
    [img setImageWithURL:[NSURL URLWithString:[User currentUser].profileImg]];
    [view addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 100, 50)];
    label.text = [User currentUser].name;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = self.textColor;
    [view addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 70, 100, 50)];
    subLabel.text = [User currentUser].location;
    subLabel.textColor = self.textColor;
    subLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:subLabel];
    
    self.tableView.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int fontsize = 20;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.menuItems[indexPath.row];
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:fontsize];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == 0) {   //My TimeLine
        MeViewController *meView = [sb instantiateViewControllerWithIdentifier:@"MeView"];
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:meView];
    }
    else if (indexPath.row == 1){ //Home TimeLine
        MainViewController *mainView = [sb instantiateViewControllerWithIdentifier:@"MainView"];
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:mainView];
    }
    else if (indexPath.row == 2){   //logout
        [User logout];
        return;
    }
    [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250;
    }
    return 70;
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
