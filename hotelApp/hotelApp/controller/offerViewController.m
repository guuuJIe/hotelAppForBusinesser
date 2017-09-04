//
//  offerViewController.m
//  hotelApp
//
//  Created by admin2017 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "offerViewController.h"
#import "offerTableViewCell.h"
@interface offerViewController ()<UITableViewDelegate,UITableViewDataSource>{
     NSTimeInterval followUpTime;
    NSInteger PageNum;
    NSInteger  flag;
}
@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UIButton *ChooseOriginBtn;
@property (weak, nonatomic) IBOutlet UIButton *destinationBtn;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UILabel *airlinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *luggageLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *DateOfDepartureBtn;
@property (weak, nonatomic) IBOutlet UIButton *DateOfArrivalBtn;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (strong,nonatomic) NSString *city;

- (IBAction)originAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)destinationAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DateOfDepartureAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DateOfArrivalAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)determineAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelItm:(UIBarButtonItem *)sender;
- (IBAction)ConfirmItm:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ConfirmItm;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *ToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItm;
@property (strong,nonatomic)offerTableViewCell *cell;
@property (strong,nonatomic)UIActivityIndicatorView *avi;

@end

@implementation offerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    //去掉tableview底部多余的线
    _offerTableView.tableFooterView = [UIView new];
    _datePicker.backgroundColor = UIColorFromRGB(235, 235, 241);
    _datePicker.minimumDate = [NSDate date];
    
    //接收一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"ResetHome" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建刷新指示器的方法
- (void)setRefreshControl{
    //已获取列表的刷新指示器
    UIRefreshControl *offerRef = [UIRefreshControl new];
    [offerRef addTarget:self action:@selector(offerRef) forControlEvents:UIControlEventValueChanged];
    offerRef.tag = 10008;
    [_offerTableView addSubview:offerRef];
}
//报价列表下拉刷新事件
- (void)offerRef{
   PageNum = 1;
    
}

- (void) naviConfig{
    
    //设置导航条的风格颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23,115,232)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
}
-(void)leftButtonAction:(UIButton *)sender{
    //跳转回原来页
    [self.navigationController popViewControllerAnimated:YES];
    
}

//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
//报价网络请求
- (void)offerRequest{
    NSDictionary *para =@{@"Id":@1};
    [RequestAPI requestURL:@"" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10008];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10008];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

//有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
        return _cell;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消细胞的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)originAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [self performSegueWithIdentifier:@"offerToCity" sender:self];
}

- (IBAction)destinationAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    [self performSegueWithIdentifier:@"offerToCity" sender:self];
}

- (IBAction)DateOfDepartureAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePicker.hidden = NO;
    _ToolBar.hidden = NO;
    flag = 1;
}

- (IBAction)DateOfArrivalAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePicker.hidden = NO;
    _ToolBar.hidden = NO;
    flag = 0;

}

- (IBAction)determineAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)cancelItm:(UIBarButtonItem *)sender {
    _ToolBar.hidden = YES;
    _datePicker.hidden = YES;
    
}

- (IBAction)ConfirmItm:(UIBarButtonItem *)sender {
    
    _ToolBar.hidden = YES;
    _datePicker.hidden = YES;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *thDate = [formatter stringFromDate:date];
    followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];
    if(flag == 1){
        [_DateOfDepartureBtn setTitle:thDate forState:UIControlStateNormal];
    }else{
        [_DateOfArrivalBtn setTitle:thDate forState:UIControlStateNormal];
    }

}


//接收通知执行的方法，将拿到的城市给相应的按钮
-(void)changeCity:(NSNotification *)name{
    NSString *citystr = name.object;
     if (flag == 1) {
        [_ChooseOriginBtn setTitle:citystr forState:UIControlStateNormal];
        _city = citystr;
    }else if([_city isEqualToString:citystr]){
        
         [Utilities popUpAlertViewWithMsg:@"请正确选择城市" andTitle:nil onView:self];
       
    }else{
     [_destinationBtn setTitle:citystr forState:UIControlStateNormal];
}
}


@end
