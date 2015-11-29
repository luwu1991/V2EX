//
//  LoginViewController.m
//  V2EX
//
//  Created by 吴露 on 15/9/26.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+WJTools.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
    self.name.placeholder = @"用户名";
    self.name.layer.borderColor = [[UIColor clearColor] CGColor];
    self.name.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
    self.password.placeholder = @"密码";
    self.password.layer.borderColor = [[UIColor clearColor] CGColor];
    self.password.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
    
    self.login.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
    
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)setLogin{
    NSString *name = self.name.text;
    NSString *passord = self.password.text;
    if (!name || name.length < 1 || !passord || passord.length < 1) {
        [MBProgressHUD showError:@"请输出用户名或密码"];
    }
    else{
        [self showHud];
        [[LWHTTPManager shareManager] UserLogWithName:name password:passord success:^(NSString *message) {
            [self hideHud];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        } failure:^(NSError *error) {
            LWLog(@"%@",error);
            [self hideHud];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [alert show];
        }];
    }
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

- (IBAction)login:(id)sender {
}
@end
