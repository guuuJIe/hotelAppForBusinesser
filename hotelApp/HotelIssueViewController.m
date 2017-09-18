//
//  HotelIssueViewController.m
//  hotelApp
//
//  Created by mac on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelIssueViewController.h"
#import "HotelModel.h"
#import <UIImageView+WebCache.h>

@interface HotelIssueViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImgView;
@property (weak, nonatomic) IBOutlet UITextField *hotelNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *isEarlyTextField;
@property (weak, nonatomic) IBOutlet UITextField *bedTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *hotelAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPriceTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIActivityIndicatorView *avi;//蒙层
@property (strong, nonatomic) HotelModel *issueModel;

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSMutableArray *pickerArr;
@property (strong, nonatomic) UIView *fullView;//全屏蒙层

@end

@implementation HotelIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //给scrollView签协议
    _scrollView.delegate = self;
    //初始化一个单击手势，设置响应的事件为touchScrollView
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [_scrollView addGestureRecognizer:recognizer];
    
    //给pickerview签协议
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerArr = [NSMutableArray new];

    //设置PickerView的背景颜色
    _pickerView.backgroundColor = UIColorFromRGB(230, 230, 230);
    //设置view的边框宽度
    _headerView.layer.borderWidth = 1.0;
    //设置view的边框颜色
    _headerView.layer.borderColor = UIColorFromRGB(50, 130, 255).CGColor;
    
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

//当文本框开始编辑的时候调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = _scrollView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 258 + 75);
    if (offset <= 0) {
        [UIScrollView animateWithDuration:0.3 animations:^{
            CGRect frame = _scrollView.frame;
            frame.origin.y = offset;
            _scrollView.frame = frame;
        }];
    }
    return YES;
}

//当文本框结束编辑的时候调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIScrollView animateWithDuration:0.3 animations:^{
        CGRect frame = _scrollView.frame;
        frame.origin.y = 0.0;
        _scrollView.frame = frame;
    }];
    return YES;
}

//当文本框已经开始编辑的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //设置全屏蒙层的位置大小
    _fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    //设置全屏蒙层的背景颜色
    _fullView.backgroundColor = UIColorFromRGBA(135, 135, 135, 0.3);
    [_scrollView addSubview:_fullView];
}

//当文本框已经结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_fullView removeFromSuperview];
    _fullView = nil;
}


//设置导航样式
- (void)setNavigationItem {
    //设置导航栏标题
    self.navigationItem.title = @"酒店发布";
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(50, 130, 255)];
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(issueAction)];
    self.navigationItem.rightBarButtonItem = right;
    //设置导航栏按钮的风格颜色
    right.tintColor = [UIColor whiteColor];
    
}


//自定义的发布按钮事件
- (void)issueAction {
    if ([_chooseBtn.titleLabel.text isEqualToString:@"请选择酒店"]) {
        [Utilities popUpAlertViewWithMsg:@"请选择酒店" andTitle:@"提示" onView:self];
        return;
    }
    if (_hotelNameTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写房间名称" andTitle:@"提示" onView:self];
        return;
    }
    
    if (_isEarlyTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写是否含早" andTitle:@"提示" onView:self];
        return;
    }
    
    if (_bedTypeTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写床型" andTitle:@"提示" onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];//不是数字的字符
    if (_hotelAreaTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写房间面积" andTitle:@"提示" onView:self];
        return;
    }
    if ([_hotelAreaTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"请填写有效的房间面积" andTitle:@"提示" onView:self];
        return;
    }
    if (_priceTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:@"提示" onView:self];
        return;
    }
    
    if ([_priceTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"请填写有效的价格" andTitle:@"提示" onView:self];
        return;
    }

    if (_addPriceTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写周末节假日加价" andTitle:@"提示" onView:self];
        return;
    }
    if ([_addPriceTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        [Utilities popUpAlertViewWithMsg:@"请填写有效的价格" andTitle:@"提示" onView:self];
        return;
    }

    //调用酒店发布网络接口
    [self hotelIssueRequest];
}


#pragma mark - request 网络请求

//选择酒店接口
-(void)selectHotel{
    //网络请求
    [RequestAPI requestURL:@"/searchHotelName" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情在此处执行
        NSLog(@"选择酒店：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1) {
            //每次请求成功先把数组清空再插入数据
            [_pickerArr removeAllObjects];
            NSArray *content = responseObject[@"content"];
            //遍历content
            for (NSDictionary *dict in content) {
                
                [_pickerArr addObject:dict[@"hotel_name"]];
            }
            //将得到的数据重载(刷新数据)！！！
            [_pickerView reloadAllComponents];
            
            //NSLog(@"_pickerArr:%@",_pickerArr);
        } else {
            [_avi stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }

        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        //失败提示框
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
    
}

//酒店发布接口
- (void)hotelIssueRequest {
    _avi = [Utilities getCoverOnView:self.view];
    //将http请求的字符串转为NSURL
     NSURL *url = [NSURL URLWithString:@"http://img3.imgtn.bdimg.com/it/u=1308521812,278920127&fm=23&gp=0.jpg"];
    //依靠SDWebImage来异步的下载一张远程路径下的图片，并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
    [_hotelImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"room_imgs"]];
    NSString *str =@"http://img3.imgtn.bdimg.com/it/u=1308521812,278920127&fm=23&gp=0.jpg";
    //[NSString stringWithFormat:@"%@", url];
    //参数
    NSDictionary *para = @{@"business_id" : @1,@"hotel_name" : _chooseBtn.titleLabel.text,@"hotel_type" :[NSString stringWithFormat:@"%@,%@,%@,%@",_hotelNameTextField.text,_isEarlyTextField.text,_bedTypeTextField.text,_hotelAreaTextField.text],@"room_imgs":str,@"price":_priceTextField.text};
    //网络请求
    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情在此处执行
        NSLog(@"酒店发布：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1) {
            //[Utilities popUpAlertViewWithMsg:@"恭喜您发布成功！" andTitle:@"提示" onView:self];
            //[self.navigationController popViewControllerAnimated:NO];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您发布成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:NO];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [_avi stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }

        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        //失败提示框
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArr.count;
}

//每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return _pickerArr[row];
}



//取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    _symbolLabel.text = @"▽";
    //设置label的文本颜色
     _symbolLabel.textColor = UIColorFromRGBA(0, 120, 255, 1);
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//确认事件
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    _symbolLabel.text = @"▽";
    //设置label的文本颜色
     _symbolLabel.textColor = UIColorFromRGBA(0, 120, 255, 1);
    //拿到某一列中选中的行号
    NSInteger row = [_pickerView selectedRowInComponent:0];
    //根据上面拿到的行号，找到对应的数据（选中行的标题）
    NSString *title = _pickerArr[row];
    //把拿到的标题显示在按钮上
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//选择酒店按钮事件
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(150, 150, 150, 1) forState:UIControlStateNormal];
    _symbolLabel.text = @"△";
    //设置label的文本颜色
    _symbolLabel.textColor = UIColorFromRGBA(150, 150, 150, 1);
    //显示ToolBar和PickerView
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
    //调用选择酒店接口
    [self selectHotel];
    
}

/*
//点击空白处收回ToolBar和PickerView
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    
}
*/

//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

//单击手势响应事件
- (void)touchScrollView {
    //让scrollView结束编辑状态达到收起键盘的目的
    [_scrollView endEditing:YES];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    _symbolLabel.text = @"▽";
    //设置label的文本颜色
     _symbolLabel.textColor = UIColorFromRGBA(0, 120, 255, 1);
    [_fullView removeFromSuperview];
    _fullView = nil;
}



@end
