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
#import "SKTagView.h"

@interface HotelIssueViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    NSInteger flag;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImgView;
@property (weak, nonatomic) IBOutlet UIButton *roomImgBtn;
- (IBAction)roomImgBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *roomNameBtn;
- (IBAction)roomNameBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *isEarlyBtn;

- (IBAction)switchAction:(UISwitch *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *bedTypeBtn;
- (IBAction)bedTypeBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
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
@property (strong, nonatomic) UIImagePickerController *imagePC;
@property (strong, nonatomic) IBOutlet SKTagView *roomNameTagView;
@property (strong, nonatomic) IBOutlet SKTagView *bedTypeTagView;
@property (strong, nonatomic) NSString *hotelTitle;

@end

@implementation HotelIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    flag = 1;
    _isEarlyBtn.enabled = NO;
    //给scrollView签协议
    _scrollView.delegate = self;
//    //初始化一个单击手势，设置响应的事件为touchScrollView
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
//    [recognizer setNumberOfTapsRequired:1];
//    [recognizer setNumberOfTouchesRequired:1];
//    [_scrollView addGestureRecognizer:recognizer];
    //给scrollView添加手势
    [self addTapGestureRecognizer:_scrollView];
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
    
    //给roomImgBtn按钮添加点击事件
    [_roomImgBtn addTarget:self action:@selector(avatarAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //调用选择房间和床型方法
    [self roomNameType];
    [self bedType];
    
    //发送通知
     [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueRefresh" object:nil];

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


//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //根据UIImagePickerControllerEditedImage这个键去拿到我们选中的已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的背景图片
    [_roomImgBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//当取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //用model的方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickImage:(UIImagePickerControllerSourceType)sourceType {
    NSLog(@"按钮被按了");
    //判断当前选择的图片选择器控制器类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //神奇的nil
        _imagePC = nil;
        //初始化一个图片选择器控制器对象
        _imagePC = [[UIImagePickerController alloc] init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器控制器类型
        _imagePC.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"您当前的设备没有照相功能" : @"您当前的设备无法打开相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)avatarAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"可以开始选取头像了");
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


//当文本框开始编辑的时候调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = _scrollView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 75);
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
    if ([_chooseBtn.titleLabel.text isEqualToString:@"请选择酒店 ▽"]) {
        [Utilities popUpAlertViewWithMsg:@"请选择酒店" andTitle:@"提示" onView:self];
        return;
    }
    if ([_roomNameBtn.titleLabel.text isEqualToString:@"填写房间名称"]) {
        [Utilities popUpAlertViewWithMsg:@"请填写房间名称" andTitle:@"提示" onView:self];
        return;
    }
    if ([_isEarlyBtn.titleLabel.text isEqualToString:@"是否含早"]) {
        [Utilities popUpAlertViewWithMsg:@"请填写是否含早" andTitle:@"提示" onView:self];
        return;
    }
    
    if ([_bedTypeBtn.titleLabel.text isEqualToString:@"填写床型"]) {
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
    NSString *area = _hotelAreaTextField.text;
    if ([area integerValue] < 15 || [area integerValue] > 50) {
        [Utilities popUpAlertViewWithMsg:@"房间面积在15~50之间" andTitle:@"提示" onView:self];
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
    NSString *price = _priceTextField.text;
    if ([price integerValue] < 199 || [price integerValue] > 1099) {
        [Utilities popUpAlertViewWithMsg:@"价格在199~1199之间" andTitle:@"提示" onView:self];
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
    NSString *addPrice = _addPriceTextField.text;
    if ([addPrice integerValue] < 39 || [addPrice integerValue] > 599) {
        [Utilities popUpAlertViewWithMsg:@"周末节假日加价在39~599之间" andTitle:@"提示" onView:self];
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
    NSString *str =[NSString stringWithFormat:@"%@",url];
    //[NSString stringWithFormat:@"%@", url];
    //参数
    NSDictionary *para = @{@"business_id" : @1,@"hotel_name" : _hotelTitle,@"hotel_type" :[NSString stringWithFormat:@"%@,%@,%@,%@",_roomNameBtn.titleLabel.text,_isEarlyBtn.titleLabel.text,_bedTypeBtn.titleLabel.text,_hotelAreaTextField.text],@"price":_priceTextField.text,@"room_imgs":str};
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


#pragma mark - PickerView

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

//每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}


#pragma mark - SKTagView

//设置房间名称类型
- (void)roomNameType {
    _roomNameTagView = [[SKTagView alloc] initWithFrame:CGRectMake(0, _roomNameBtn.frame.origin.y + 35, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    NSArray *roomArr = @[@"经济房",@"标准房",@"豪华房",@"商务房",@"行政房",@"双床房",@"大床房",@"单人房",@"无烟房",@"套房"];
    //内间距
    _roomNameTagView.padding = UIEdgeInsetsMake(10, 50, 10, 50);
    //行间距
    _roomNameTagView.lineSpacing = 20;
    //列间距
    _roomNameTagView.interitemSpacing = 30;
    
    [roomArr enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [SKTag tagWithText:text];
        //设置未选择标题的颜色
        tag.textColor = UNSELECTE_TITLE_COLOR;
        //设置字体的大小
        tag.fontSize = 13;
        //文字上下左右的内边距
        tag.padding = UIEdgeInsetsMake(6, 15, 6, 15);
        //设置背景颜色
        //tag.bgColor = UNSELECTE_BTN_BG;
        //设置边框颜色
        tag.borderColor = UNSELECTE_BORDER_COLOR;
        //设置边框宽度
        tag.borderWidth = 1.f;
        //设置圆角
        tag.cornerRadius = 5.f;
        [_roomNameTagView addTag:tag];
    }];
    
    //选中一个按钮的时候
    __weak SKTagView *weakViews = _roomNameTagView;
    _roomNameTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {
        //判断当前要选中按钮时，有没有已经选中的按钮
        if (preIdx != -1) {
            //通过上次选中按钮的preIdx下标拿到一个按钮的preTag
            SKTag *preTag = [weakViews .tags objectAtIndex:preIdx];
            //更改文字颜色为未选中的状态
            preTag.textColor = UNSELECTE_TITLE_COLOR;
            //preTag.bgColor = UNSELECTE_BTN_BG;
            //设置边框颜色
            preTag.borderColor = UNSELECTE_BORDER_COLOR;
            //将上次选中的按钮从原有的下标preIdx删除
            [weakViews removeTagAtIndex:preIdx];
            //再把更改好状态的按钮插入到上次选中的下标preIdx上
            [weakViews insertTag:preTag atIndex:preIdx];
        }
        SKTag *tag = [weakViews.tags objectAtIndex:index];
        tag.textColor = SELECT_COLOR;
        tag.borderColor = SELECTE_BORDER_COLOR;
        [weakViews removeTagAtIndex:index];
        [weakViews insertTag:tag atIndex:index];
        [_roomNameBtn setTitle:roomArr[index] forState:UIControlStateNormal];
        _roomNameTagView.hidden = YES;
        [_roomNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
   
}

//设置床型
- (void)bedType {
     _bedTypeTagView = [[SKTagView alloc] initWithFrame:CGRectMake(0, _bedTypeBtn.frame.origin.y + 35, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    NSArray *bedArr = @[@"小型床",@"小床",@"小型大床",@"大床",@"超大型床",@"单人床",@"双人床",@"豪华大床"];
    //内间距
    _bedTypeTagView.padding = UIEdgeInsetsMake(10, 50, 10, 50);
    //行间距
    _bedTypeTagView.lineSpacing = 20;
    //列间距
    _bedTypeTagView.interitemSpacing = 30;
    
    [bedArr enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [SKTag tagWithText:text];
        //设置未选择标题的颜色
        tag.textColor = UNSELECTE_TITLE_COLOR;
        //设置字体的大小
        tag.fontSize = 13;
        //文字上下左右的内边距
        tag.padding = UIEdgeInsetsMake(6, 15, 6, 15);
        //设置边框颜色
        tag.borderColor = UNSELECTE_BORDER_COLOR;
        //设置边框宽度
        tag.borderWidth = 1.f;
        //设置圆角
        tag.cornerRadius = 5.f;
        [_bedTypeTagView addTag:tag];
    }];
    
    //选中一个按钮的时候
    __weak SKTagView *weakView = _bedTypeTagView;
    _bedTypeTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {
        //判断当前要选中按钮时，有没有已经选中的按钮
        if (preIdx != -1) {
            //通过上次选中按钮的preIdx下标拿到一个按钮的preTag
            SKTag *preTag = [weakView.tags objectAtIndex:preIdx];
            //更改文字颜色为未选中的状态
            preTag.textColor = UNSELECTE_TITLE_COLOR;
            //preTag.bgColor = UNSELECTE_BTN_BG;
            //设置边框颜色
            preTag.borderColor = UNSELECTE_BORDER_COLOR;
            //将上次选中的按钮从原有的下标preIdx删除
            [weakView removeTagAtIndex:preIdx];
            //再把更改好状态的按钮插入到上次选中的下标preIdx上
            [weakView insertTag:preTag atIndex:preIdx];
        }
        SKTag *tag = [weakView.tags objectAtIndex:index];
        tag.textColor = SELECT_COLOR;
        tag.borderColor = SELECTE_BORDER_COLOR;
        [weakView removeTagAtIndex:index];
        [weakView insertTag:tag atIndex:index];
        [_bedTypeBtn setTitle:bedArr[index] forState:UIControlStateNormal];
        _bedTypeTagView.hidden = YES;
         [_bedTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
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


#pragma mark - TapGestureRecognizer

//添加单击手势事件
- (void)addTapGestureRecognizer:(id)any {
    //初始化一个单击手势，设置响应事件为tapClick：
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    //将手势添加给入参
    [any addGestureRecognizer:tap];
}

//单击手势事件代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //让scrollView结束编辑状态达到收起键盘的目的
    [_scrollView endEditing:YES];
    if ([touch.view isDescendantOfView:_roomNameTagView] || [touch.view isDescendantOfView:_bedTypeTagView] || [touch.view isDescendantOfView:_toolBar]) {
        return NO;
    }
    return YES;
}

//单击手势响应事件
- (void) tapClick:(UILongPressGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        flag = 1;
        //隐藏ToolBar和PickerView
        _toolBar.hidden = YES;
        _pickerView.hidden = YES;
         [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
        //设置按钮标题的颜色
        [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
        [_fullView removeFromSuperview];
        _fullView = nil;
        _roomNameTagView.hidden = YES;
        _bedTypeTagView.hidden = YES;
        
    }
}

#pragma mark - buttonAction

//取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    flag = 1;
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//确认事件
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    flag = 1;
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    //拿到某一列中选中的行号
    NSInteger row = [_pickerView selectedRowInComponent:0];
    //根据上面拿到的行号，找到对应的数据（选中行的标题）
     _hotelTitle = _pickerArr[row];
    //把拿到的标题显示在按钮上
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",_hotelTitle] forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

//选择酒店按钮事件
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (flag == 1) {
        
        [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ △",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
        //设置按钮标题的颜色
        [_chooseBtn setTitleColor:UIColorFromRGBA(150, 150, 150, 1) forState:UIControlStateNormal];
        //显示ToolBar和PickerView
        _toolBar.hidden = NO;
        _pickerView.hidden = NO;
        
        _roomNameTagView.hidden = YES;
        _bedTypeTagView.hidden = YES;
        //调用选择酒店接口
        [self selectHotel];
        flag = 0;
    }else {
        
        [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
        //设置按钮标题的颜色
        [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
        //隐藏ToolBar和PickerView
        _toolBar.hidden = YES;
        _pickerView.hidden = YES;
        
        _roomNameTagView.hidden = YES;
        _bedTypeTagView.hidden = YES;
        flag = 1;
    }
}


//填写房间名称按钮事件
- (IBAction)roomNameBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    _roomNameTagView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_roomNameTagView];
    _roomNameTagView.hidden = NO;
    
}

//房间图片按钮事件
- (IBAction)roomImgBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    _roomNameTagView.hidden = YES;
    _bedTypeTagView.hidden = YES;
}


//是否含早开关按钮
- (IBAction)switchAction:(UISwitch *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    if (sender.isOn == YES) {
        [_isEarlyBtn setTitle:@"含早" forState:UIControlStateNormal];
    }else {
        [_isEarlyBtn setTitle:@"不含早" forState:UIControlStateNormal];
    }
    [_isEarlyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _roomNameTagView.hidden = YES;
    _bedTypeTagView.hidden = YES;
}

//填写床型按钮事件
- (IBAction)bedTypeBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [_chooseBtn setTitle:[NSString stringWithFormat:@"%@ ▽",[_chooseBtn.titleLabel.text substringToIndex:_chooseBtn.titleLabel.text.length - 2]] forState:UIControlStateNormal];
    //设置按钮标题的颜色
    [_chooseBtn setTitleColor:UIColorFromRGBA(0, 120, 255, 1) forState:UIControlStateNormal];
    //隐藏ToolBar和PickerView
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
    _bedTypeTagView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_bedTypeTagView];
        _bedTypeTagView.hidden = NO;

    
    
}


@end
