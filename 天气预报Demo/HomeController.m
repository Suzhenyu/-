//
//  HomeController.m
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HomeController.h"
#import "CityCell.h"
#import "CityDetailController.h"
#import "CitySelectController.h"
#import "DBMyCity.h"
#import "MyCity.h"
#import "ShowImage.h"

@interface HomeController ()
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_array;                         //用来存储在tb_mycitys中的数据
}

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"天气预报";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIButton *btnAdd=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [btnAdd addTarget:self action:@selector(goCitySelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"添加城市" forState:UIControlStateNormal];
    btnAdd.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goCityDetailAction:) name:@"showCity" object:nil];
    
    UINib *nib=[UINib nibWithNibName:@"CityCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"CityCell"];
    
    _array=[NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated{
    
    _array=nil;
    _array=[[DBMyCity shareMyCity] selectMyCityInfo];
    [_tableView reloadData];
}

-(void)goCityDetailAction:(NSNotification *)notification{
    CityDetailController *ctl=[[CityDetailController alloc] init];
    ctl.cityName=notification.object;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark--
#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"CityCell";
    CityCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CityCell" owner:self options:nil] objectAtIndex:0];
    }
    
    MyCity *city=[_array objectAtIndex:indexPath.row];
    UIImageView *ivWea=(UIImageView *)[cell viewWithTag:11];
    ivWea.image=[UIImage imageNamed:city.cityWeatherImg];
    UIImageView *ivPM25=(UIImageView *)[cell viewWithTag:12];
    ivPM25.image=[UIImage imageNamed:[[ShowImage shareShaowImage] selectImageNameByPM25Level:[city.cityPM2d5Level intValue]]];
    UILabel *lbName=(UILabel *)[cell viewWithTag:21];
    lbName.text=city.cityName;
    UILabel *lbTem=(UILabel *)[cell viewWithTag:22];
    lbTem.text=[NSString stringWithFormat:@"%@℃",city.cityTemperature];
    UILabel *lbPM25=(UILabel *)[cell viewWithTag:23];
    lbPM25.text=city.cityPM2d5;
    
    return cell;
}

#pragma mark--
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityDetailController *ctl=[[CityDetailController alloc] init];
    ctl.cityName=[[_array objectAtIndex:indexPath.row] cityName];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark--
#pragma mark  跳转到城市选择页面
-(void)goCitySelectAction:(UIButton *)sender{
    CitySelectController *ctl=[[CitySelectController alloc] init];
    UINavigationController *navCtl=[[UINavigationController alloc] initWithRootViewController:ctl];
    [self presentViewController:navCtl animated:YES completion:^{
        
    }];
}

#pragma mark--
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
