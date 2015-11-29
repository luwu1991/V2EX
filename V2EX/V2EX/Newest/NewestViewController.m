//
//  NewestViewController.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "NewestViewController.h"
#import "LWHTTPManager.h"
#import "LWNewestDataModel.h"
#import "YYModel.h"
#import "NewestTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewestDateilViewController.h"
#import <MJRefresh.h>
@interface NewestViewController ()
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新";
    self.itemArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
//    [self.tableView registerClass:[NewestTableViewCell class] forCellReuseIdentifier:@"NewestCell"];
    [self.view addSubview:self.tableView];
//    [self loadFromWeb];
    [self refreshView];
    // Do any additional setup after loading the view.
}
-(void)refreshView{
    WeakSelf;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadFromWeb];
    }];
    self.tableView.header.hidden = NO;
    [self.tableView.header beginRefreshing];
}

-(void)endRefreshView{
    [self.tableView.header endRefreshing];
}
-(void)loadFromWeb{
    [[LWHTTPManager shareManager] NewestInfoWith:@"api/topics/latest.json" success:^(NSArray *data) {
       
        [self endRefreshView];
        [self.itemArray removeAllObjects];
        NSLog(@"%@",data);
        NSArray *array = data;
        for (id json in array) {
            LWNewestDataModel *model = [LWNewestDataModel yy_modelWithJSON:json ];
            [self.itemArray addObject:model];
        }
        NSLog(@"%ld",[self .itemArray count]);
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
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
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[model.member.avatar_mini substringFromIndex:2]]];
    [cell.printImage sd_setImageWithURL:imageUrl];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LWNewestDataModel *model = self.itemArray[indexPath.row];
    NewestDateilViewController *next = [[NewestDateilViewController alloc]init];
    next.theme = model;
    next.title = model.title;
    [self.navigationController pushViewController:next animated:YES];
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
