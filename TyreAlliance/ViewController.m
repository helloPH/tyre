//
//  ViewController.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "ViewController.h"
#import "CellView.h"

#import "GoodsManage.h"
#import "EvaluateManage.h"
#import "FinanceManage.h"
#import "OrderManage.h"
#import "SalesStatistics.h"
#import "RecomMan.h"
#import "MessageCenter.h"
#import "MyTwoCode.h"
#import "WithDrawRecord.h"
#import "SettingCenter.h"





@interface ViewController()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSArray * datas;
@property (nonatomic,strong)UIImageView * headImg;

@end
@implementation ViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[Stockpile sharedStockpile] setID:@"1"];

    [self newView];
    
    
    

    
//  [[NSUserDefaults standardUserDefaults]setValue:@(NO) forKey:@"isLogin"];
    
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    CGFloat setY=0;
    
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, Vwidth/2.0)];
    imgView.image=[UIImage ImageForColor:navigationControllerColor];
    imgView.userInteractionEnabled=YES;
    [_scrollView addSubview:imgView];
    
    
    UIButton * headBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Vwidth/5, Vwidth/5+20*self.scale)];
    [imgView addSubview:headBtn];
    headBtn.center=imgView.center;

    
    
    _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headBtn.width, headBtn.width)];
    _headImg.layer.cornerRadius=_headImg.width/2;
    _headImg.layer.masksToBounds=YES;
    _headImg.layer.borderColor=[UIColor whiteColor].CGColor;
    _headImg.layer.borderWidth=2;
    [headBtn addSubview:_headImg];
    [_headImg setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[Stockpile sharedStockpile].logo]] placeholderImage:[UIImage imageNamed:@"touxiang_t"]];
//    _headImg.image=[UIImage imageNamed:@"touxiang_t"];
//    [_headImg setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"touxiang_t"]];
    _headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
    [_headImg addGestureRecognizer:tap];
    
    UILabel * headLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, _headImg.bottom, headBtn.width, headBtn.height-_headImg.height)];
    headLabel.textAlignment=NSTextAlignmentCenter;
    headLabel.textColor=[UIColor whiteColor];
    headLabel.text=@"--";
    headLabel.text=[Stockpile sharedStockpile].Name;
    [headBtn addSubview:headLabel];
    
    _datas=@[@{@"title":@"商品管理",@"imgUrl":@"shangpin_guanli",@"controller":NSStringFromClass([GoodsManage class])},
                      @{@"title":@"评价管理",@"imgUrl":@"pingjia_guanli",@"controller":NSStringFromClass([EvaluateManage class])},
                      @{@"title":@"财务管理",@"imgUrl":@"caiwu_gl",@"controller":NSStringFromClass([FinanceManage class])},
                      @{@"title":@"订单管理",@"imgUrl":@"dingdan_gl",@"controller":NSStringFromClass([OrderManage class])},
                      @{@"title":@"销售统计",@"imgUrl":@"xiaoshou_gl",@"controller":NSStringFromClass([SalesStatistics class])},
                      @{@"title":@"推荐的人",@"imgUrl":@"tuijian_gl",@"controller":NSStringFromClass([RecomMan class])},
                      @{@"title":@"消息中心",@"imgUrl":@"xiaoxi_gl",@"controller":NSStringFromClass([MessageCenter class])},
                      @{@"title":@"我的二维码",@"imgUrl":@"erweima",@"controller":NSStringFromClass([MyTwoCode class])},
//                      @{@"title":@"提现记录",@"imgUrl":@"",@"controller":NSStringFromClass([WithDrawRecord class])},
                      @{@"title":@"设置",@"imgUrl":@"shezhi_gl",@"controller":NSStringFromClass([SettingCenter class])}
                   ];

    CGFloat cellH=40*self.scale;
    for (int i = 0; i < _datas.count; i++ ) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, imgView.bottom+10*self.scale + i * cellH, Vwidth, cellH)];
        [_scrollView addSubview:cellView];
        UIImageView * leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 0, cellH-20*self.scale, cellH-20*self.scale)];
        leftImg.centerY=cellView.height/2;
//        leftImg.backgroundColor=[UIColor grayColor];
        leftImg.image=[UIImage imageNamed:[_datas[i] valueForKey:@"imgUrl"]];
        leftImg.layer.cornerRadius=5*self.scale;
        leftImg.layer.masksToBounds=YES;
        [cellView addSubview:leftImg];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(leftImg.right+5*self.scale, leftImg.top, 100*self.scale, leftImg.height)];
        label.font=DefaultFont(self.scale);
        label.textAlignment=NSTextAlignmentLeft;
        label.textColor=blackTextColor;
        label.text=[_datas[i] valueForKey:@"title"];
        [cellView addSubview:label];
        
        [cellView ShowRight:YES];
        cellView.btn.tag=100+i;
        [cellView.btn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
        
        setY=cellView.bottom;
    }
    
    _scrollView.contentSize=CGSizeMake(_scrollView.width, setY);
}
-(void)skip:(UIButton *)sender{
    
//    UIViewController *vi = (UIViewController *)[NSClassFromString([_datas[sender.tag-100] valueForKey:@"controller"]) new];
    
    
    switch (sender.tag-100) {
        case 0://商品管理
        {
            GoodsManage * goods=[GoodsManage new];
            goods.TitleLabel.text=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:goods animated:YES];
                
        }
            break;
        case 1://评价管理
        {
            EvaluateManage * evaluate=[EvaluateManage new];
            evaluate.TitleLabel.text=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:evaluate animated:YES];
        }
            break;
        case 2://财务管理
        {
            FinanceManage * finance = [FinanceManage new];
            finance.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:finance animated:YES];
            
        }
            
            break;
        case 3://订单管理
        {
            OrderManage * order = [OrderManage new];
            order.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:order animated:YES];
            
        }
            break;
        case 4://销售统计
        {
            SalesStatistics * sale =[SalesStatistics new];
            sale.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:sale animated:YES];
            
        }
            break;
        case 5://推荐的人
        {
            RecomMan * recom=[RecomMan new];
            recom.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:recom animated:YES];
        }
            break;
        case 6://消息中心
        {
            MessageCenter * message = [MessageCenter new];
            message.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case 7://我的二维码
        {
            MyTwoCode * twoCode=[MyTwoCode new];
            [self.navigationController pushViewController:twoCode animated:YES];
            
        }
            break;
//        case 8://提现记录
//        {
//            WithDrawRecord * twoCode=[WithDrawRecord new];
//            [self.navigationController pushViewController:twoCode animated:YES];
//        }
//            break;
        case 8://设置
        {
            SettingCenter * set = [SettingCenter new];
            set.title=[_datas[sender.tag-100] valueForKey:@"title"];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
        default:
            break;
    }
    
    
    
//    [self.navigationController pushViewController:vi animated:YES];
}
-(void)choosePhoto:(UITapGestureRecognizer *)tap{
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"拍照");
        UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing=YES;
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
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            [self showPromptBoxWithSting:@"无法调用相册"];
//            NSLog(@"无法调用相册");
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"logo":[self imgDataForString:info[UIImagePickerControllerEditedImage]],
                         };
    [AnalyzeObject setPerInfoWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        
        if ([ret isEqualToString:@"1"]) {
            [[Stockpile sharedStockpile]setLogo:[ImgDuanKou stringByAppendingString:model[@"ulogo"]]];
            [_headImg setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[Stockpile sharedStockpile].logo]]];
            [self showPromptInWindowWithString:@"头像修改成功!"];
        }else{
            [self showPromptInWindowWithString:@"头像修改失败!"];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    
        
    }];
    
    
//    _headImg.image=info[UIImagePickerControllerEditedImage];
 
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

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
@end
