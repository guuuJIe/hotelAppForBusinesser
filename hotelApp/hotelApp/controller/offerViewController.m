//
//  offerViewController.m
//  hotelApp
//
//  Created by admin2017 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "offerViewController.h"
#import "offerTableViewCell.h"
#import "lookOfferModel.h"
@interface offerViewController ()<UITableViewDelegate,UITableViewDataSource>{
     NSTimeInterval followUpTime;
    NSInteger PageNum;
    NSInteger  flag;
    NSTimeInterval datetime;
}
@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UIButton *ChooseOriginBtn;
@property (weak, nonatomic) IBOutlet UIButton *destinationBtn;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;

@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *airlinesField;
@property (weak, nonatomic) IBOutlet UITextField *flightField;
@property (weak, nonatomic) IBOutlet UITextField *spaceField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
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
@property (strong,nonatomic)UIView *mark;
@property (strong,nonatomic)NSMutableArray *lookOfferArr;
@property (strong,nonatomic)lookOfferModel *lookModel;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (strong,nonatomic)NSMutableArray *deleteOfferArr;
@property (strong,nonatomic)NSMutableArray *airlinesArr;
@end

@implementation offerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self keyboard];
    _lookOfferArr = [NSMutableArray new];
    _deleteOfferArr = [NSMutableArray new];
    _airlinesArr = [NSMutableArray new];
    [self setRefreshControl];
    [self lookOfferRequest];
    //[self airlinesRequest];

    
 
    // Do any additional setup after loading the view.
    //去掉tableview底部多余的线
    _offerTableView.tableFooterView = [UIView new];
    _datePicker.backgroundColor = UIColorFromRGB(235, 235, 241);
    _datePicker.minimumDate = [NSDate date];
    _mark = [UIView new];
    _mark.frame = CGRectMake(0, self.offerView.frame.size.height + self.navigationController.navigationBar.frame.size.height  + 30, self.offerTableView.frame.size.width,self.offerView.frame.size.height);
    _mark.backgroundColor = UIColorFromRGBA(104, 104, 104, 0.4);
    [[UIApplication sharedApplication].keyWindow addSubview:_mark];
    _mark.hidden  = YES;
    //接收一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"ResetHome" object:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _mark = nil;
}

//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)keyboard{
    //监听键盘将要打开这一操作,打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘将要隐藏这一操作,打开后执行keyboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘出现
- (void)keyboardWillShow: (NSNotification *)notification {
    _mark.hidden = NO;
   
}
//键盘隐藏
- (void)keyboardWillHide: (NSNotification *)notification {
    _mark.hidden = YES;
    
}
//按ruturn按钮收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //结束第一响应者
    [textField resignFirstResponder];
    return YES;
}

//创建刷新指示器的方法
- (void)setRefreshControl{
    //刷新指示器
    UIRefreshControl *offerRef = [UIRefreshControl new];
    [offerRef addTarget:self action:@selector(offerRef) forControlEvents:UIControlEventValueChanged];
    offerRef.tag = 10008;
    [_offerTableView addSubview:offerRef];
    [_offerTableView reloadData];
}
//报价列表下拉刷新事件
- (void)offerRef{
   PageNum = 1;
    [self lookOfferRequest];
    
}
//第一次进行网络请求的时候需要盖上朦层，所以我们把第一次网络请求和下拉刷新分开
-(void)acquireInitalizeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self lookOfferRequest];
}


//报价网络请求
- (void)offerRequest{
    NSInteger weight = [[NSString stringWithFormat:@"%@",_weightField.text] integerValue];
    NSInteger price = [[NSString stringWithFormat:@"%@",_priceField.text] integerValue];
    NSDictionary *para =@{@"business_id":@2,@"aviation_demand_id":@1,@"final_price":@(price),@"weight":@(weight),@"aviation_company":_airlinesField.text,@"aviation_cabin":_spaceField.text,@"in_time_str":_DateOfDepartureBtn.titleLabel.text,@"out_time_str":_DateOfArrivalBtn.titleLabel.text,@"departure":_ChooseOriginBtn.titleLabel.text,@"destination":_destinationBtn.titleLabel.text,@"flight_no":_flightField.text};
    [RequestAPI requestURL:@"/offer_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
            
    
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}
//查看报价网络请求
- (void)lookOfferRequest{
    NSDictionary *para =@{@"Id" : @2};
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10008];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
             NSDictionary *content = responseObject[@"content"];
            //下拉刷新的时候不仅要把页码变为1，还有将数组中原来数据清空
          if(PageNum == 1){
                [_lookOfferArr removeAllObjects];
           }
            for(NSDictionary *dict in content) {
                _lookModel = [[lookOfferModel alloc]initWithDict:dict];
                [_lookOfferArr addObject:_lookModel];
            }
            [_offerTableView reloadData];

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
//删除报价网络请求
- (void)deleteOfferRequest{
   // NSInteger ID = [[NSString stringWithFormat:@"%@",_lookModel.id] integerValue];
    NSDictionary *para =@{@"Id": _lookModel.id};
    [RequestAPI requestURL:@"/deleteOfferById_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"删除报价: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}
//航空公司网络请求
//- (void)airlinesRequest{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://apis.haoservice.com/efficient/flightorder/companycode?&key=5c301176d6b84bd3b3813587f913c936"]
//        cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                        NSLog(@"哈哈%@", error);
//        } else {
//

//            id jsonObject = [data JSONCol];
//            NSLog(@"%@", jsonObject);
//            NSDictionary *result  = jsonObject[@"result"];
//            for(NSDictionary *dict in result){
//                [_airlinesArr addObject:dict];
//                NSLog(@"数组%@",_airlinesArr);
//            }
//            }
//    }];
//    [dataTask resume];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    }

//有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lookOfferArr.count;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"forIndexPath:indexPath];
    lookOfferModel *lookModel = _lookOfferArr[indexPath.row];
    _cell.originLabel.text = _lookModel.departure;
    _cell.endLabel.text = _lookModel.destination;
    _cell.companyLabel.text = [NSString stringWithFormat:@"%@%@",lookModel.cabin,lookModel.company];
      _cell.priceLabel.text = _lookModel.price;
     NSString *starTimeStr = [Utilities dateStrFromCstampTime:(long)_lookModel.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:(long)_lookModel.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];

    _cell.timeLabel.text =[NSString stringWithFormat:@"%@——%@",starTimeStr,endTimeStr];
    _cell.luggageLabel.text = _lookModel.weight;
        return _cell;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消细胞的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//让细胞在可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确认要删除该条报价么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:
        UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteOfferRequest];
            // 删除模型
            [_lookOfferArr removeObjectAtIndex:indexPath.row];
            
            // 刷新
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
          
            [self lookOfferRequest];
            
        }];
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionA];
        [alert addAction:actionB];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}
//更改左滑删除文字为“删除”
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
      [self.view endEditing:YES];
    _layerView.hidden = NO;
  
    
    flag = 1;
}

- (IBAction)DateOfArrivalAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [self.view endEditing:YES];
    _layerView.hidden = NO;
   
      flag = 0;

}

- (IBAction)determineAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self offerRequest];
    
}

- (IBAction)cancelItm:(UIBarButtonItem *)sender {
    _layerView.hidden = YES;
   }

- (IBAction)ConfirmItm:(UIBarButtonItem *)sender {
     _layerView.hidden = YES;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *thDate = [formatter stringFromDate:date];
    followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];
    if(flag == 1){
        [_DateOfDepartureBtn setTitle:thDate forState:UIControlStateNormal];
        datetime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];

    }else if(followUpTime <= datetime){
         [Utilities popUpAlertViewWithMsg:@"请正确选择日期" andTitle:@"提示" onView:self];
    }
[_DateOfArrivalBtn setTitle:thDate forState:UIControlStateNormal];
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


- (IBAction)priceBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
