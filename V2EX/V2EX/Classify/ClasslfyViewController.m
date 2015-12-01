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
@interface ClasslfyViewController ()
@property(nonatomic,strong)NSMutableArray *classilyArray;
@property(nonatomic,strong)NSMutableDictionary *classilyDict;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation ClasslfyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"类别";
    
    self.itemArray = [NSMutableArray array];
    self.listTableView.frame = CGRectMake(0, 108, self.view.width, self.view.height - 152);
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
    
//    [self listTableView];
    [self.listTableView registerNib:[UINib nibWithNibName:@"NewestTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewestCell"];
//    self.listTableView.estimatedRowHeight = 80;
    self.listTableView.rowHeight = 90;
    [self.view addSubview:self.listTableView];
//    [self.listTableView removeFromSuperview];
    [self loadDataFromWeb];
    // Do any additional setup after loading the view.
}

-(void)loadDataFromWeb{
    [[LWHTTPManager shareManager]GetClassilyDataWith:V2ClassilyTypeJobs success:^(id data) {
        if (data) {
            self.itemArray = data;
            [self.listTableView reloadData];
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

@end
