//
//  UIImage+LiLCrop.h
//  LiLSampleTool
//
//  Created by lilei on 2018/5/18.
//  Copyright © 2018年 lilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LiLCrop)
- (UIImage *)croppedImageWithFrame:(CGRect)frame scale:(CGFloat)scale;
@end
