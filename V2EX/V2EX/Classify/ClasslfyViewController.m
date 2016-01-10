//
//  ClasslfyViewController.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "ClasslfyViewController.h"
#import "LWNewestDataModel.h"
#import "LWHTTPManager.h"
#import "YYModel.h"
#import "NewestTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewestDateilViewController.h"

static NSString *ClasslfyCellSection1 = @"ClasslfyCellSection1";
static NSString *ClasslfyCellSection2 = @"ClasslfyCellSection2";
@interface ClasslfyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *classilyArray;
@property(nonatomic,strong)NSMutableDictionary *classilyDict;
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation ClasslfyViewController

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height - 44 - 64 - 49);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44+64, self.view.width, flowLayout.itemSize.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor redColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ClasslfyCellSection1];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ClasslfyCellSection2];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"类别";
    
    self.itemArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = false;
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
//    self.tableView.frame = CGRectMake(0,44+64, self.view.width, self.view.height - 44 - 64 - 49);
    self.classilyArray = [NSMutableArray arrayWithArray:@[@"技术",@"创意",@"好玩",@"Apple",@"酷工作",@"交易",@"城市",@"问与答",@"最热",@"全部",@"R2"]];
    self.classilyDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         @"tech",@"技术",
                         @"creative",@"创意",
                         @"play",@"好玩",
                         @"apple",@"Apple",
                         @"jobs",@"酷工作",
                         @"deals",@"交易",
                         @"city",@"城市",
                         @"qna",@"问与答",
                         @"hot",@"最热",
                         @"all",@"全部",
                         @"r2",@"R2",nil];
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
//    self.listTableView.estimatedRowHeight = 80;
    
    
//    [self.view addSubview:self.tableView];

    [self collectionView];
    [self setTableVIeWithTag];
    [self loadDataFromWeb];
   
}

-(UIView*)setTableVIeWithTag{
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
//    self.tableView.frame = CGRectMake(0,0, self.view.width, self.collectionView.height);
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
//    //    self.listTableView.estimatedRowHeight = 80;
//    self.tableView.rowHeight = 90;
//    return self.tableView;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    tableView.frame = CGRectMake(0,0, self.view.width, self.collectionView.height);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
    //    self.listTableView.estimatedRowHeight = 80;
    tableView.rowHeight = 90;
    return tableView;
}

-(void)loadDataFromWeb{
    [[LWHTTPManager shareManager]GetClassilyDataWith:V2ClassilyTypeJobs success:^(id data) {
        if (data) {
            self.itemArray = data;
            [self.collectionView reloadData];
        }
        else{
            [self showHint:@"没有数据"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [self showHint:error.description];
    }];
}
#pragma mark --UITableView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewestCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LWNewestDataModel *model = self.itemArray[indexPath.row];
    cell.titleLabel.text = model.title;
    NSDate *nowDate = [NSDate date];
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:[nowDate timeIntervalSince1970]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)model.created];
    
    NSTimeInterval time = [now timeIntervalSinceDate:date];
    if (time < 60) {
        cell.dateLabel.text = @"刚刚";
    }
    else if (time > 60 && time < 3600){
        cell.dateLabel.text = [NSString stringWithFormat:@"%d分钟前",(int)time/60];
    }
    else if (time > 3600 && time < 86400)
    {
        cell.dateLabel.text = [NSString stringWithFormat:@"%d小时前",(int)time/3600];
    }
    else{
        cell.dateLabel.text = [NSString stringWithFormat:@"%d天前",(int)time/86400];
    }
    
    cell.classifyLabel.text = model.node.title;
    [cell.classifyLabel sizeToFit];
    cell.authorLabel.text = model.member.username;
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[model.member.avatar_normal substringFromIndex:7]]];
    [cell.printImage sd_setImageWithURL:imageUrl];
    [cell setNeedsUpdateConstraints];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LWNewestDataModel *model = self.itemArray[indexPath.row];
    NewestDateilViewController *next = [[NewestDateilViewController alloc]init];
    next.theme = model;
    next.title = model.title;
    [self.navigationController pushViewController:next animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClasslfyCellSection1 forIndexPath:indexPath];
        NSArray *array =cell.contentView.subviews;
        for (UIView *sunView in array) {
            [sunView removeFromSuperview];
        }
        [cell.contentView addSubview:[self setTableVIeWithTag]];
        
        NSLog(@"%ld",indexPath.row);
        return cell;
    }
    else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClasslfyCellSection2 forIndexPath:indexPath];
        NSArray *array =cell.contentView.subviews;
        for (UIView *sunView in array) {
            [sunView removeFromSuperview];
        }
        [cell.contentView addSubview:[self setTableVIeWithTag]];
        
        NSLog(@"%ld",indexPath.row);
        return cell;
    }
}

@end
