//
//  AirViewController.m
//  hotelApp
//
//  Created by admin2017 on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AirViewController.h"

@interface AirViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aviationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *aviationScrollView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UITableView *overdueTableView;

@end

@implementation AirViewController

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

@end
