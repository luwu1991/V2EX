//
//  CollectViewController.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "CollectViewController.h"

static const CGFloat SCROLLHEIGHT = 44;
static const CGFloat BTNWIDTH = 60;

@interface CollectViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *meunView;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"收藏";
    
    self.itemArray = @[@"技术",@"创意",@"好玩",@"Apple",@"酷工作",@"交易",@"城市",@"问与答",@"最热",@"全部",@"R2"];
    
    UIScrollView *meunView = [[UIScrollView alloc]init];
    meunView.frame = CGRectMake(0, 64, self.view.width, SCROLLHEIGHT);
    meunView.contentSize = CGSizeMake(BTNWIDTH*self.itemArray.count, SCROLLHEIGHT);
    meunView.bounces = NO;
    meunView.showsHorizontalScrollIndicator = NO;
    meunView.pagingEnabled = NO;
    //    meunTableView.contentOffset = CGPointMake(0, 0);
    meunView.backgroundColor = [UIColor blueColor];

    self.meunView = meunView;
    [self.view addSubview:meunView];
    [self setMeuns];
    // Do any additional setup after loading the view.
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.view pointInside:point withEvent:event] ? self.meunView : nil;
}

-(void)setMeuns{
    CGFloat btnY = 0;
    CGFloat btnW = BTNWIDTH;
    CGFloat btnH = SCROLLHEIGHT;
    for (int i = 0;i < self.itemArray.count ; i++) {
        NSString *title = self.itemArray[i];
        UIButton *btn = [[UIButton alloc]init];
        CGFloat btnX = i*BTNWIDTH;

        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.backgroundColor = [UIColor whiteColor];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.meunView addSubview:btn];
    }
}


@end
