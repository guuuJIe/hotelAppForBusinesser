//
//  HotelIssueViewController.m
//  hotelApp
//
//  Created by mac on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelIssueViewController.h"

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

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation HotelIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
}

//确认事件
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
}

//选择酒店按钮事件
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
