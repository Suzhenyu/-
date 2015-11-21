//
//  CityDetailController.h
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *cityName;

@property (weak, nonatomic) IBOutlet UILabel *lbWeather;
@property (weak, nonatomic) IBOutlet UILabel *lbTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lbDirectPoewr;
@property (weak, nonatomic) IBOutlet UILabel *lbZiwaixian;
@property (weak, nonatomic) IBOutlet UILabel *lbHumidity;
@property (weak, nonatomic) IBOutlet UIImageView *ivPM2d5Img;
@property (weak, nonatomic) IBOutlet UILabel *lbChuanyi;
@property (weak, nonatomic) IBOutlet UILabel *lbRecommend;

@end
