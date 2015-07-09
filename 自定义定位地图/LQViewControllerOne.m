//
//  LQViewControllerOne.m
//  自定义定位地图
//
//  Created by admin on 15/7/9.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQViewControllerOne.h"

@interface LQViewControllerOne ()

@end

@implementation LQViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
