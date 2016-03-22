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
#import "LWCatergoryViewLayout.h"
#import "LWCatergoryViewCell.h"
#import "LWCatergoryViewCellModel.h"


static NSString *ClasslfyCellSection1 = @"ClasslfyCellSection1";
static NSString *ClasslfyCellSection2 = @"ClasslfyCellSection2";
static NSString *LWCatergoryViewCellID = @"LWCatergoryViewCell";
@interface ClasslfyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *classilyArray;
@property(nonatomic,strong)NSMutableDictionary *classilyDict;
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView  *categoryView;
@property (strong, nonatomic) NSIndexPath  *selectIndexPath;
@property(nonatomic,strong)NSMutableArray *modelArray;

@end

@implementation ClasslfyViewController

-(NSIndexPath *)selectIndexPath{
    if (_selectIndexPath == nil) {
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectIndexPath;
}

-(UICollectionView *)categoryView{
    if (_categoryView == nil) {
        LWCatergoryViewLayout *flowLayout = [[LWCatergoryViewLayout alloc]init];
        flowLayout.titles = self.classilyArray;
        _categoryView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 44) collectionViewLayout:flowLayout];
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
        _categoryView.backgroundColor = [UIColor grayColor];
        _categoryView.showsHorizontalScrollIndicator = NO;
        [_categoryView registerClass:[LWCatergoryViewCell class] forCellWithReuseIdentifier:LWCatergoryViewCellID];
        [self.view addSubview:_categoryView];
    }
    return _categoryView;
}


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
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ClasslfyCellSection1];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ClasslfyCellSection2];
        
        [_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
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
    [self LW_initModelArrayWithArray:self.classilyArray];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
//    self.listTableView.estimatedRowHeight = 80;
    
    
//    [self.view addSubview:self.tableView];
    [self categoryView];
    [self collectionView];
    [self setTableVIeWithTag];
    [self loadDataFromWeb];
    
    
   
}
-(void)LW_initModelArrayWithArray:(NSArray*)array{
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    for (int i = 0 ; i < array.count ; i++) {
        LWCatergoryViewCellModel *model = [[LWCatergoryViewCellModel alloc]init];
        model.title = array[i];
        model.index = i;
        [_modelArray addObject:model];
    }
}

-(void)updateModelArrayWitnIndex:(NSInteger)index{
    for (LWCatergoryViewCellModel *model in self.modelArray) {
        model.index = index;
    }
}

-(UIView*)setTableVIeWithTag{

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
    cell.dateLabel.text = model.createTime;
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
    if (collectionView == self.categoryView) {
        return 1;
    }
    else{
        return 1;
    }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.categoryView) {
        return self.classilyArray.count;
    }
    else{
        return self.classilyArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.categoryView) {
        LWCatergoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LWCatergoryViewCellID forIndexPath:indexPath];
        
        cell.data = self.modelArray[indexPath.item];
        [cell updateCellWithIndexPath:self.selectIndexPath];
        return cell;
    }
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectIndexPath.row) {
        return;
    }
    
    self.selectIndexPath = indexPath;
//    [self updateModelArrayWitnIndex:indexPath.row];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self updateCells];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!self.collectionView.isDragging && !self.collectionView.isDecelerating) {
        return;
    }
    
    CGFloat ratio = self.collectionView.contentOffset.x / self.collectionView.width;
    if (ratio == (int)ratio) {
        self.selectIndexPath = [NSIndexPath indexPathForRow:(int)ratio inSection:0];
        [self.categoryView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        NSLog(@"self.select ---- %f",ratio);
        [self updateCells];
    }
}

-(void)updateCells{
    for (LWCatergoryViewCell *cell in self.categoryView.visibleCells) {
        [cell updateCellWithIndexPath:self.selectIndexPath];
    }
}

@end
