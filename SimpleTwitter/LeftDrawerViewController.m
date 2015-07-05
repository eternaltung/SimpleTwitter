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
#import "MentionViewController.h"

typedef NS_ENUM(NSInteger, SectionIndex) {
    Me = 0,
    HomeTimeLine    = 1,
    Mentions        = 2,
    Logout    = 3
};

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
    
    self.menuItems = [NSArray arrayWithObjects:@"Me", @"TimeLine", @"Mentions", @"Logout", nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0.0, 0.0, 0.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (UIView*)addMeCell{
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
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int fontsize = 20;
    UITableViewCell *cell;
    if (indexPath.row == Me) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeCell"];
        [cell addSubview:[self addMeCell]];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.textLabel.text = self.menuItems[indexPath.row];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:fontsize];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == Me) {   //My TimeLine
        MeViewController *meView = [sb instantiateViewControllerWithIdentifier:@"MeView"];
        meView.user = [User currentUser];
        meView.isComeFromMenu = YES;
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:meView];
    }
    else if (indexPath.row == HomeTimeLine){ //Home TimeLine
        MainViewController *mainView = [sb instantiateViewControllerWithIdentifier:@"MainView"];
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:mainView];
    }
    else if (indexPath.row == Mentions){
        MentionViewController *mentionView = [sb instantiateViewControllerWithIdentifier:@"MentionView"];
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:mentionView];
    }
    else if (indexPath.row == Logout){   //logout
        [User logout];
        return;
    }
    [[AppDelegate globalDelegate] showLeftDrawer:self animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
