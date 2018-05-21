//
//  UIImage+LiLCrop.m
//  LiLSampleTool
//
//  Created by lilei on 2018/5/18.
//  Copyright © 2018年 lilei. All rights reserved.
//

#import "UIImage+LiLCrop.h"

@implementation UIImage (LiLCrop)
- (UIImage *)croppedImageWithFrame:(CGRect)frame scale:(CGFloat)scale
{
    UIImage *croppedImage = nil;
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
        [self drawAtPoint:CGPointZero];
        
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:croppedImage.CGImage scale:scale orientation:UIImageOrientationUp];
}
@end
