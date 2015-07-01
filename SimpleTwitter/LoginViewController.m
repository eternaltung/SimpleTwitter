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

@interface LoginViewController ()
@property (strong, nonatomic) User *user;

- (IBAction)LoginTap:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)LoginTap:(UIButton *)sender {
    [[TwitterClient shareInstance] loginCompleted:^(User *user, NSError *error) {
        if (user != nil) {  //login success
            self.user = user;
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self presentViewController:[sb instantiateViewControllerWithIdentifier:@"MainView"] animated:YES completion:nil];
        }
        else{   //error
            
        }
    }];
}
@end
