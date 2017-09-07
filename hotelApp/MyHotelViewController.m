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

@interface MyHotelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *issueBtn;
@property (weak, nonatomic) IBOutlet UITableView *myHotelTableView;
- (IBAction)issueAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;//蒙层
@property (strong, nonatomic) NSMutableArray *tableArr;
@property (strong, nonatomic) NSMutableArray *roomInfoArr;
//@property (strong, nonatomic) HotelModel *hotelModel;

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
            //遍历content
            for (NSDictionary *dict in content) {
                NSString *roomInfoJSONStr = dict[@"hotel_type"];
                id hotelType = [roomInfoJSONStr JSONCol];
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
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
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
    MyHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHotelCell" forIndexPath:indexPath];
    HotelModel *hotelModel = _tableArr[indexPath.row];
    cell.hotelNameLabel.text = hotelModel.hotelName;
    
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
