//
//  LoginViewController.h
//  V2EX
//
//  Created by 吴露 on 15/9/26.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *logView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)setLogin;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end
