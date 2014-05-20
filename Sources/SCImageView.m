//
//  SCCIImageView.m
//  SCRecorder
//
//  Created by Simon CORSIN on 14/05/14.
//  Copyright (c) 2014 rFlex. All rights reserved.
//

#import "SCImageView.h"

@interface SCImageView() {
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    EAGLContext *_eaglContext;
#else
    CGLContextObj _cglContext;
#endif
    
    CIContext *_ciContext;
}

@end

@implementation SCImageView

- (id)initWithFrame:(CGRect)frame {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self = [super initWithFrame:frame context:context];
#else
    self = [super initWithFrame:frame];
#endif
    
    if (self) {
        
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
        _ciContext = [CIContext contextWithEAGLContext:context options:options];
#else
        NSOpenGLPixelFormatAttribute attrs[] =
        {
            NSOpenGLPFADoubleBuffer,
            NSOpenGLPFADepthSize, 24,
            // Must specify the 3.2 Core Profile to use OpenGL 3.2
            NSOpenGLPFAOpenGLProfile,
            NSOpenGLProfileVersion3_2Core,
            0
        };
        
        NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
        
        if (!pf)
        {
            NSLog(@"No OpenGL pixel format");
        }
        
        NSOpenGLContext* context = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
        
        [self setPixelFormat:pf];
        
        [self setOpenGLContext:context];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _ciContext = [CIContext contextWithCGLContext:context.CGLContextObj pixelFormat:pf.CGLPixelFormatObj colorSpace:colorSpace options:nil];
        CFRelease(colorSpace);
#endif
        
    }
    
    return self;
}

CGRect CGRectMultiply(CGRect rect, CGFloat scale) {
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    return rect;
}

- (void)drawRect:(CGRect)rect {
    if (_image != nil) {
//        CGFloat contentScale = self.contentScaleFactor;
//        
//        rect = CGRectMultiply(rect, contentScale);
        
        [_ciContext drawImage:_image inRect:rect fromRect:[_image extent]];
    }
}

#if !(TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
- (void)setNeedsDisplay {
    [self display];
}
#endif

- (void)setImage:(CIImage *)image {
    _image = image;
    
    [self setNeedsDisplay];
}

@end
