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
#import "Utilities.h"
#import "AirlinesOffer.h"
#import "offerViewController.h"
@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger offerPageNum;
    NSInteger overduePageNum;
    NSInteger offerFlag;
    NSInteger overdueFlag;
    BOOL offerLast;
    BOOL overdueLast;
}
@property (weak, nonatomic) IBOutlet UILabel *aviationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *aviationScrollView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UITableView *overdueTableView;
@property (weak, nonatomic) IBOutlet UIView *aviationView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSMutableArray *offerArr;
@property (strong,nonatomic)NSMutableArray *overdueArr;
@property (strong,nonatomic)AirlinesOffer *offerModel;
@property (strong, nonatomic) UIImageView *offerNothingImg;
@property (strong, nonatomic) UIImageView *overdueNothingImg;
@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    offerFlag = 1;
    overdueFlag = 1;
    
    offerPageNum =1;
    overduePageNum = 1;
    //刷新指示器
    
    
    
    _offerArr = [NSMutableArray new];
    _overdueArr = [NSMutableArray new];

    // Do any additional setup after loading the view.
        //状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //去掉tableview底部多余的线
    _overdueTableView.tableFooterView = [UIView new];
    _offerTableView.tableFooterView = [UIView new];
    [self setSegment];
    [self setRefreshControl];
    [self offerInitalizeData];
    //调用tableView没数据时显示图片的方法
    if (_offerArr.count == 0) {
        [self nothingForTableView];
    }
//    [self overDueInitalizeData];

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
    [self offerRequest];
}
//已过期列表下拉刷新事件
- (void)overdueRef{
    overduePageNum = 1;
    [self overdueRequest];
}
//第一次进行网络请求的时候需要盖上朦层，所以我们把第一次网络请求和下拉刷新分开
-(void)offerInitalizeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self offerRequest];
}


-(void)overDueInitalizeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self overdueRequest];
}

#pragma mark - scrollView

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _aviationScrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //NSLog(@"page = %ld", (long)page);
        //将_segmentedControl设置选中的index为page（scrollView当前显示的tableview）
        [_segmentedControl setSelectedSegmentIndex:page animated:YES];
        //去掉scrollView横向滚动标示
        _aviationScrollView.showsHorizontalScrollIndicator = NO;
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
    if (offerFlag == 1 && page == 0) {
        offerFlag = 0;
        
        NSLog(@"第一次滑动scollview来到已报价");
         }
    if (overdueFlag == 1 && page == 1) {
        overdueFlag = 0;
        NSLog(@"第一次滑动scollview来到已过期");
        [self overDueInitalizeData];
        
    }
    return page;

}
//当tableView没有数据时显示图片的方法
- (void)nothingForTableView{
    _offerNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
     _offerNothingImg.frame = CGRectMake((UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    _overdueNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _overdueNothingImg.frame = CGRectMake(UI_SCREEN_W + (UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    [_aviationScrollView addSubview:_offerNothingImg];
    [_aviationScrollView addSubview:_overdueNothingImg];
}
#pragma mark - request
//可报价网络请求
- (void)offerRequest{
    NSDictionary *para =@{@"type":@1,@"pageNum" : @(offerPageNum),@"pageSize" : @4};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10001];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            NSDictionary *Aviation_demand = content[@"Aviation_demand"];
             NSArray *list = Aviation_demand[@"list"];
            offerLast= [Aviation_demand[@"isLastPage"]boolValue];
            //下拉刷新的时候不仅要把页码变为1，还有将数组中原来数据清空
            if(offerPageNum == 1){
                [_offerArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                _offerModel = [[AirlinesOffer alloc]initWithDict:dict];
            [_offerArr addObject:_offerModel];
                
            }
            if (_offerArr.count == 0) {
                _offerNothingImg.hidden = NO;
            }else{
               _offerNothingImg.hidden = YES;
            }
            [_offerTableView reloadData];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
             }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10001];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}
//已过期网络请求
- (void)overdueRequest{
    NSDictionary *para =@{@"type":@0,@"pageNum" : @(overduePageNum),@"pageSize" : @4};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10001];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if ([responseObject[@"result"]intValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            NSDictionary *Aviation_demand = content[@"Aviation_demand"];
            NSArray *list = Aviation_demand[@"list"];
            overdueLast= [Aviation_demand[@"isLastPage"]boolValue];
            //下拉刷新的时候不仅要把页码变为1，还有将数组中原来数据清空
            if(overduePageNum == 1){
                [_overdueArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                _offerModel = [[AirlinesOffer alloc]initWithDict:dict];
                [_overdueArr addObject:_offerModel];
            }
            if (_overdueArr.count == 0) {
                _overdueNothingImg.hidden = NO;
            }else{
                _overdueNothingImg.hidden = YES;
            }
            [_overdueTableView reloadData];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10002];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}




//有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _offerTableView) {
        return _offerArr.count;
    } else {
        return _overdueArr.count;
    }
    
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _offerTableView) {
        AirReleaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirReleaseCell" forIndexPath:indexPath];
       _offerModel = _offerArr[indexPath.row];
         NSString *starTimeStr = [Utilities dateStrFromCstampTime:(long)_offerModel.date withDateFormat:@"MM-dd"];
        cell.dateLabel.text = starTimeStr;
        cell.originLabel.text = _offerModel.origin;
        cell.endLabel.text = _offerModel.destination;
        cell.priceLabel.text = [NSString stringWithFormat:@"%@-%@",_offerModel.finalPrice,_offerModel.highPrice];
     
        NSDate *detailedDate = [NSDate dateWithTimeIntervalSince1970:_offerModel.date/1000];
        NSString *times = [detailedDate formattedTime];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@左右",times];
        cell.companyLabel.text = _offerModel.detail;
        return cell;
    }else{
        ExpiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpiredCell" forIndexPath:indexPath];
          _offerModel= _overdueArr[indexPath.row];
        NSString *overTimeStr = [Utilities dateStrFromCstampTime:(long)_offerModel.date withDateFormat:@"MM-dd"];
        cell.overdueDateLabel.text = overTimeStr;
        cell.overdueOriginLabel.text = _offerModel.origin;
        cell.overdueEndLabel.text = _offerModel.destination;
        cell.overduePriceLabel.text = [NSString stringWithFormat:@"%@-%@",_offerModel.finalPrice,_offerModel.highPrice];
        NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:_offerModel.date/1000];
      NSString *overTimes = [detailDate formattedTime];
        cell.overdueTimeLabel.text = [NSString stringWithFormat:@"%@左右",overTimes];
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
   // offerViewController *purchaseVC = [Utilities getStoryboardInstance:@"AviationOffer" byIdentity:@"purchase"];
    //传参
    
    //push跳转
    //[self.navigationController pushViewController:purchaseVC animated:YES];
  
    }
//细胞将要出现时调用（上拉翻页方法)
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView ==_offerTableView){
        if(indexPath.row == _offerArr.count-1){
            if(!offerLast){
                offerPageNum++;
                [self offerRequest];
            }
        }
    }else{
        if(indexPath.row ==_overdueArr.count-1){
            if(!overdueLast){
                overduePageNum++;
                [self overdueRequest];
            }
        }
    }
 }


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"purchase"]){
        NSIndexPath *indexPath = [_offerTableView indexPathForSelectedRow];
        _offerModel = _offerArr[indexPath.row];
        offerViewController *Offer = segue.destinationViewController;
        Offer.Id = [_offerModel.Id integerValue];
    }
  
     //Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
