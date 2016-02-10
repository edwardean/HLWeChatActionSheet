//
//  ViewController.m
//  wechatActionSheet
//
//  Created by lihang on 16/2/10.
//  Copyright © 2016年 herry. All rights reserved.
//

#import "ViewController.h"
#import "HLWeChatActionSheet.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *popFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popFirstButton setTitle:@"Pop1" forState:UIControlStateNormal];
    [popFirstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popFirstButton addTarget:self action:@selector(popFirst:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popFirstButton];
    [popFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
}

- (void)popFirst:(id)sender {
    HLWeChatActionSheet *actionSheet = [[HLWeChatActionSheet alloc] initWithTitle:@"加入黑名单，你将不再收到对方的消息，并且你们互相看不到对方朋友圈的更新"];
    [actionSheet addActionWithType:HLActionSheetActionTypeDestructive title:@"确定" block:^{
        
    }];
    [actionSheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
