//
//  HotelIssueViewController.m
//  hotelApp
//
//  Created by mac on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelIssueViewController.h"
#import "HotelModel.h"

@interface HotelIssueViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
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

@end

@implementation HotelIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

//当文本框开始结束编辑的时候调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
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
    [self hotelIssueRequest];
}


#pragma mark - request 网络请求

- (void)hotelIssueRequest {
    _avi = [Utilities getCoverOnView:self.view];
    //参数
    NSDictionary *para = @{@"business_id" : @(_issueModel.businessId),@"hotel_name" : _chooseBtn.titleLabel.text,@"hotel_type" :[NSString stringWithFormat:@"%@%@%@%@",_hotelNameTextField.text,_isEarlyTextField.text,_bedTypeTextField.text,_hotelAreaTextField.text]};
    //网络请求
    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情在此处执行
        NSLog(@"酒店发布：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_avi stopAnimating];
        
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




//取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//确认事件
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//选择酒店按钮事件
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //显示ToolBar和PickerView
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
}

//点击空白处收回ToolBar和PickerView
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    
}

//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}


@end
