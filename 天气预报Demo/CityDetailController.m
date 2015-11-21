//
//  CityDetailController.m
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CityDetailController.h"
#import "CityDetailCell.h"
#import "ShowImage.h"
#import "DB/DBCity.h"
#import "DBMyCity.h"
#import "MyCity.h"

@interface CityDetailController ()
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableData *_data;                       //用于存储从服务端返回的数据
    NSMutableArray *_array;                     //用于存储未来6天的天气信息

    NSString *_lbDateStr;                       //时间
    NSString *_lbDawnStr;                       //早：温度＋风力
    NSString *_lbDayStr;                        //中：温度＋风力
    NSString *_lbNightStr;                      //晚：温度＋风力
    NSString *_imgDawnStr;                      //对应图片
    NSString *_imgDayStr;
    NSString *_imgNightStr;
}

@end

@implementation CityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_cityName;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
//    UINib *nib=[UINib nibWithNibName:@"CityDetailCell" bundle:[NSBundle mainBundle]];
//    [_tableView registerNib:nib forCellReuseIdentifier:@"CityDetailCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *strURL=[NSString stringWithFormat:@"http://op.juhe.cn/onebox/weather/query?cityname=%@&key=42253100146dc5234488e4dcca55cd42",_cityName];
    NSString *strURLUTF8=[strURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:strURLUTF8];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    if (connection==nil) {
        NSLog(@"请求数据失败，请重试");
        return;
    }
}

#pragma mark--
#pragma mark  加载数据
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data=[NSMutableData data];
    _array=[NSMutableArray array];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    
    _lbWeather.text=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"info"];         //天气
    _lbTemperature.text=[NSString stringWithFormat:@"%@℃",[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"temperature"]];     //温度
    _lbDirectPoewr.text=[NSString stringWithFormat:@"%@%@",[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"wind"] valueForKey:@"direct"],[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"wind"] valueForKey:@"power"]];     //风向，风力
    _lbZiwaixian.text=[NSString stringWithFormat:@"紫外线:%@",[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"life"] valueForKey:@"info"] valueForKey:@"ziwaixian"] objectAtIndex:0]];       //紫外线指数
    _lbHumidity.text=[NSString stringWithFormat:@"湿度:%@",[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"humidity"]];        //湿度
    _ivPM2d5Img.image=[UIImage imageNamed:[[ShowImage shareShaowImage] selectImageNameByPM25Level:[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"level"] intValue]]];      //PM2.5等级,由此给出等级图片
    _lbChuanyi.text=[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"life"] valueForKey:@"info"] valueForKey:@"chuanyi"] objectAtIndex:0];         //穿衣
    _lbRecommend.text=[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"life"] valueForKey:@"info"] valueForKey:@"chuanyi"] objectAtIndex:1];       //穿衣建议

    for (int i=0; i<=5; i++) {
        _lbDateStr=[NSString stringWithFormat:@"周%@",[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"week"]];            //时间
        _lbDawnStr=[NSString stringWithFormat:@"%@℃%@",[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"dawn"] objectAtIndex:0],[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"dawn"] objectAtIndex:4]];           //早：温度＋风力
        _lbDayStr=[NSString stringWithFormat:@"%@℃%@",[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:0],[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:4]];           //中：温度＋风力
        _lbNightStr=[NSString stringWithFormat:@"%@℃%@",[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:0],[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"night"] objectAtIndex:4]];           //晚：温度＋风力
        _imgDawnStr=[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:1];
        _imgDayStr=[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:1];
        _imgNightStr=[[[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"] objectAtIndex:i] valueForKey:@"info"] valueForKey:@"day"] objectAtIndex:1];
        NSArray *arr=@[_lbDateStr,_lbDawnStr,_lbDayStr,_lbNightStr,_imgDawnStr,_imgDayStr,_imgNightStr];
        [_array addObject:arr];
    }
    [_tableView reloadData];
  
//    //更新数据库-tb_citys
//    NSArray *arrayCityName=[[DBCity shareCity] selectAllCityInfo];
//    BOOL isExst=NO;
//    for (NSArray *arr in arrayCityName) {
//        if ([_cityName isEqualToString: [arr objectAtIndex:1]]) {
//            isExst=YES;
//        }
//    }
//    if (!isExst) {
//        //插入数据
//        [[DBCity shareCity] insertCity:_cityName];
//    }
    
    //更新数据库-tb_mycitys
    NSArray *arrayMyCityName=[[DBMyCity shareMyCity] selectMyCityInfo];
    BOOL isExst1=NO;
    for (MyCity *city in arrayMyCityName) {
        if ([_cityName isEqualToString:city.cityName]) {
            isExst1=YES;
            //更新数据
            MyCity *city=[[MyCity alloc] init];
            city.cityName=_cityName;
            city.cityWeatherImg=[[ShowImage shareShaowImage] selectImageNameByWeatherStr:_lbWeather.text];
            city.cityTemperature=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"temperature"];
            city.cityPM2d5=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"pm25"];
            city.cityPM2d5Level=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"level"];
            if ([[DBMyCity shareMyCity] updateMyCityInfo:city]==NO) {
                NSLog(@"更新我的城市数据出错");
            }
        }
    }
    if (!isExst1) {
        //插入数据
        MyCity *city=[[MyCity alloc] init];
        city.cityName=_cityName;
        city.cityWeatherImg=[[ShowImage shareShaowImage] selectImageNameByWeatherStr:_lbWeather.text];
        city.cityTemperature=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"temperature"];
        city.cityPM2d5=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"pm25"];
        city.cityPM2d5Level=[[[[[dic valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"level"];
        if ([[DBMyCity shareMyCity] insertMyCityInfo:city]==NO) {
            NSLog(@"新建我的城市数据出错");
        }
    }
}

#pragma mark--
#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"CityDetailCell";
    CityDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CityDetailCell" owner:self options:nil] objectAtIndex:0];
    }

    UILabel *lbDate=(UILabel *)[cell viewWithTag:100];
    lbDate.text=[[_array objectAtIndex:indexPath.row] objectAtIndex:0];
    UILabel *lbPawn=(UILabel *)[cell viewWithTag:101];
    lbPawn.text=[[_array objectAtIndex:indexPath.row] objectAtIndex:1];
    UILabel *lbDay=(UILabel *)[cell viewWithTag:102];
    lbDay.text=[[_array objectAtIndex:indexPath.row] objectAtIndex:2];
    UILabel *lbNight=(UILabel *)[cell viewWithTag:103];
    lbNight.text=[[_array objectAtIndex:indexPath.row] objectAtIndex:3];
    UIImageView *ivPawn=[cell viewWithTag:201];
    ivPawn.image=[UIImage imageNamed:[[ShowImage shareShaowImage] selectImageNameByWeatherStr:[[_array objectAtIndex:indexPath.row] objectAtIndex:4]]];
    UIImageView *ivDay=[cell viewWithTag:202];
    ivDay.image=[UIImage imageNamed:[[ShowImage shareShaowImage] selectImageNameByWeatherStr:[[_array objectAtIndex:indexPath.row] objectAtIndex:5]]];
    UIImageView *ivNight=[cell viewWithTag:203];
    ivNight.image=[UIImage imageNamed:[[ShowImage shareShaowImage] selectImageNameByWeatherStr:[[_array objectAtIndex:indexPath.row] objectAtIndex:6]]];
    
    return cell;
}


#pragma mark--
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
