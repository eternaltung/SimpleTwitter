//
//  MeViewController.m
//  SimpleTwitter
//
//  Created by Shih-Ming Tung on 7/4/15.
//  Copyright (c) 2015 Shih-Ming. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
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

@end
