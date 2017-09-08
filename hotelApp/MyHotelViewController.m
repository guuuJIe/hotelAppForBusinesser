//
//  MyHotelViewController.m
//  hotelApp
//
//  Created by mac on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyHotelViewController.h"
#import "MyHotelTableViewCell.h"
#import "HotelIssueViewController.h"
#import "HotelModel.h"
#import <UIImageView+WebCache.h>

@interface MyHotelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *issueBtn;
@property (weak, nonatomic) IBOutlet UITableView *myHotelTableView;
- (IBAction)issueAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;//蒙层
@property (strong, nonatomic) NSMutableArray *tableArr;
@property (strong, nonatomic) NSMutableArray *roomInfoArr;
@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) HotelModel *hotelModel;

@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化可变数组，分配内存
    _tableArr = [NSMutableArray new];
    _roomInfoArr = [NSMutableArray new];
    
    //去掉tableview底部多余的线
    _myHotelTableView.tableFooterView = [UIView new];
    
    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [_headerView setBackgroundColor:UIColorFromRGB(80, 145, 255)];
    //设置其背景图片为返回图片
    [_issueBtn setBackgroundImage:[UIImage imageNamed:@"check_out"] forState:UIControlStateNormal];
    
    //调用导航栏设置
    [self setNavigationItem];
    //创建刷新指示器
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10005;
    [_myHotelTableView addSubview:ref];
    
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//设置导航样式
- (void)setNavigationItem {
    //隐藏返回下一个视图导航栏的标题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
   
}


#pragma mark - request 网络请求

- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshPage];
}

//刷新指示器的事件
- (void)refreshPage{
    [self myHotelRequest];
}

//查看自己发布的酒店接口
- (void)myHotelRequest {
    //参数
    NSDictionary *para = @{@"business_id" : @1};
    //网络请求
    [RequestAPI requestURL:@"/findHotelBySelf" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTableView viewWithTag:10005];
        [ref endRefreshing];
        //成功以后要做的事情在此处执行
        NSLog(@"我的酒店：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            //每次请求成功先把数组清空再插入数据
            [_tableArr removeAllObjects];
            //遍历content
            for (NSDictionary *dict in content) {
                NSString *roomInfoJSONStr = dict[@"hotel_type"];
                id hotelType = [roomInfoJSONStr JSONCol];
                //NSLog(@"hotelType%@",hotelType);
                [_roomInfoArr addObject:hotelType];
                
                HotelModel *hotelModel = [[HotelModel alloc] initWithDict:dict];
                [_tableArr addObject:hotelModel];
            }
           
            //重载数据
            [_myHotelTableView reloadData];
        } else {
            [_avi stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTableView viewWithTag:10005];
        [ref endRefreshing];
        //失败提示框
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}

//删除酒店接口
- (void)deleteHotelRequest {
    //参数
    NSDictionary *para = @{@"id" : @1};
    //网络请求
    [RequestAPI requestURL:@"/deleteHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTableView viewWithTag:10005];
        [ref endRefreshing];
        //成功以后要做的事情在此处执行
        NSLog(@"删除酒店：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1) {
            
        } else {
            [_avi stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTableView viewWithTag:10005];
        [ref endRefreshing];
        //失败提示框
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];

}


//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}


//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //图片显示
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    MyHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHotelCell" forIndexPath:indexPath];
    HotelModel *hotelModel = _tableArr[indexPath.row];
    cell.hotelNameLabel.text = hotelModel.hotelName;
    cell.priceLabel.text = [NSString stringWithFormat:@"价格¥:%ld",(long)hotelModel.price];
    NSURL *url = [NSURL URLWithString:hotelModel.hotelImgs];
    [cell.hotelImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hotel_img"]];
  
    if (_arr.count == 4) {
        //遍历数组
        for (_arr in _roomInfoArr) {
            cell.describeLabel.text = [NSString stringWithFormat:@"描述:%@",_arr[1]];
            cell.bedTypeLabel.text = _arr[2];
            //截取字符串
            NSString *str = [_arr[3] substringToIndex:2];
            cell.areaLabel.text = [NSString stringWithFormat:@"面积:%@平米",str];
        }

    }
    return cell;
}

//设置每行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
    
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//设置细胞被编辑时执行什么操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断当前的编辑是否属于删除行为
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //判断当前的tableView是否myHotelTableView
        if (tableView == _myHotelTableView) {
            //创建弹窗
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该条发布？" preferredStyle:UIAlertControllerStyleAlert];
            //创建取消按钮
            UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //刷新表格，重载数据
                [_myHotelTableView reloadData];
            }];
            //创建确定按钮
            UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                //调用删除酒店网络接口
                [self deleteHotelRequest];
                [_tableArr removeObjectAtIndex:indexPath.row];
                [_myHotelTableView beginUpdates];
                //删除界面上的细胞
                [_myHotelTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [_myHotelTableView endUpdates];
                //刷新表格，重载数据
                //[_delectTableView reloadData];
                [self myHotelRequest];
            }];
            [alert addAction:actionA];
            [alert addAction:actionB];
            //在当前页面显示弹框
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
}

//把英文删除变成中文删除
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (IBAction)issueAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //[self performSegueWithIdentifier:@"hotelToIssue" sender:self];
    HotelIssueViewController *issueNavi = [Utilities getStoryboardInstance:@"HotelIssue" byIdentity:@"HotelIssue"];
    [self.navigationController pushViewController:issueNavi animated:NO];

}


@end
