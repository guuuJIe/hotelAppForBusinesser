//
//  offerViewController.m
//  hotelApp
//
//  Created by admin2017 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "offerViewController.h"

@interface offerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UIButton *ChooseOriginBtn;
@property (weak, nonatomic) IBOutlet UIButton *destinationBtn;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UILabel *airlinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *luggageLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *DateOfDepartureBtn;
@property (weak, nonatomic) IBOutlet UIButton *DateOfArrivalBtn;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;

- (IBAction)originAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)destinationAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DateOfDepartureAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DateOfArrivalAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)determineAction:(UIButton *)sender forEvent:(UIEvent *)event;



@end

@implementation offerViewController

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

- (IBAction)originAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)destinationAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)DateOfDepartureAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)DateOfArrivalAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)determineAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
