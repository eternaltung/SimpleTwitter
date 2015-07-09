//
//  LoginViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 6/26/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"
#import "AppDelegate.h"
#import <JVFloatingDrawerViewController.h>
#import "MainViewController.h"
#import "LeftDrawerViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) User *user;

- (IBAction)LoginTap:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)LoginTap:(UIButton *)sender {
    [[TwitterClient shareInstance] loginCompleted:^(User *user, NSError *error) {
        if (user != nil) {  //login success
            self.user = user;
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftDrawerViewController *leftView = [sb instantiateViewControllerWithIdentifier:@"LeftDrawerView"];
            [[[AppDelegate globalDelegate] drawerViewController] setLeftViewController:leftView];
            MainViewController *mainView = [sb instantiateViewControllerWithIdentifier:@"MainView"];
            [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:mainView];
        }
        else{   //error
            
        }
    }];
}
@end
