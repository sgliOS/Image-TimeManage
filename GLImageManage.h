//
//  GLImageManage.h
//  pinLuCarService
//
//  Created by sgl on 16/6/8.
//  Copyright © 2016年 PinLu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_MTHKImage_SizeLimit_Max       800
#define K_MTHKImage_AvatarSizeLimit_Max 320
#define K_MTHKImage_Extension_PNG       @"png"
#define K_MTHKImage_Extension_JPG       @"jpg"

@interface GLImageManage : NSObject

+(GLImageManage*)ShareImage;

-(UIImage*)pngImageNamed:(NSString*)imageName;

// 居中剪裁
-(UIImage*)centerCropImage:(UIImage *)imgTemp toSize:(CGSize)size;
//等比例缩放(限制最大宽度和最大高度)
-(UIImage*)scaleImg:(UIImage *)imgTemp LimitMaxWidth:(float)limitWidth LimitMaxHeight:(float)limitHeight;
// 调整图片角度
-(UIImage*)OrientationImageFromImage:(UIImage*)tmpImage;
// 获取网络图片Size
+(CGSize)downloadImageSizeWithURL:(id)imageURL;
// 给图片去背景色
-(void)removeBgColor:(uint32_t*)colors PixCount:(int)count FromColor:(uint32_t)from ToColor:(uint32_t)to;
// 缩放图片
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
// 高斯模糊
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
// 从当前界面得到image
- (UIImage *)imageFromView: (UIView *) theView;

//点击图片放大
-(void)showImage:(UIImageView *)avatarImageView OldFrame:(CGRect)oldframe;

@end
