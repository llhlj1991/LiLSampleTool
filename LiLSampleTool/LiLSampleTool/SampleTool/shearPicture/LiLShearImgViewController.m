//
//  LiLShearImgViewController.m
//  LiLSampleTool
//
//  Created by lilei on 2018/5/17.
//  Copyright © 2018年 lilei. All rights reserved.
//

#import "LiLShearImgViewController.h"
#import "UIImage+LiLCrop.h"
@interface LiLShearImgViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)CALayer *shadeLayer;
@property(nonatomic,strong)CALayer *cropBoxLayer;
@end
static const CGFloat cropBoxWidth = 200;
static const CGFloat cropBoxHeight = 200;
@implementation LiLShearImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self commonUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController && self.hideNav) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController && self.hideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
-(void)commonUI{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    if (self.navigationController && !self.hideNav) {
        height -= 64;
    }
    CGFloat bottomHeight = 50;
    height -= bottomHeight;
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, height + 10, 60, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-60-30,height + 10, 60, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.imgView = [[UIImageView alloc]initWithFrame:self.scrollView.bounds];
    self.imgView.image = self.sourceImg;
    [self.scrollView addSubview:self.imgView];
    
    self.shadeLayer = [[CALayer alloc]init];
    self.shadeLayer.frame = self.scrollView.frame;
    self.shadeLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    [self.view.layer addSublayer:self.shadeLayer];
    
    self.cropBoxLayer = [[CALayer alloc]init];
    self.cropBoxLayer.frame = CGRectMake((width-cropBoxWidth)/2, (height-cropBoxHeight)/2, cropBoxWidth, cropBoxHeight);
    self.cropBoxLayer.borderWidth = 1;
    self.cropBoxLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.cropBoxLayer.borderColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:self.cropBoxLayer];
    
    [self changeVisibleAreaWithShadeLayer:self.shadeLayer cropBoxLayer:self.cropBoxLayer];
    
    [self adjustSize];
    
}

/**
 改变可视区域

 @param shadeLayer 遮罩层
 @param cropBoxLayer 可视区
 */
- (void)changeVisibleAreaWithShadeLayer:(CALayer*)shadeLayer cropBoxLayer:(CALayer *)cropBoxLayer{
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame         = shadeLayer.bounds;
    mask.fillRule      = kCAFillRuleEvenOdd;
    mask.fillColor     = [UIColor blackColor].CGColor;
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathAddRect(maskPath, NULL, mask.frame);
    CGPathAddRect(maskPath, NULL, cropBoxLayer.frame);
    mask.path = maskPath;
    CGPathRelease(maskPath);
    shadeLayer.mask = mask;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}

/**
 自适应内容
 */
-(void)adjustSize{
    CGSize imgSize = self.sourceImg.size;
    CGSize viewSize = self.scrollView.bounds.size;
    self.imgView.frame = (CGRect){0,0,imgSize};
    CGSize cropBoxSize = self.cropBoxLayer.bounds.size;
    CGFloat minScale = MAX(cropBoxSize.width/imgSize.width, cropBoxSize.height/imgSize.height);
    CGFloat maxScale = MAX(viewSize.width/imgSize.width, viewSize.height/imgSize.height);
    CGFloat realScale = maxScale;
    if (!self.isFill) {
        if (minScale > 1) {
            realScale = minScale;
        }else if (maxScale >1){
            realScale = 1;
        }
    }
    CGSize realSize = CGSizeMake(floor(imgSize.width*realScale), floor(imgSize.height*realScale));
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = maxScale*1.5;
    self.scrollView.zoomScale = realScale;
    self.scrollView.contentSize = realSize;
    
    if (realSize.width > cropBoxSize.width || realSize.height > cropBoxSize.height) {
        self.scrollView.contentOffset = CGPointMake(-(viewSize.width-realSize.width)*0.5, -(viewSize.height-realSize.height)*0.5);
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake((viewSize.height-cropBoxHeight)/2,(viewSize.width-cropBoxWidth)/2 ,(viewSize.height-cropBoxHeight)/2, (viewSize.width-cropBoxWidth)/2);
    
}

/**
 找到图片剪切区域

 @return 剪切区域
 */
- (CGRect)imageCropFrame
{
    CGSize imageSize = self.imgView.image.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGRect cropBoxFrame = self.cropBoxLayer.frame;
    CGPoint contentOffset = self.scrollView.contentOffset;
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    
    CGRect frame = CGRectZero;
    frame.origin.x = floorf((contentOffset.x + edgeInsets.left) * (imageSize.width / contentSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    
    frame.origin.y = floorf((contentOffset.y + edgeInsets.top) * (imageSize.height / contentSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    
    frame.size.width = ceilf(cropBoxFrame.size.width * (imageSize.width / contentSize.width));
    frame.size.width = MIN(imageSize.width, frame.size.width);
    
    frame.size.height = ceilf(cropBoxFrame.size.height * (imageSize.height / contentSize.height));
    frame.size.height = MIN(imageSize.height, frame.size.height);
    
    return frame;
}

/**
 根据剪切区域剪切图片

 @param sourceImage 原图
 @param frame 剪切区域
 @return 剪切后图片
 */
-(UIImage *)getImageFromImage:(UIImage*)sourceImage frame:(CGRect)frame{
    CGImageRef cropImageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, frame);
    UIImage *image = [UIImage imageWithCGImage:cropImageRef scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(cropImageRef);
    return image;
}
-(void)cancelClick{
    if (self.navigationController && self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)sureClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shearImageSuccess:)]) {
        UIImage *image = [self.sourceImg croppedImageWithFrame:[self imageCropFrame] scale:1.0];
        [self.delegate shearImageSuccess:image];
    }
    [self cancelClick];
}
@end
