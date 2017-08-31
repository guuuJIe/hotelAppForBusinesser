//
//  AirViewController.m
//  hotelApp
//
//  Created by admin2017 on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AirViewController.h"
#import "AirReleaseTableViewCell.h"
#import "ExpiredTableViewCell.h"
#import "HMSegmentedControl.h"
@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger offerPageNum;
    NSInteger overduePageNum;
    NSInteger offerFlag;
    NSInteger overdueFlag;

}
@property (weak, nonatomic) IBOutlet UILabel *aviationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *aviationScrollView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UITableView *overdueTableView;
@property (weak, nonatomic) IBOutlet UIView *aviationView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    offerFlag = 1;
    overdueFlag = 1;

    //刷新指示器
    [self setRefreshControl];
    [self setSegment];
    // Do any additional setup after loading the view.
        //状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //去掉tableview底部多余的线
    _overdueTableView.tableFooterView = [UIView new];
    _offerTableView.tableFooterView = [UIView new];
    [self setSegment];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark - setSegment设置菜单栏
//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"可报价",@"已过期"]];
    //设置位置
    _segmentedControl.frame = CGRectMake(0,_aviationView.frame.size.height, UI_SCREEN_W, 40);
    //设置默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //设置菜单栏的背景色
    _segmentedControl.backgroundColor = UIColorFromRGB(55, 136, 229);
    //设置线的高度
    _segmentedControl.selectionIndicatorColor = UIColorFromRGB(200, 200, 200);
    _segmentedControl.selectionIndicatorHeight = 3.f;
    //设置选中状态的样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //选中时的标记的位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(240, 240, 240, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:19]};
    //选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.aviationScrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    
    [self.view addSubview:_segmentedControl];
}
#pragma mark - refreshControl
//创建刷新指示器的方法
- (void)setRefreshControl{
    //已获取列表的刷新指示器
    UIRefreshControl *offerRef = [UIRefreshControl new];
    [offerRef addTarget:self action:@selector(offerRef) forControlEvents:UIControlEventValueChanged];
    offerRef.tag = 10001;
    [_offerTableView addSubview:offerRef];
    
    //未获取列表的刷新指示器
    UIRefreshControl *overdueRef = [UIRefreshControl new];
    [overdueRef addTarget:self action:@selector(overdueRef) forControlEvents:UIControlEventValueChanged];
    overdueRef.tag = 10002;
    [_overdueTableView addSubview:overdueRef];
    
   }
//可报价列表下拉刷新事件
- (void)offerRef{
    offerPageNum = 1;

}
//已过期列表下拉刷新事件
- (void)overdueRef{
    overduePageNum = 1;
   
}
#pragma mark - scrollView

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _aviationScrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //NSLog(@"page = %ld", (long)page);
        //将_segmentedControl设置选中的index为page（scrollView当前显示的tableview）
        [_segmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}
//scrollView已经结束滑动的动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _aviationScrollView) {
        [self scrollCheck:scrollView];
    }
}
//判断scrollView滑动到那里了
- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    if (offerFlag == 1 && page == 1) {
        offerFlag = 0;
        NSLog(@"第一次滑动scollview来到已报价");
     
    }
    if (overdueFlag == 1 && page == 2) {
        overdueFlag = 0;
        NSLog(@"第一次滑动scollview来到已过期");
        
    }
    return page;

}


//有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _offerTableView) {
        AirReleaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirReleaseCell" forIndexPath:indexPath];
        return cell;
    }else{
        ExpiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpiredCell" forIndexPath:indexPath];
        return cell;
    }
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end