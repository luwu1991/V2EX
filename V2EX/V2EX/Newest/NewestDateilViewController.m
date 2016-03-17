//
//  NewestDateilViewController.m
//  V2EX
//
//  Created by 吴露 on 15/11/19.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "NewestDateilViewController.h"
#import "LWHTTPManager.h"
#import "RepliesModel.h"
#import "YYModel.h"
#import "ThemeTitleCell.h"
#import "ThemeContentCell.h"
#import "ThemeReplyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
@interface NewestDateilViewController ()
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger page_size;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation NewestDateilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.listTableView registerNib:[UINib nibWithNibName:@"ThemeTitleCell" bundle:nil] forCellReuseIdentifier:@"ThemeTitleCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ThemeContentCell" bundle:nil] forCellReuseIdentifier:@"ThemeContentCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ThemeReplyCell" bundle:nil] forCellReuseIdentifier:@"ThemeReplyCell"];
    
    self.listTableView.estimatedRowHeight = 80;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
//    self.listTableView
    
    [self.view addSubview:self.listTableView];
    self.page = 0;
    self.page_size = 10;
    self.itemArray = [NSMutableArray array];
//    [self loadDataFromWeb];
//    [self geiThemeDetailData];

    // Do any additional setup after loading the view.
}


-(void)refreshView{
    WeakSelf;
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        StrongSelf;
        strongSelf.page = 0;
        [strongSelf loadDataFromWeb];
    }];
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        StrongSelf;
        strongSelf.page++;
        strongSelf.listTableView.footer.hidden = NO;
        [strongSelf loadDataFromWeb];
        
    }];
    [self.listTableView.header beginRefreshing];
    self.listTableView.header.hidden = NO;
    self.listTableView.footer.hidden = NO;
}
-(void)endFefreshView{
    [self.listTableView.header endRefreshing];
    [self.listTableView.footer endRefreshing];
    self.listTableView.header.hidden = YES;
    self.listTableView.footer.hidden = YES;
}
-(void)geiThemeDetailData{
    [[LWHTTPManager shareManager]GetTopicsWithID:[NSString stringWithFormat:@"%ld",self.theme.memberID] success:^(NSArray *data) {
        if (data) {
            NSLog(@"%@",data.lastObject);
            self.theme = [LWNewestDataModel yy_modelWithJSON:data.lastObject];
            [self refreshView];
        }
    } failure:^(NSError *error) {
        [self showHint:error.description];
    }];
}

//获取主题的回复
-(void)loadDataFromWeb{
    [[LWHTTPManager shareManager] GetRepliesWithID:[NSString stringWithFormat:@"%ld",self.theme.memberID] Page:self.page PageSize:self.page_size success:^(NSArray *data) {
        if (data) {
            [self endFefreshView];
//            self.listTableView.footer.hidden = NO;
            if (self.page == 0) {
                [self.itemArray removeAllObjects];
            }
            for (id sigleReply in data) {
                RepliesModel *model = [RepliesModel yy_modelWithJSON:sigleReply];
                if (model) {
                    [self.itemArray addObject:model];
                }
            }
            [self.listTableView reloadData];
        }
        else{
            [self endFefreshView];
            [self showHint:@"没有更多的数据了"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错了.." message:error.description delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }];
}
#pragma mark -- UITableView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 1;
    }
    
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        ThemeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeTitleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.theme.title;
        cell.authorLabel.text = self.theme.member.username;
        
        NSDate *nowDate = [NSDate date];
        NSDate *now = [NSDate dateWithTimeIntervalSince1970:[nowDate timeIntervalSince1970]];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)self.theme.created];
        
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
        cell.replyLabel.text = [NSString stringWithFormat:@"%ld回复",self.theme.replies];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.theme.member.avatar_mini substringFromIndex:2]]];
        [cell.printImage sd_setImageWithURL:imageUrl];
        [cell layoutIfNeeded];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        ThemeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeContentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = self.theme.content;
        [cell layoutIfNeeded];
        return cell;
    }
    else{
        RepliesModel *model = self.itemArray[indexPath.row];
        ThemeReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeReplyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.authorLabel.text = model.member.username;
        cell.contentLabel.text = model.content;
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[model.member.avatar_mini substringFromIndex:2]]];
        [cell.printImage sd_setImageWithURL:imageUrl];
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
//        [cell layoutIfNeeded];
        return cell;
    }
    return nil;
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
