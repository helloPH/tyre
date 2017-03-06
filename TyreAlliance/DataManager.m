//
//  DataManager.m
//  TyreAlliance
//
//  Created by wdx on 2016/12/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "DataManager.h"
#import "ZLPickerBrowserPhoto.h"
#import "ZLPickerBrowserViewController.h"
#import "GetLocationFromBMap.h"

@interface DataManager ()<ZLPickerBrowserViewControllerDelegate,ZLPickerBrowserViewControllerDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>


@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UILabel * addressLabel;
@property (nonatomic,strong)UILabel * locationLabel;
@property (nonatomic,strong)UITextField * tfPerson;
@property (nonatomic,strong)UITextField * tfTel;

@property (nonatomic,strong)UIImageView * currentImg;
@property (nonatomic,strong)CellView * menBgView;


@property (nonatomic,strong)NSMutableArray * showImgs;
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * menKeys;

@property (nonatomic,assign)BOOL isChangeMen;
@end

@implementation DataManager

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
//    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _isChangeMen=NO;
    _menKeys=[NSMutableArray array];
    _showImgs=[NSMutableArray array];
    _dataDic=[NSMutableDictionary dictionary];
}
-(void)newNavi{
    
    self.TitleLabel.text=@"商家资料";
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
   NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    
    [self startAnimating:nil];
   [AnalyzeObject kaiDianInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
       [self stopAnimating];
       if([ret isEqualToString:@"1"]){
              [_dataDic removeAllObjects];
              [_dataDic addEntriesFromDictionary:model];
       }else{
           [self showPromptBoxWithSting:msg];
       }
       [self newView];
           }];
    
}

-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    [self.view addSubview:_scrollView];

    NSArray * arrayTitles=@[@{@"title":@"店铺名称",@"place":[[NSString stringWithFormat:@"%@",_dataDic[@"name"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",_dataDic[@"name"]]},
                            
                      @{@"title":@"联系人",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"person"]]},
                            
                      @{@"title":@"电话",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"tel"]]},
                            
                      @{@"title":@"身份证正反面照",@"place":@""},
                      @{@"title":@"营业执照",@"place":@""},
                      @{@"title":@"资质证书",@"place":@""},
                      @{@"title":@"店铺门头（长按可修改）",@"place":@""},
                      @{@"title":@"店铺地址",@"place":[NSString stringWithFormat:@"%@ %@ %@",_dataDic[@"sheng"],_dataDic[@"city"],_dataDic[@"xian"]]},
                            
                      @{@"title":@"地图位置",@"place":[NSString stringWithFormat:@"%@",_dataDic[@"address"]]}];
    
    CGFloat setY=10*self.scale;
    for (int i = 0 ; i < arrayTitles.count; i ++) {
        CellView * cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cell];
        
        NSDictionary * dic=arrayTitles[i];
        cell.titleLabel.text=[NSString stringWithFormat:@"%@",dic[@"title"]];
        [cell.titleLabel sizeToFit];
        cell.titleLabel.centerY=cell.height/2;
        
       
        
        if (i==arrayTitles.count-2) {
            cell.contentLabel.textAlignment=NSTextAlignmentRight;
            _addressLabel=cell.contentLabel;
            
        }
        if (i==arrayTitles.count-1) {
            cell.contentLabel.textAlignment=NSTextAlignmentRight;
            [cell ShowRight:YES];
            cell.contentLabel.right=cell.RightImg.left-5*self.scale;
            [cell.btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
            _locationLabel=cell.contentLabel;
        }
        
        
        
        cell.contentLabel.textColor=grayTextColor;
        cell.contentLabel.text=[[NSString stringWithFormat:@"%@",dic[@"place"]] isEmptyString]?@"":[NSString stringWithFormat:@"%@",dic[@"place"]];
        
        UITextField * tf=[UITextField new];
        tf.frame=cell.contentLabel.frame;
        tf.textColor=blackTextColor;
        tf.font=DefaultFont(self.scale);
        cell.contentLabel.hidden=YES;
        [cell addSubview:tf];
        tf.text=cell.contentLabel.text;
        tf.enabled=NO;
        if (i==1) {
            tf.clearButtonMode=UITextFieldViewModeAlways;
            tf.enabled=YES;
            _tfPerson=tf;
        }
        if ( i==2) {
            
            tf.clearButtonMode=UITextFieldViewModeAlways;
            tf.enabled=YES;
            _tfTel=tf;
        }
        if (i==7 || i==8){
            tf.textAlignment=NSTextAlignmentRight;
        }
        
        
        if (i==3 || i==4 || i==5 || i==6) {
            cell.titleLabel.centerY=cell.contentLabel.centerY;
            NSInteger count;
            CGFloat Imargin = 0.0;
            CGFloat Iw = 0.0;
            CGFloat Ih = 0.0;
            CGFloat IXs = 0.0;
            CGFloat IYs = 0.0;
            
            NSInteger column = 0;
            
           
            column=3;
            Imargin=30*self.scale;
            IXs=10*self.scale;
            IYs=10*self.scale;
            
            Iw=(Vwidth-Imargin*2 - (column-1)*IXs+20*self.scale)/column;
            Ih=Iw*0.75;
            
//            NSMutableArray * menKeys=[NSMutableArray array];
            [_menKeys removeAllObjects];
            switch (i) {
                case 3:
                     count=2;
                    break;
                 case 4:
                    count=1;
                    break;
                    case 5:
                    count=1;
                    break;
                case 6:{
                    
               
                    for (NSString * key in _dataDic.allKeys) {
                        if ([key isKindOfClass:[NSString class]]) {
                            if ([key hasPrefix:@"mentou"]) {
                                [_menKeys addObject:key];
                            }
                        }
                    }
                    count=_menKeys.count;
                     }
                    break;
                default:
                    break;
            }
            
            
            for (int j =0; j < count; j ++) {
                CGFloat Ix =Imargin+(Iw + IXs)*(j%column);
                CGFloat Iy = cell.titleLabel.bottom + 20*self.scale+ (Ih + IYs)*(j/column);
                
                UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Ix, Iy, Iw, Ih)];
                imgView.contentMode=UIViewContentModeScaleAspectFill;
                imgView.layer.masksToBounds=YES;
                [cell addSubview:imgView];
                
                
                imgView.tag=i*100+j;
                imgView.userInteractionEnabled=YES;
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBrower:)];
                [imgView addGestureRecognizer:tap];
                
                
                switch (i) {
                    case 3:
                        if (j==0) {
                            [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"sfzz"]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
                        }else{
                            [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"sfzf"]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
                        }
                        break;
                    case 4:
                         [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"yyzz"]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
                        break;
                    case 5:
                         [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"zzzs"]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
                        break;
                    case 6:
                        {
                            _menBgView=cell;
                            NSString * menKey= _menKeys[j];
                              [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[menKey]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
                            UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                            [imgView addGestureRecognizer:longPress];
                       }
                        break;
                    default:
                        break;
                }
                
                
                cell.height=imgView.bottom+IYs;
                
            }
        }
        setY=cell.bottom;
    }
    
    
    UIButton * submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+20*self.scale, Vwidth-20*self.scale, 40*self.scale)];
    submitBtn.tag=1000;
    submitBtn.layer.cornerRadius=5;
    submitBtn.layer.masksToBounds=YES;
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    setY=submitBtn.bottom;
    
    
    _scrollView.contentSize=CGSizeMake(Vwidth, setY+10*self.scale);
}
-(void)btnEvent:(UIButton *)sender{
    if (sender.tag==1000) {
        if ([_tfPerson.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"person"]]]&&
            [_tfTel.text isEqualToString:[NSString stringWithFormat:@"%@",_dataDic[@"tel"]]]&&
            !_isChangeMen) {
            [self showPromptBoxWithSting:@"您还未做任何修改!"];
            return;
        }
        
        
        
        NSDictionary  * dic1=@{@"uid":[Stockpile sharedStockpile].ID,
                               @"person":_tfPerson.text,
                               @"tel":_tfTel.text,
                               };
        
        
        NSMutableDictionary * dic2=[NSMutableDictionary dictionary];
        for (int i = 0 ; i < _menKeys.count; i ++) {
            NSString * key=_menKeys[i];
            UIImageView * imgView=[_menBgView viewWithTag:600+i];
            if ([imgView isKindOfClass:[UIImageView class]]) {
                [dic2 setObject:[self imgDataForString:imgView.image] forKey:key];
            }
        }
        
        
        
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithDictionary:dic2];
        [dic addEntriesFromDictionary:dic1];
        
        
        
        [self startAnimating:@"保存中..."];
        
        [AnalyzeObject upDatePerInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                    [self PopVC:nil];
            }else{
                
            }
                [self showPromptInWindowWithString:msg];
        }];
        return;
    }
    
    
    
    GetLocationFromBMap * get=[GetLocationFromBMap new];
    get.isGet=YES;
    get.addreString=_locationLabel.text;
    [self.navigationController pushViewController:get animated:YES];
    
    

}
-(void)photoBrower:(UITapGestureRecognizer *)tap{
    ZLPickerBrowserViewController * brower=[ZLPickerBrowserViewController new];
    brower.delegate=self;
    brower.dataSource=self;
    brower.currentPage=tap.view.tag%100;
    [_showImgs removeAllObjects];
    switch (tap.view.tag/100) {
        case 3:
        {
            [_showImgs addObjectsFromArray:@[[NSString stringWithFormat:@"%@",_dataDic[@"sfzz"]],[NSString stringWithFormat:@"%@",_dataDic[@"sfzf"]]]];
        }
            break;
        case 4:
        {
            [_showImgs addObjectsFromArray:@[[NSString stringWithFormat:@"%@",_dataDic[@"yyzz"]]]];
        }
            break;
        case 5:
        {
            [_showImgs addObjectsFromArray:@[[NSString stringWithFormat:@"%@",_dataDic[@"zzzs"]]]];
        }
            break;
        case 6:
        {
            for (NSString * key in _menKeys) {
                [_showImgs addObject:[NSString stringWithFormat:@"%@",_dataDic[key]]];
            }
        }
            break;
            
        default:
            break;
    }
    
    
    [self.navigationController pushViewController:brower animated:YES];
    
}
/**
 *  有多少个图片
 */
- (NSInteger) numberOfPhotosInPickerBrowser:(ZLPickerBrowserViewController *) pickerBrowser{
    return _showImgs.count;
}

/**
 *  每个图片展示什么内容
 */
- (ZLPickerBrowserPhoto *)photoBrowser:(ZLPickerBrowserViewController *)pickerBrowser photoAtIndex:(NSUInteger)index{
    NSString * imgString= [NSString stringWithFormat:@"%@%@",ImgDuanKou,_showImgs[index]];
    NSURL * imgUrl=[NSURL URLWithString:imgString];
    ZLPickerBrowserPhoto * photo=[ZLPickerBrowserPhoto photoAnyImageObjWith:imgUrl];
    return photo;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan) {
        _currentImg=(UIImageView *)(longPress.view);
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [action showInView:self.view];
    }    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"拍照");
        UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
//            picker.allowsEditing=YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            
            [self showPromptBoxWithSting:@"模拟器中无法打开照相机,请在真机中使用"];
            //            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
        
        
    }else if (buttonIndex==1){
        NSLog(@"相册");
        UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
//            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            [self showPromptBoxWithSting:@"无法调用相册"];
            //            NSLog(@"无法调用相册");
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   
    _currentImg.image=info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        _isChangeMen=YES;
     }];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
