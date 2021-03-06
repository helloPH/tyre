//
//  BeComeMerchant.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "BeComeMerchant.h"
#import "GetLocationFromBMap.h"
#import "ZLPickerViewController.h"
#import "ZLPickerBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLPickerBrowserPhoto.h"
#import "GeoViewController.h"
#import "IQKeyboardManager.h"


@interface BeComeMerchant ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIImageView * currentImgView;
@property (nonatomic,strong)NSMutableArray * imgsMentou;
@property (nonatomic,strong)NSMutableDictionary * infoDic;
@property (nonatomic,assign)BOOL isM;

@property (nonatomic,strong)UITextField * tfPerson;
@property (nonatomic,strong)UITextField * tfTel;
@property (nonatomic,strong)UITextField * tfBussname;
@property (nonatomic,strong)UIImageView * imgSfzz;
@property (nonatomic,strong)UIImageView * imgSfzf;
@property (nonatomic,strong)UIImageView * imgYyzz;
@property (nonatomic,strong)UIImageView * imgZzzs;


@property (nonatomic,strong)UITextField * tfYyzz;
@property (nonatomic,strong)UITextField * tfZzzs;
@property (nonatomic,strong)UIView * doorView;
//@property (nonatomic,strong)UIImageView * imgMentou1;

@property (nonatomic,strong)UILabel * labelGeo1;
@property (nonatomic,strong)UILabel  * labelGeo;

@property (nonatomic,strong)NSMutableDictionary  * GeoDic;

@property (nonatomic,assign)BOOL isZheng;
@property (nonatomic,assign)BOOL isFan;
@property (nonatomic,assign)BOOL isyyzz;
@property (nonatomic,assign)BOOL iszzzs;
@end

@implementation BeComeMerchant

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
//    _isRefuse=NO;
    if (_isRefuse) {
        [self ShowAlertTitle:@"被拒绝成为商家" Message:[NSString  stringWithFormat:@"拒绝原因：%@\n\n是否再次申请？",_reson] Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self reshData];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
    
 
    }
    // Do any additional setup after loading the view.
}
-(void)initData{
    
    _isZheng=NO;
    _isFan=NO;
    _isyyzz=NO;
    _iszzzs=NO;
    _infoDic=[NSMutableDictionary dictionary];
    _imgsMentou=[NSMutableArray array];
   _tfPerson=[UITextField new];
   _tfTel=[UITextField new];
   _tfBussname=[UITextField new];
   _imgSfzz=[UIImageView new];
   _imgSfzf=[UIImageView new];
   _tfYyzz=[UITextField new];
   _tfZzzs=[UITextField new];
//   _imgMentou1=[UIImageView new];
   _labelGeo=[UILabel new];
    _GeoDic=[NSMutableDictionary dictionaryWithDictionary:@{@"sheng":@"",
                                                            @"city":@"",
                                                            @"xian":@"",
                                                            @"address":@"",
                                                            @"Lng":@"",
                                                            @"Lat":@""}];
    
}
-(void)newNavi{
    self.TitleLabel.text=@"申请成为商家";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reshData{
    [self startAnimating:nil];
    
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    [AnalyzeObject kaiDianInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            [_infoDic addEntriesFromDictionary:model];
            
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"sheng"]] forKey:@"sheng"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"city"]] forKey:@"city"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"xian"]] forKey:@"xian"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"address"]] forKey:@"address"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"lng"]] forKey:@"Lng"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",_infoDic[@"lat"]] forKey:@"Lat"];
            if (_imgsMentou) {
                [_imgsMentou removeAllObjects];
            }
//            [_imgsMentou addObject:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_infoDic[@"mentou1"]]]];
//            [_imgsMentou addObject:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_infoDic[@"mentou2"]]]];
//            [_imgsMentou addObject:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_infoDic[@"mentou3"]]]];
        [self reshView];
        }else{
            
        }
    }];
    
}
-(void)reshView{
    _tfPerson.text=[NSString stringWithFormat:@"%@",_infoDic[@"person"]];
    _tfTel.text=[NSString stringWithFormat:@"%@",_infoDic[@"tel"]];
    _tfBussname.text=[NSString stringWithFormat:@"%@",_infoDic[@"name"]];
    _tfYyzz.text=[NSString stringWithFormat:@"%@",_infoDic[@"Yyzz_bm"]];
    _tfZzzs.text=[NSString stringWithFormat:@"%@",_infoDic[@"Zzzs_bm"]];
    _labelGeo.text=[NSString stringWithFormat:@"%@",_infoDic[@"address"]];
    
    [self reshImgMentView];
}
-(void)dismissKey{
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKey)];
    [_scrollView addGestureRecognizer:tap];
    _scrollView.delegate=self;
    
    NSArray * titles1=@[@{@"title":@"店铺名称",@"place":@"请输入您的店铺名称"},
                        @{@"title":@"联系人",@"place":@"此处一经注册不能修改"},
                       @{@"title":@"电话",@"place":@"请输入您的电话号码"},
                       ];
//        NSArray * tfs1=@[_tfPerson,_tfTel,_tfBussname];
    CGFloat setY=0;
    for (int i =0 ; i < titles1.count; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale+i * 40*self.scale, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cellView];
        
        UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 20*self.scale)];
        labelTitle.font=DefaultFont(self.scale);
        labelTitle.textColor=blackTextColor;
//        labelTitle.backgroundColor=grayTextColor;
        [cellView addSubview:labelTitle];
        labelTitle.text=[titles1[i]valueForKey:@"title"];
        [labelTitle sizeToFit];
        
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(labelTitle.right+10*self.scale, labelTitle.top, 200*self.scale, 20*self.scale)];
        [cellView addSubview:tf];
        tf.font=DefaultFont(self.scale);
        tf.textColor=blackTextColor;
        tf.placeholder=[titles1[i]valueForKey:@"place"];
        tf.centerY=labelTitle.centerY;
        tf.delegate=self;
        tf.tag=100+i;
        setY=cellView.bottom;
//        tf.backgroundColor=grayTextColor;
        //上传为属性
        switch (i) {
            case 0:
                _tfBussname=tf;
                [_tfBussname limitText:@15];
                break;
            case 1://联系人
                _tfPerson=tf;
                [_tfPerson limitText:@10];
                break;
            case 2:
                _tfTel=tf;
                [_tfTel limitText:@11];
                _tfTel.keyboardType=UIKeyboardTypePhonePad;
            
                break;
    
            default:
                break;
        }

     }
    

    
    
    //身份证
    UIView * identityCard=[[UIView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, Vwidth/2)];
    identityCard.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:identityCard];
    
    UILabel * labelIdTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
    labelIdTitle.font=DefaultFont(self.scale);
    labelIdTitle.textColor=blackTextColor;
    [identityCard addSubview:labelIdTitle];
    labelIdTitle.text=@"身份证上传(正反面)";
    
    UILabel * li=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, labelIdTitle.bottom+40*self.scale, 30*self.scale, 20*self.scale)];
    li.font=DefaultFont(self.scale);
    li.textColor=blackTextColor;
    li.text=@"例:";
    [identityCard addSubview:li];
    
    CGFloat idW=Vwidth/7;
    CGFloat idH=idW*0.66;
    CGFloat idP=20*self.scale;
    
    CGFloat eX=0;
    CGFloat eY=0;
    
    for (int i = 0; i < 4 ; i ++) {
        CGFloat idX=i % 2 *(idW+idP) + li.right+idP;
        CGFloat idY=i / 2 *(idH+30*self.scale) + labelIdTitle.bottom+10*self.scale;
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(idX, idY, idW, idH)];
       
        [identityCard addSubview:imgView];
         imgView.tag=100+i;
        if (i==0 || i == 1) {
            
            UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(imgView.left, imgView.bottom+5*self.scale, imgView.width, 20*self.scale)];
            label.font=Small10Font(self.scale);
            label.textColor=blackTextColor;
            label.textAlignment=NSTextAlignmentCenter;
            [identityCard addSubview:label];
            if (i==0) {
                 imgView.image=[UIImage imageNamed:@"shenfen_zheng"];
                label.text=@"正面";
//                _imgSfzz=imgView;
            }else{
                imgView.image=[UIImage imageNamed:@"shenfen_fan"];
                label.text=@"反面";
//                _imgSfzf=imgView;
            }
            
        }else{
            imgView.tag=1000+i;
            
             imgView.image=[UIImage imageNamed:@"beijing_tu"];
            imgView.layer.masksToBounds=YES;
            imgView.userInteractionEnabled=YES;
            imgView.contentMode=UIViewContentModeScaleAspectFill;
            //选择照片的手势
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
            [imgView addGestureRecognizer:tap];
            
            //上传为属性
            if (i==2) {
//                imgView.image=[UIImage imageNamed:@"shenfen_zheng"];
//                label.text=@"正面";
                _isZheng=NO;
                _imgSfzz=imgView;
                
            }else{
//                label.text=@"反面";
                
                _isFan=NO;
                _imgSfzf=imgView;
            }
            
        }
        eX=imgView.right;
        eY=imgView.bottom;
    }
    li.centerY=labelIdTitle.bottom+10*self.scale+idH/2;
    
    UILabel * labelTip=[[UILabel alloc]initWithFrame:CGRectMake(eX+10*self.scale, 0, 80*self.scale, 20*self.scale)];
    labelTip.centerY=eY-idH/2;
    labelTip.font=Small10Font(self.scale);
    labelTip.textColor=blackTextColor;
    labelTip.text=@"点击上传身份证(正反面必传)";
    [identityCard addSubview:labelTip];
    identityCard.height=eY+10*self.scale;

    setY=identityCard.bottom;
    
    
    
    NSArray * titles2=@[@{@"title":@"营业执照(必传)",@"place":@"点击上传营业执照"},
                        @{@"title":@"资质证书(必传)",@"place":@"点击上传资质证书"}];
    CGFloat setYY=setY;
    
    

    for (int i =0 ; i < titles2.count; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0,setYY+ 10*self.scale+i * 80*self.scale, Vwidth, 80*self.scale)];
        [_scrollView addSubview:cellView];
        
        UILabel * labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 20*self.scale)];
        labelTitle.font=DefaultFont(self.scale);
        labelTitle.textColor=blackTextColor;
        [cellView addSubview:labelTitle];
        labelTitle.text=[titles2[i]valueForKey:@"title"];
        [labelTitle sizeToFit];
        
        
        UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(labelTitle.right+10*self.scale, labelTitle.top, 200*self.scale, 20*self.scale)];
        [cellView addSubview:tf];
        tf.font=DefaultFont(self.scale);
        tf.textColor=blackTextColor;
        tf.placeholder=[titles2[i]valueForKey:@"place"];
        setY=cellView.bottom;
        tf.delegate=self;
        tf.tag=1000+i;
        [tf limitText:@19];
        tf.keyboardType=UIKeyboardTypeAlphabet;
        tf.hidden=YES;
        
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(60*self.scale, labelTitle.bottom+10*self.scale, idW, idH)];
        [cellView addSubview:imgView];
        imgView.contentMode=UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds=YES;
        imgView.tag=1050+i;
        imgView.image=[UIImage imageNamed:@"beijing_tu"];
        imgView.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
        [imgView addGestureRecognizer:tap];
        
        
     
        UILabel * zhaoTip=[[UILabel alloc]initWithFrame:CGRectMake(imgView.right+10*self.scale, 0, 80*self.scale, 20*self.scale)];
        [cellView addSubview:zhaoTip];
        zhaoTip.centerY=imgView.centerY;
        zhaoTip.font=Small10Font(self.scale);
        zhaoTip.textColor=blackTextColor;
        zhaoTip.text=[titles2[i]valueForKey:@"place"];
        [zhaoTip sizeToFit];
        
        
        
        
        
        //上传为属性
        switch (i) {
            case 0://联系人
                _tfYyzz=tf;
                _imgYyzz=imgView;
                break;
            case 1:
                _tfZzzs=tf;
                _imgZzzs=imgView;
                break;
            default:
                break;
        }
    }
    
    //门头合照
    UIView * doorView=[[UIView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 110*self.scale)];
    doorView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:doorView];
    _doorView=doorView;
    UILabel * doorTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,doorView.top+10*self.scale, 100*self.scale, 20*self.scale)];
    [_scrollView addSubview:doorTitle];
    doorTitle.font=DefaultFont(self.scale);
    doorTitle.textColor=blackTextColor;
    doorTitle.text=@"店铺门头";
    
    [self reshImgMentView];
    
    

    setY=doorView.bottom;
    
 
    //

    
    CellView * geoCell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 40*self.scale)];
    [_scrollView addSubview:geoCell];
    geoCell.titleLabel.text=@"店铺地址";
    [geoCell ShowRight:YES];
    geoCell.topline.hidden=NO;
    [geoCell.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    geoCell.btn.tag=1001;
    setY=geoCell.bottom;
    UILabel * labelA1=[[UILabel alloc]initWithFrame:CGRectMake(geoCell.titleLabel.right+10*self.scale, 10*self.scale, 200, 15*self.scale)];
    labelA1.font=DefaultFont(self.scale);
    labelA1.textColor=grayTextColor;
    labelA1.text=@"请选择省市区";
    labelA1.textAlignment=NSTextAlignmentRight;
    labelA1.right=geoCell.RightImg.left-10*self.scale;
    labelA1.centerY=geoCell.titleLabel.centerY;
    [geoCell addSubview:labelA1];
    _labelGeo1=labelA1;
    
    
    
    
    
    CellView * adressCell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 40*self.scale)];
    [_scrollView addSubview:adressCell];
    adressCell.titleLabel.text=@"地图选取位置";
    adressCell.titleLabel.width=100;
    [adressCell ShowRight:YES];
    adressCell.topline.hidden=NO;
    [adressCell.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    adressCell.btn.tag=100;
    setY=adressCell.bottom;
    UILabel * labelA=[[UILabel alloc]initWithFrame:CGRectMake(adressCell.titleLabel.right+10*self.scale, 10*self.scale, 200, 15*self.scale)];
    labelA.font=DefaultFont(self.scale);
    labelA.textColor=grayTextColor;
    labelA.textAlignment=NSTextAlignmentRight;
    labelA.right=adressCell.RightImg.left-10*self.scale;
    labelA.centerY=adressCell.titleLabel.centerY;
    [adressCell addSubview:labelA];
    _labelGeo=labelA;
    
    
    
    
    
    UIButton * registBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    [_scrollView addSubview:registBtn];
    registBtn.tag=101;
    registBtn.layer.cornerRadius=4;
    registBtn.layer.masksToBounds=YES;
    registBtn.titleLabel.font=BigFont(self.scale);
    [registBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    setY=registBtn.bottom;
    
    UILabel * bottomTip=[[UILabel alloc]initWithFrame:CGRectMake(registBtn.left, registBtn.bottom+10*self.scale, registBtn.width, 20*self.scale)];
    bottomTip.font=Small10Font(self.scale);
    bottomTip.textColor=navigationControllerColor;
    [_scrollView addSubview:bottomTip];
    bottomTip.textAlignment=NSTextAlignmentCenter;
    bottomTip.text=@"提交申请成功，我们会在3-5个工作日内完成审核，请耐心等待";
    setY=bottomTip.bottom+20*self.scale;
    
    _scrollView.contentSize=CGSizeMake(Vwidth, setY);
}
-(void)reshImgMentView{
    [_doorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int column=3;
    CGFloat marginX=20*self.scale;
    CGFloat spX=20*self.scale;
    CGFloat spY=20*self.scale;
    CGFloat btnW=(Vwidth-marginX*2-(column-1)*spX)/column;
    CGFloat btnH=btnW*0.66;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mChoosePhoto:)];
    if (_imgsMentou.count==0) {
        CGFloat btnX= Vwidth - (btnW + marginX);
        btnX=marginX;/////////由左往右
        
        CGFloat btnY= 40*self.scale;
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        
        img.image=[UIImage imageNamed:@"tian_jia"];
        img.contentMode=UIViewContentModeScaleAspectFit;
        img.layer.masksToBounds=YES;
        [_doorView addSubview:img];
        img.userInteractionEnabled=YES;
        [img addGestureRecognizer:tap];
        
        UILabel * labet=[[UILabel alloc]initWithFrame:CGRectMake(img.left, img.bottom, img.width, 20*self.scale)];
        labet.font=DefaultFont(self.scale);
        labet.textColor=grayTextColor;
        labet.textAlignment=NSTextAlignmentCenter;
        labet.text=@"点击上传图片";
//        [_doorView addSubview:labet];
        
    }
    UITapGestureRecognizer * tapB=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mPhotoBrower:)];
    if (_imgsMentou.count!=3) {//不够三张
        CGFloat btnX= Vwidth - (btnW + marginX);
        btnX=marginX;//由左往右
        CGFloat btnY= 40*self.scale;
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        img.layer.masksToBounds=YES;
        img.image=[UIImage imageNamed:@"tian_jia"];
        img.contentMode=UIViewContentModeScaleAspectFit;
        [_doorView addSubview:img];
        img.userInteractionEnabled=YES;
        [img addGestureRecognizer:tap];
        
        UILabel * labet=[[UILabel alloc]initWithFrame:CGRectMake(img.left, img.bottom, img.width, 20*self.scale)];
        labet.font=DefaultFont(self.scale);
        labet.textColor=grayTextColor;
        labet.textAlignment=NSTextAlignmentCenter;
         labet.text=@"点击上传图片";
//        [_doorView addSubview:labet];
        
        for (int i =0; i < _imgsMentou.count; i ++) {
         UIImageView * img=[UIImageView new];
         CGFloat btnY= i / column*(spY+btnH) +40*self.scale;
         CGFloat btnX=Vwidth - (btnW + marginX)-(i+1)*(btnW +spX);
            btnX=(btnW+spX)*(i+1)+marginX;//由左往右
            
            
         img.frame=CGRectMake(btnX, btnY, btnW, btnH);
            img.contentMode=UIViewContentModeScaleAspectFill;
            img.layer.masksToBounds=YES;
//        if (_isRefuse) {
//            [img setImageWithURL:[NSURL URLWithString:_imgsMentou[i]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
//        }else{
            img.image=_imgsMentou[i];
//        }
            
            
         [_doorView addSubview:img];
            UIButton * btnDele=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20*self.scale, 20*self.scale)];
            [btnDele setBackgroundImage:[UIImage imageNamed:@"loan_photo_delete"] forState:UIControlStateNormal];
            [btnDele addTarget:self action:@selector(mDelePhoto:) forControlEvents:UIControlEventTouchUpInside];
            btnDele.tag=100+i;
            [img addSubview:btnDele];
            
            
            img.userInteractionEnabled=YES;
            [img addGestureRecognizer:tapB];
        }
    }else{//狗三张
        for (int i =0; i < _imgsMentou.count; i ++) {
          UIImageView * img=[UIImageView new];
            img.contentMode=UIViewContentModeScaleAspectFill;
          CGFloat btnY= i / column*(spY+btnH) +40*self.scale;
          CGFloat btnX= Vwidth - (btnW + marginX)-i*(btnW +spX);
            btnX=i*(btnW +spX)+marginX;//由左往右
            img.layer.masksToBounds=YES;
          img.frame=CGRectMake(btnX, btnY, btnW, btnH);
//         if (_isRefuse) {
//            [img setImageWithURL:[NSURL URLWithString:_imgsMentou[i]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
//            }else{
                img.image=_imgsMentou[i];
//            }
            
          [_doorView addSubview:img];
            img.userInteractionEnabled=YES;
            [img addGestureRecognizer:tapB];
            UIButton * btnDele=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [btnDele setBackgroundImage:[UIImage imageNamed:@"loan_photo_delete"] forState:UIControlStateNormal];
            [btnDele addTarget:self action:@selector(mDelePhoto:) forControlEvents:UIControlEventTouchUpInside];
            btnDele.tag=100+i;
            [img addSubview:btnDele];
        }
    }
}

-(void)mChoosePhoto:(UITapGestureRecognizer *)tap{
       [self dismissKey];
    _isM=YES;
    _currentImgView=(UIImageView *)(tap.view);
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [action showInView:self.view];
}
-(void)mDelePhoto:(UIButton *)sender{
    [self dismissKey];
    [_imgsMentou removeObjectAtIndex:sender.tag-100];
    [self reshImgMentView];
    
    
}
-(void)mPhotoBrower:(UITapGestureRecognizer *)tap{
    
    
}

-(void)btnEvent:(UIButton*)sender{
       [self dismissKey];
    
    if (sender.tag==1001) {
        GeoViewController * geoV=[GeoViewController new];
        geoV.geoIndex=1;
        geoV.block=^(NSString * string,NSMutableDictionary * dic){
            _labelGeo1.text=string;
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"province"]] forKey:@"sheng"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"city"]] forKey:@"city"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"county"]] forKey:@"xian"];
            
            
        };
        [self.navigationController pushViewController:geoV animated:YES];
        return;
    }
    
    if (sender.tag==100){//地图
        GetLocationFromBMap * get=[GetLocationFromBMap new];
        get.isGet=NO;
//        get.geoDic=_GeoDic;
        get.callBack=^(NSMutableDictionary * dic){
//            _GeoDic=dic;
        
        
        
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"address"]] forKey:@"address"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"Lng"]] forKey:@"Lng"];
            [_GeoDic setObject:[NSString stringWithFormat:@"%@",dic[@"Lat"]] forKey:@"Lat"];
            
            
            
            
            _labelGeo.text=[[NSString stringWithFormat:@"%@",_GeoDic[@"address"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_GeoDic[@"address"]];
//            [_labelGeo sizeToFit];
        };
        [self.navigationController pushViewController:get animated:YES];
    }else{//注册
//        [self showPromptBoxWithSting:@"注册"];
     
        
        NSString * sfzzS=[self imgDataForString:_imgSfzz.image];
        NSString * sfzfS=[self imgDataForString:_imgSfzf.image];
        NSString * sUid=[Stockpile sharedStockpile].ID;
        NSString * sPer=_tfPerson.text;
        NSString * sTel=_tfTel.text;
        NSString * sBuss=_tfBussname.text;
        
        
        
//        NSString * sYyzz=_tfYyzz.text;
//        NSString * sZzzs=_tfZzzs.text;
        NSString * sYyzz=[self imgDataForString:_imgYyzz.image];
        NSString * sZzzs=[self imgDataForString:_imgZzzs.image];
  

       
        if ([sBuss isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入店铺名称"];
            return;
        }
        if ([sPer isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入联系人名字"];
            return;
        }
        if ([sTel isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入电话"];
            return;
        }
        if (![sTel isValidateMobile]) {
            [self showPromptBoxWithSting:@"请输入正确手机格式"];
            return;
        }
        
        
        if (!_isZheng) {
            [self ShowAlertWithMessage:@"请上传身份证正面图片"];
            return;
        }
        if (!_isFan) {
            [self ShowAlertWithMessage:@"请上传身份证反面图片"];
            return;
        }
        
        
        
        
        //        if ([sYyzz isEmptyString]) {
        //            [self showPromptBoxWithSting:@"请输入营业执照"];
        //            return;
        //        }
        //        if ([sZzzs isEmptyString]) {
        //            [self showPromptBoxWithSting:@"请输入资质证书"];
        //            return;
        //        }
        
        
        
        if (!_isyyzz) {
            [self ShowAlertWithMessage:@"请上传营业执照图片"];
            return;
        }
        if (!_iszzzs) {
            [self ShowAlertWithMessage:@"请上传资质证书图片"];
            return;
        }


        
        
        if (_imgsMentou.count<1) {
            [self ShowAlertWithMessage:@"必须上传1-3张门头照!"];
            return;
        }
        NSDictionary * mDic;
        
        switch (_imgsMentou.count) {
            case 1:
                mDic=@{@"mentou1":[self imgDataForString:(UIImage *)_imgsMentou[0]]};
                break;
            case 2:
                mDic=@{@"mentou1":[self imgDataForString:(UIImage *)_imgsMentou[0]],
                       @"mentou2":[self imgDataForString:(UIImage *)_imgsMentou[1]]};
                break;
            case 3:
                mDic=@{@"mentou1":[self imgDataForString:(UIImage *)_imgsMentou[0]],
                       @"mentou2":[self imgDataForString:(UIImage *)_imgsMentou[1]],
                       @"mentou3":[self imgDataForString:(UIImage *)_imgsMentou[2]]};
                break;
                
            default:
                break;
        }
        
//        NSString * sMentou1;
//        NSString * sMentou2;
//        NSString * sMentou3;
//        sMentou1=[self imgDataForString:(UIImage *)_imgsMentou[0]];
//        sMentou2=[self imgDataForString:(UIImage *)_imgsMentou[1]];
//        sMentou3=[self imgDataForString:(UIImage *)_imgsMentou[2]];
      
        
        

        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"sheng"]] isEmptyString]) {
            [self showPromptBoxWithSting:@"请选择省份"];
            return;
        }
        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"city"]] isEmptyString]) {
            [self showPromptBoxWithSting:@"请选择市"];
            return;
        }
        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"xian"]] isEmptyString]) {
            [self showPromptBoxWithSting:@"请选择县"];
            return;
        }
        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"address"]]  isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入地址"];
            return;
        }
        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"Lng"]]  isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入经纬度"];
            return;
        }
        if ([[NSString stringWithFormat:@"%@",_GeoDic[@"Lat"]]  isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入经纬度"];
            return;
        }
        if ([_labelGeo.text isEmptyString]) {
            [self showPromptBoxWithSting:@"请输入地址"];
            return;
        }
        
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithDictionary:
                                   @{@"uid":sUid,
                                     @"person":sPer,
                                     @"tel":sTel,
                                     @"Bussname":sBuss,
                                     @"sfzz":sfzzS,
                                     @"sfzf":sfzfS,
                                     @"yyzz":sYyzz,
                                     @"zzzs":sZzzs,
                                     }];
        [dic addEntriesFromDictionary:mDic];
        

        [dic addEntriesFromDictionary:_GeoDic];
        
        [self startAnimating:nil];
        [AnalyzeObject kaiDianWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {

                [self showSAlertTitle:@"提示" Message:@"申请成功，请等待审核！" Delegate:self block:^(NSInteger index) {
                       [self.appdelegate switchRootController];
                }];

            }else{
                [self showPromptBoxWithSting:msg];
            }
//            [self showSAlertTitle:@"提示" Message:@"申请成功，请等待审核！" Delegate:self block:^(NSInteger index) {
//                [self.appdelegate switchRootController];
//            }];
        }];
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- photo  delegate
-(void)choosePhoto:(UITapGestureRecognizer *)tap{
    [self dismissKey];
    _isM=NO;
    _currentImgView=(UIImageView *)(tap.view);
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
//            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
    }else if (buttonIndex==1){
        if (_isM) {
            ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
            pickerVc.status = PickerViewShowStatusGroup;
            pickerVc.minCount=3-_imgsMentou.count;
            [pickerVc show];
            
            
            pickerVc.callBack = ^(NSArray *assets){
                if (_imgsMentou.count>=3) {
                    [self ShowAlertWithMessage:@"最多只能添加三张图片！"];
                    return ;
                }
                for (ALAsset *  asset in assets) {
                    ZLPickerBrowserPhoto *phao = [ZLPickerBrowserPhoto photoAnyImageObjWith:asset];
                    [_imgsMentou addObject:phao.photoImage];
                }
                [self reshImgMentView];
                //        [self reshImgView];
            };
        }else{
            UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = sourceType;
//                picker.allowsEditing=YES;
                [self presentViewController:picker animated:YES completion:nil];
            }else
            {
                NSLog(@"无法调用相册");
            }
        }
 
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (_isM) {
        if (_imgsMentou.count>=3) {
            [self ShowAlertWithMessage:@"图片最多只能3张!"];
            return;
        }
        [_imgsMentou addObject:info[UIImagePickerControllerOriginalImage]];
        [self reshImgMentView];
    }else{
        if (_currentImgView.tag==1002) {
            _isZheng=YES;
        }
        
        if (_currentImgView.tag==1003) {
            _isFan=YES;
        }
        
        if (_currentImgView.tag==1050) {
            _isyyzz=YES;
        }
        if (_currentImgView.tag==1051) {
            _iszzzs=YES;
        }
        
        
        _currentImgView.image=info[UIImagePickerControllerOriginalImage];
       
    }
     [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)imgDataForString:(UIImage *)image{
    NSString *encodedImageStr=@"";
//    float scale = 1.0;
//    if (image.size.width>800) {
//        scale = 800/image.size.width;
//    }else{
//        scale= 1.0;
//    }
    UIImage *im = [self scaleImage:image scaleFactor:0];

    NSData *data= UIImageJPEGRepresentation(im, .7);
    encodedImageStr=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
#pragma mark--------图片按比例压缩，
-(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy
{
 
    if (image.size.width>1000) {
        scaleBy = 1000/image.size.width;
    }else{
        scaleBy= 1.0;
    }
    CGSize size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleBy, scaleBy);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self dismissKey];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag>=1000) {
        NSString * string1=@"[0-9a-zA-Z]+";
        NSPredicate *rege = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string1];
        if ([rege evaluateWithObject:newString]||[newString isEmptyString]) {
            return YES;
        }
        return  NO;
    }else{
        return YES;
//       4 return  [newString isValidateNum]||[newString isEmptyString];
        
    }

}
//#pragma  mark -0-
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==0) {
//        [self.appdelegate switchRootController];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
