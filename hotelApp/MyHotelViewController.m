//
//  MyHotelViewController.m
//  hotelApp
//
//  Created by mac on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyHotelViewController.h"
#import "MyHotelTableViewCell.h"

@interface MyHotelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myHotelTableView;
- (IBAction)issueAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //去掉tableview底部多余的线
    _myHotelTableView.tableFooterView = [UIView new];
    
    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //设置其背景图片为返回图片
    //[_issueBtn setBackgroundImage:[UIImage imageNamed:@"check_out"] forState:UIControlStateNormal];
    
    //调用导航栏设置
    [self setNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//设置导航样式
- (void)setNavigationItem {
    //隐藏返回下一个视图导航栏的标题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置导航栏标题
    self.navigationItem.title = @"我的酒店";
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:23],NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(50, 130, 255)];
   
}


////一共多少组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHotelCell" forIndexPath:indexPath];
    
    return cell;
}

//设置每行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
    
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
    [self performSegueWithIdentifier:@"hotelToIssue" sender:self];
}


@end
