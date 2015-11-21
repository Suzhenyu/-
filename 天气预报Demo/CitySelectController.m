//
//  SelectCityController.m
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CitySelectController.h"
#import "CitySelectCell.h"
#import "DB/DBCity.h"
#import "City.h"

#define CELL_ID @"cellId"

@interface CitySelectController ()
{
    __weak IBOutlet UICollectionView *_cityCollectionView;
    __weak IBOutlet UITextField *_tfSearch;
    
    NSMutableArray *_dataArr;
}

@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib=[UINib nibWithNibName:@"CitySelectCell" bundle:nil];
    [_cityCollectionView registerNib:nib forCellWithReuseIdentifier:@"CitySelectCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    _dataArr=[[DBCity shareCity] selectAllCityName];
    
    self.title=@"添加城市";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ios7"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIButton *btnAdd=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [btnAdd addTarget:self action:@selector(goHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"关闭" forState:UIControlStateNormal];
    btnAdd.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.leftBarButtonItem=leftItem;
}

#pragma mark--
#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CitySelectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CitySelectCell" forIndexPath:indexPath];
    UILabel *lbCityName=(UILabel *)[cell viewWithTag:100];
    lbCityName.text=[_dataArr objectAtIndex:indexPath.row];
    UIImageView *ivSelect=(UIImageView *)[cell viewWithTag:101];
    ivSelect.hidden=YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName=[_dataArr objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCity" object:cityName];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark--
#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        _dataArr=[NSMutableArray array];
        NSArray *arr=[[DBCity shareCity] selectCityInfoByStr:textField.text];
        for (City *city in arr) {
            [_dataArr addObject:city.cityName];
        }
        [_cityCollectionView reloadData];
    }
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark--
-(void)goHomeAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark--
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(UIButton *)sender {
    _tfSearch.text=@"";
    [self.view endEditing:YES];
    
    _dataArr=[NSMutableArray array];
    _dataArr=[[DBCity shareCity] selectAllCityName];
    [_cityCollectionView reloadData];
}
@end
