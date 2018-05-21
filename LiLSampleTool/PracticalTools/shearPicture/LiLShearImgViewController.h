//
//  LiLShearImgViewController.h
//  LiLSampleTool
//
//  Created by lilei on 2018/5/17.
//  Copyright © 2018年 lilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiLShearImageDelegate<NSObject>
@required
-(void)shearImageSuccess:(UIImage *)image;
-(void)shearImageCancel;
@end

@interface LiLShearImgViewController : UIViewController
@property(nonatomic,assign)BOOL hideNav;//是否隐藏导航栏
@property(nonatomic,assign)BOOL isFill;//是否填充整个屏幕
@property(nonatomic,strong)UIImage *sourceImg;//原图
@property(nonatomic,weak)id<LiLShearImageDelegate> delegate;
@end
