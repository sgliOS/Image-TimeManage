//
//  GLImageManage.m
//  pinLuCarService
//
//  Created by sgl on 16/6/8.
//  Copyright © 2016年 PinLu. All rights reserved.
//

#import "GLImageManage.h"

@implementation GLImageManage

static GLImageManage *imageManage =nil;
+(GLImageManage*)ShareImage
{
    if (nil== imageManage) {
        imageManage = [[GLImageManage alloc] init];
    }
    return imageManage;
}

-(UIImage*)pngImageNamed:(NSString *)imageName
{
    if (imageName&&[imageName isKindOfClass:[NSString class]]&&[imageName length]>0) {
        UIImage *imaged = [UIImage imageNamed:imageName];
        if (imaged) {
            if ([imaged respondsToSelector:@selector(imageWithRenderingMode:)]) {
                return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            return imaged;
        }
        return nil;
    }
    else {
        WarningLog(@"imageName:%@",imageName);
        return nil;
    }
}

// 居中剪裁
-(UIImage*)centerCropImage:(UIImage *)imgTemp toSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(imgTemp.CGImage);
    CGFloat height = CGImageGetHeight(imgTemp.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if (verticalRadio>=1||horizontalRadio>=1) {
        return imgTemp;
    }
    
    radio = verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio;
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [imgTemp drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
//等比例缩放
-(UIImage*)scaleImg:(UIImage *)imgTemp LimitMaxWidth:(float)limitWidth LimitMaxHeight:(float)limitHeight
{
    CGFloat width = CGImageGetWidth(imgTemp.CGImage);
    CGFloat height = CGImageGetHeight(imgTemp.CGImage);
    
    float verticalRadio = limitHeight*1.0/height;
    float horizontalRadio = limitWidth*1.0/width;
    
    float radio = 1;
    if (verticalRadio>=1||horizontalRadio>=1) {
        return imgTemp;
    }
    
    radio = verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio;
    
    width = width*radio;
    height = height*radio;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // 绘制改变大小的图片
    [imgTemp drawInRect:CGRectMake(0, 0, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
// 调整图片角度
-(UIImage*)OrientationImageFromImage:(UIImage*)tmpImage
{
    UIImage* contextedImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (tmpImage.imageOrientation == UIImageOrientationUp) {
        contextedImage = tmpImage;
    }
    else{
        switch (tmpImage.imageOrientation ) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, tmpImage.size.width, tmpImage.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0,tmpImage.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        switch (tmpImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, tmpImage.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, tmpImage.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        CGContextRef ctx = CGBitmapContextCreate(NULL, tmpImage.size.width, tmpImage.size.height, CGImageGetBitsPerComponent(tmpImage.CGImage), 0, CGImageGetColorSpace(tmpImage.CGImage), CGImageGetBitmapInfo(tmpImage.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (tmpImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.height,tmpImage.size.width), tmpImage.CGImage);
                break;
            default:
                CGContextDrawImage(ctx, CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height), tmpImage.CGImage);
                break;
        }
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        contextedImage = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    return contextedImage;
}

+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    NSString* absoluteString = URL.absoluteString;
    
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            return CGSizeZero;
        }
        return image.size;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
// 缩放图片
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


#pragma 给图片去背景色
#define R32_SHIFT   0
#define G32_SHIFT   8
#define B32_SHIFT   16
#define A32_SHIFT   24

#define GetPackedA32(packed) ((uint32_t)((packed) << (24 - A32_SHIFT)) >> 24)
#define GetPackedR32(packed) ((uint32_t)((packed) << (24 - R32_SHIFT)) >> 24)
#define GetPackedG32(packed) ((uint32_t)((packed) << (24 - G32_SHIFT)) >> 24)
#define GetPackedB32(packed) ((uint32_t)((packed) << (24 - B32_SHIFT)) >> 24)

/** return the alpha byte from a SkColor value */
#define ColorGetA(color)      (((color) >> 24) & 0xFF)
/** return the red byte from a SkColor value */
#define ColorGetR(color)      (((color) >> 16) & 0xFF)
/** return the green byte from a SkColor value */
#define ColorGetG(color)      (((color) >>  8) & 0xFF)
/** return the blue byte from a SkColor value */
#define ColorGetB(color)      (((color) >>  0) & 0xFF)

#define MulS16(x, y)  ((x) * (y))

#define AlphaMul(value, alpha256)     (MulS16(value, alpha256) >> 8)

static inline int max(int x, int y)
{
    int r = x ^ ((x ^ y) & -(x < y));
    return r;
}

static inline uint32_t PackARGB32(unsigned a, unsigned r, unsigned g, unsigned b)
{
    return (a << A32_SHIFT) | (r << R32_SHIFT) |
    (g << G32_SHIFT) | (b << B32_SHIFT);
}

static inline int AlphaBlend(int src, int dst, int scale256)
{
    return dst + AlphaMul(src - dst, scale256);
}

static inline uint32_t FourByteInterp256(uint32_t src, uint32_t dst, unsigned scale)
{
    unsigned a = AlphaBlend(GetPackedA32(src), GetPackedA32(dst), scale);
    unsigned r = AlphaBlend(GetPackedR32(src), GetPackedR32(dst), scale);
    unsigned g = AlphaBlend(GetPackedG32(src), GetPackedG32(dst), scale);
    unsigned b = AlphaBlend(GetPackedB32(src), GetPackedB32(dst), scale);
    
    return PackARGB32(a, r, g, b);
}

// returns 0..255
static unsigned color_dist32(uint32_t c, unsigned r, unsigned g, unsigned b)
{
    unsigned dr = (GetPackedR32(c) - r);
    unsigned dg = (GetPackedG32(c) - g);
    unsigned db = (GetPackedB32(c) - b);
    
    return max(dr, max(dg, db));
}

static int scale_dist_14(int dist, uint32_t mul, uint32_t sub)
{
    int tmp = dist * mul - sub;
    int result = (tmp + (1 << 13)) >> 14;
    
    return result;
}

static inline unsigned Accurate255To256(unsigned x) {
    return x + (x >> 7);
}

void imageBgRemove(uint32_t colors[], int count, uint32_t from, uint32_t to)
{
    unsigned opR = ColorGetR(from);
    unsigned opG = ColorGetG(from);
    unsigned opB = ColorGetB(from);
    uint32_t mul = (256 << 14) / (255 + 1);	// 1 << 14
    uint32_t sub = (mul - (1 << 14)) << 8;	// 0
    
    int MAX = 255;
    int mask = -1;
    
    int i = 0;
    for (; i < count; i++) {
        int d = color_dist32(colors[i], opR, opG, opB);
        // now reverse d if we need to
        d = MAX + (d ^ mask) - mask;	// 255 - d
        d = Accurate255To256(d);
        
        d = scale_dist_14(d, mul, sub);
        
        if (d > 0) {
            colors[i] = FourByteInterp256(to, colors[i], d);
        }
    }
}

// 给图片去背景色
-(void)removeBgColor:(uint32_t*)colors PixCount:(int)count FromColor:(uint32_t)from ToColor:(uint32_t)to
{
    imageBgRemove(colors, count, from, to);
}

#pragma mark - 高斯模糊
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil,nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}
#pragma mark - 从当前视图得到Image
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
#pragma mark - 点击图片放大
-(void)showImage:(UIImageView *)avatarImageView OldFrame:(CGRect)oldframe{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:OldFrame:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideImage:(UITapGestureRecognizer*)tap OldFrame:(CGRect)oldframe{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end

