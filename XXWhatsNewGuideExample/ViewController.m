//
//  ViewController.m
//  XXWhatsNewGuideExample
//
//  Created by 许洵 on 2018/7/31.
//  Copyright © 2018年 com.vcredit. All rights reserved.
//

#import "ViewController.h"
#import "XXWhatsNewGuide.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // MARK: - 设置引导第一步
    GuideCase *case1 = [XXWhatsNewGuide giveMeACaseWithKey:@"32"];
    //设置蒙版透明度
    case1.maskAlpha = 0.75;
    
    //指定某个view进行高亮
    GuideView *case1_gv1 = [case1 addViewByCloneView:self.imgView1];
    //在引导蒙板上添加视图
    UILabel *case1_lab = [[UILabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(case1_gv1.view.frame)+40, 150, 40)];
    case1_lab.text = @"这是引导说明";
    case1_lab.textColor = [UIColor whiteColor];
    GuideView *case1_gv2 = [case1 addView:case1_lab];
    
    UIButton *case1_btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(case1_gv2.view.frame)+40, CGRectGetMinY(case1_gv2.view.frame), 100, 40)];
    [case1_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [case1_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    case1_btn.backgroundColor = [UIColor blueColor];
    GuideView *case1_gv3 = [case1 addView:case1_btn];
    
    // MARK: - 设置引导第二步
    GuideCase *case2 = [XXWhatsNewGuide giveMeACaseWithKey:@"33"];
    case2.maskAlpha = 0.75;
    
    GuideView *case2_gv1 = [case2 addViewByCloneView:self.imgView1];
    //指定区域进行高亮
    [case2 hollowout:CGRectMake(CGRectGetMaxX(case2_gv1.view.frame)+20, CGRectGetMinY(case2_gv1.view.frame), 160, 90) type:(HollowoutTypeOval) radius:0];
    
    UIImage *case2_img = [UIImage imageNamed:@"3"];
    GuideView *case2_gv2 = [case2 addViewWithImage:case2_img frame:CGRectMake(CGRectGetMinX(case2_gv1.view.frame), CGRectGetMaxY(case2_gv1.view.frame)+30, case2_img.size.width,  case2_img.size.height)];
    
    UIButton *case2_btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(case2_gv2.view.frame), CGRectGetMaxY(case2_gv2.view.frame)+30, 100, 40)];
    [case2_btn setTitle:@"知道了" forState:UIControlStateNormal];
    [case2_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    case2_btn.backgroundColor = [UIColor blueColor];
    GuideView *case2_gv3 = [case2 addView:case2_btn];
    
    // MARK: - 设置引导动作
    //点击下一步
//    [case1_gv3 addActionForNextCase:case2];
    [case1 addFullScreenActionForNextCase:case2];
    //点击消失
//    [case2_gv3 addActionForDismiss];
    [case2 addFullScreenActionForDismiss];
    
    // MARK: - 显示引导
    [case1 show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
