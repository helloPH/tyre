//
//  GetLocationFromBMap.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "GetLocationFromBMap.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件



@interface GetLocationFromBMap ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)BMKMapView * mapView;

@property (nonatomic,strong)BMKLocationService * locationService;

@property (nonatomic,strong)BMKGeoCodeSearch * searcher;

@property (nonatomic,strong)UILabel * labelTitle;
@property (nonatomic,strong)UIImageView * imgView;


@property (nonatomic,assign)NSInteger geoIndex;
@property (nonatomic,assign)NSInteger currentRow;
@property (nonatomic,strong)NSString * provinceId;
@property (nonatomic,strong)NSString * cityId;

@property (nonatomic,strong)NSMutableArray * geoDatas;



@property (nonatomic,strong)UIButton * btnSheng;
@property (nonatomic,strong)UIButton * btnCity;
@property (nonatomic,strong)UIButton * btnCounty;
@property (nonatomic,strong)UIControl * pickControl;
@property (nonatomic,strong)UIPickerView * pickView;

@end

@implementation GetLocationFromBMap

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self newPickControl];
    // Do any additional setup after loading the view.
}

-(void)newNavi{
    self.TitleLabel.text=@"店铺地址";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    popBtn.tag=100;
    
    UIButton * submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40*self.scale, 30*self.scale)];
    submitBtn.right=Vwidth-10*self.scale;
    submitBtn.centerY=popBtn.centerY;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    submitBtn.titleLabel.font=DefaultFont(self.scale);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:submitBtn];
    submitBtn.tag=101;
    
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (sender.tag==101) {
        if (_callBack) {
            _callBack(_geoDic);
        }
    }
}

-(void)initData{
    _geoDatas=[NSMutableArray array];
    _currentRow=0;
    _provinceId=@"1";
    _cityId=@"1";
}
-(void)newView{

    
    
    
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
//    [_mapView showsUserLocation];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    UIView * geoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 30*self.scale)];
    geoView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:geoView];
    
    NSArray * btnTitles=@[@"请选择省份",@"请选择市",@"请选择县"];
    NSInteger column=3;
    CGFloat marX=20*self.scale;
    CGFloat spX=20*self.scale;
    CGFloat btnH=20*self.scale;
    CGFloat btnW=(Vwidth-marX*2-(column-1)*spX)/3;
    for (int i =0; i < column; i ++) {
        CGFloat btnX=marX + (i % column)*(btnW + spX);
        CGFloat btnY=5*self.scale;
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [geoView addSubview:btn];
//        btn.backgroundColor=lightOrangeColor;
        btn.titleLabel.font=DefaultFont(self.scale);
//        btn.titleLabel.textColor=blackTextColor;
        btn.tag=100+i;
        [btn addTarget:self action:@selector(geoSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        switch (i) {
            case 0:
                _btnSheng=btn;
                break;
            case 1:
                _btnCity=btn;
                break;
            case 2:
                _btnCounty=btn;
                break;
            default:
                break;
        }
    }
    
    
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*self.scale, 30*self.scale)];
    [self.view addSubview:imgView];
    imgView.contentMode=UIViewContentModeCenter;
    imgView.image=[UIImage imageNamed:@"map_red"];
    imgView.center=self.view.center;
    _imgView=imgView;
    
    UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 20*self.scale)];
    [self.view addSubview:labelTitle];
    labelTitle.font=DefaultFont(self.scale);
    labelTitle.textColor=blackTextColor;

    labelTitle.numberOfLines=0;
    labelTitle.layer.cornerRadius=5*self.scale;
    labelTitle.layer.masksToBounds=YES;
    labelTitle.textAlignment=NSTextAlignmentCenter;
    labelTitle.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    _labelTitle=labelTitle;
    
    
    
    
    
    _searcher=[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate=self;
    
    //配置定位服务
    self.locationService=[[BMKLocationService alloc]init];
    
    //定位的代理
    self.locationService.delegate=self;

    //定位的精确度
    self.locationService.desiredAccuracy=kCLLocationAccuracyBest;
    //定位的触发条件
    self.locationService.distanceFilter=10.f;
    
    //开始定位
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationService startUserLocationService];
    }else{
        NSLog(@"不能进行定位");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reshPickData{
    [self startAnimating:nil];
    [_geoDatas removeAllObjects];
    
    switch (_geoIndex) {
        case 0:{
            
            
            NSDictionary * dic=@{};
            [AnalyzeObject getProvinceListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    [_geoDatas addObjectsFromArray:model];
                }else{
                  [self showPromptBoxWithSting:msg];
                }
                  [self reshPickViewWithIndex:0];
                
            }];
        }
            break;
        case 1:{
            NSDictionary * dic=@{@"id":_provinceId};
            [AnalyzeObject getCityListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                   [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    [_geoDatas addObjectsFromArray:model];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
                [self reshPickViewWithIndex:0];
            }];
            
        }
            break;
        case 2:{
            NSDictionary * dic=@{@"id":_cityId};
            [AnalyzeObject getCountyListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                   [self stopAnimating];
                if ([ret isEqualToString:@"1"]) {
                    [_geoDatas addObjectsFromArray:model];
                }else{
                    [self showPromptBoxWithSting:msg];
                }
                [self reshPickViewWithIndex:0];
            }];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)reshPickViewWithIndex:(NSInteger)index{
    _currentRow=0;
    
    [_pickView reloadAllComponents];
    [_pickView selectRow:_currentRow inComponent:0 animated:YES];
//    [_pickView reloadComponent:index];
    
    
}
-(void)newPickControl{
    _pickControl=[[UIControl alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _pickControl.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    [self.view addSubview:_pickControl];
    [_pickControl addTarget:self action:@selector(geoSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _pickControl.hidden=YES;
    _pickControl.alpha=0;

    
    _pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 150*self.scale)];
    _pickView.backgroundColor=[UIColor whiteColor];
    _pickView.bottom=_pickControl.height;
    _pickView.delegate=self;
    _pickView.dataSource=self;
    [_pickControl addSubview:_pickView];

    
    
    UIView * btnBg=[[UIView  alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
    [_pickControl addSubview:btnBg];
    btnBg.bottom=_pickView.top;
    btnBg.backgroundColor=[UIColor whiteColor];
    
    
    NSArray * btnTitles=@[@"取消",@"确定"];
    //        CGFloat bottonBtnH=30*self.scale;
    for (int i =0; i < 2;  i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 0, 50*self.scale,btnBg.height)];
        [btnBg addSubview:btn];
        [btn addTarget:self action:@selector(submitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
        btn.titleLabel.font=DefaultFont(self.scale);
        btn.tag=10000+i;
        if (i==0) {
            //                [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
            //                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.right=Vwidth-10*self.scale;
        }
        //            btn.bottom=_datePicker.top;
    }
    
}
#pragma  mark-- pickview delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  _geoDatas.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary * dic=_geoDatas[row];;
    NSString * string;
    switch (_geoIndex) {
        case 0:
   
            string= [NSString stringWithFormat:@"%@",dic[@"Province_name"]];
            
            break;
        case 1:
      
            string= [NSString stringWithFormat:@"%@",dic[@"city_name"]];
            break;
        case 2:
     
            string= [NSString stringWithFormat:@"%@",dic[@"county_name"]];
            break;
        default:
            break;
    }
    return string;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentRow=row;
}

-(void)geoSelectBtn:(UIButton *)sender{
    
    
    
    
    if (_pickControl.hidden) {//隐藏状态下 能点击的只有 上方按钮
        for (UIButton * btn in sender.superview.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                btn.selected=NO;
            }
        }
        
        _geoIndex=sender.tag-100;
        sender.selected=YES;
        
        _pickControl.hidden=NO;
        [self reshPickData];
        //        [_geoDatas removeAllObjects];
        
        [UIView animateWithDuration:0.3 animations:^{
            _pickControl.alpha=1;
        }];
        
        
        
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _pickControl.alpha=0;
        } completion:^(BOOL finished) {
            _pickControl.hidden=YES;
        }];
    }
    
}

-(void)submitOrCancel:(UIButton *)sender{
    [self geoSelectBtn:nil];
    
    
    if (sender.tag==10001) {//确定按钮
   
        if (_geoDatas.count==0) {
            return;
        }
        NSDictionary * dic=_geoDatas[_currentRow];
        switch (_geoIndex) {
            case 0:{
                NSString * text=[NSString stringWithFormat:@"%@",dic[@"Province_name"]];
                _provinceId=[NSString stringWithFormat:@"%@",dic[@"Province_id"]];
                [_btnSheng setTitle:text forState:UIControlStateNormal];
                [_btnCity setTitle:@"请选择市" forState:UIControlStateNormal];
                [_btnCounty setTitle:@"请选择县" forState:UIControlStateNormal];
            }
                break;
            case 1:{
                NSString * text=[NSString stringWithFormat:@"%@",dic[@"city_name"]];
                _cityId=[NSString stringWithFormat:@"%@",dic[@"city_id"]];
                [_btnCity setTitle:text forState:UIControlStateNormal];
                [_btnCounty setTitle:@"请选择县" forState:UIControlStateNormal];
            }
                break;
            case 2:{
                NSString * text=[NSString stringWithFormat:@"%@",dic[@"county_name"]];
                [_btnCounty setTitle:text forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        NSString * geoString=@"";
        if (![_btnSheng.titleLabel.text isEqualToString:@"请选择省份"]) {
           geoString= [geoString stringByAppendingString:_btnSheng.titleLabel.text];
//            _mapView.zoomLevel=8;
            if (![_btnCity.titleLabel.text isEqualToString:@"请选择市"]) {
                geoString=[geoString stringByAppendingString:_btnCity.titleLabel.text];
//                _mapView.zoomLevel=10;
                if (![_btnCounty.titleLabel.text isEqualToString:@"请选择县"]) {
                    geoString=[geoString stringByAppendingString:_btnCounty.titleLabel.text];
//                    _mapView.zoomLevel=13;
                }
            }
        }
        BMKGeoCodeSearchOption * geoOption=[[BMKGeoCodeSearchOption alloc]init];
        geoOption.address=geoString;
        if (![_searcher geoCode:geoOption]) {
            [self showPromptBoxWithSting:@"编码失败"];
        };
        
    }

}


#pragma  mark  --  百度 location delegate 
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _mapView.centerCoordinate=userLocation.location.coordinate;

}


#pragma  mark -- map view  delegate
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    BMKReverseGeoCodeOption * option=[[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint=_mapView.centerCoordinate;
    [_searcher reverseGeoCode:option];
}

#pragma  mark -- geo delegate
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    _mapView.centerCoordinate=result.location;
    
    
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    _labelTitle.text=result.address;
    
    _labelTitle.size=[self Text:_labelTitle.text Size:CGSizeMake(Vwidth/2, 2000) Font:DefaultFont(self.scale)];
    _labelTitle.height=_labelTitle.height+10*self.scale;
    _labelTitle.width=_labelTitle.width+10*self.scale;
    _labelTitle.bottom=_imgView.top-5*self.scale;
    _labelTitle.centerX=_imgView.centerX;
    if (!_geoDic){
        _geoDic=[NSMutableDictionary dictionary];
    }
//    [_btnSheng setTitle:result.addressDetail.province forState:UIControlStateNormal];
//    [_btnCity setTitle:result.addressDetail.city forState:UIControlStateNormal];
//    [_btnCounty setTitle:result.addressDetail.district forState:UIControlStateNormal];
    
    [_geoDic setValue:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"Lat"];
    [_geoDic setValue:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"Lng"];
    [_geoDic setValue:[NSString stringWithFormat:@"%@",result.address] forKey:@"address"];
    [_geoDic setValue:[NSString stringWithFormat:@"%@",result.addressDetail.city] forKey:@"city"];
    [_geoDic setValue:[NSString stringWithFormat:@"%@",result.addressDetail.province] forKey:@"sheng"];
    [_geoDic setValue:[NSString stringWithFormat:@"%@",result.addressDetail.district] forKey:@"xian"];
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
