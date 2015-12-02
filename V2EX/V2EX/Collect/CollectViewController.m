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
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,assign)UIButton *itemBtn;

@property(nonatomic,strong)UIView *firstView;
@property(nonnull,strong)UIView *middleView;
@property(nonatomic,strong)UIView *lastView;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"收藏";
    self.view.backgroundColor = [UIColor redColor];
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
    
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.frame = CGRectMake(0, 108, self.view.width, self.view.height - 108 - 44);
    self.mainScrollView.contentSize = CGSizeMake(self.view.width * 3, self.view.height - 108 - 44);
    self.mainScrollView.contentOffset = CGPointMake(self.view.width, 0);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    self.firstView = [[UIView alloc]init];
    self.firstView.frame = CGRectMake(0, 0, self.view.width, self.mainScrollView.height);
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.firstView];
    
    self.middleView = [[UIView alloc]init];
    self.middleView.frame = CGRectMake(self.view.width, 0, self.view.width, self.mainScrollView.height);
    self.middleView.backgroundColor = [UIColor blueColor];
    [self.mainScrollView addSubview:self.middleView];
    
    self.lastView = [[UIView alloc]init];
    self.lastView.frame = CGRectMake(self.view.width * 2, 0, self.view.width, self.mainScrollView.height);
    self.lastView.backgroundColor = [UIColor blackColor];
    [self.mainScrollView addSubview:self.lastView];
    // Do any additional setup after loading the view.
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    ;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x != self.view.width) {
        [scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:NO];
    }
    
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
