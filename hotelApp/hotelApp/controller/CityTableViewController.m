//
//  CityTableViewController.m
//  hotelApp
//
//  Created by mac on 2017/9/3.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CityTableViewController.h"

@interface CityTableViewController ()

@property (strong,nonatomic)NSDictionary *cities;
@property (strong,nonatomic)NSArray *citylist;

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self naviConfig];
    [self InitalizeCityList];
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

-(void)naviConfig{
    //设置导航栏的标题
    self.title = @"选择城市";
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(50, 130, 255)];
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}


#pragma mark - readplist

-(void)InitalizeCityList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"Cities" ofType:@"plist"];
    if ([fileManager fileExistsAtPath:filepath]) {
        NSDictionary *filecontent = [NSDictionary dictionaryWithContentsOfFile:filepath];
        if (filecontent) {
            _cities = filecontent;
            //提取字典中所有的键
            NSArray *rowKeys = [filecontent allKeys];
            //根据拼音首字母进行能够识别多音字的升序排序
            _citylist = [rowKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _citylist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *city = _citylist[section];
    NSArray *sectionCity = _cities[city];
    
    return sectionCity.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    NSString *list = _citylist[indexPath.section];
    NSArray *sectioncity = _cities[list];
    NSDictionary *city = sectioncity[indexPath.row];
    cell.textLabel.text = city[@"name"];
    
    return cell;
}
//设置组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _citylist[section];
}

//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
//设置右侧快捷键栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _citylist;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取一组的中的数据
    NSString *key = _citylist[indexPath.section];
    //在存入数组
    NSArray *sectioncities = _cities[key];
    //在通过字典拿值
    NSDictionary *city =sectioncities[indexPath.row];
    //发送一个通知
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetHome" object:city[@"name"]] waitUntilDone:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
