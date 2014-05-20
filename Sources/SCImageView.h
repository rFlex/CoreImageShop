//
//  SCCIImageView.h
//  SCRecorder
//
//  Created by Simon CORSIN on 14/05/14.
//  Copyright (c) 2014 rFlex. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#else
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NSOpenGLView GLKView;
#endif

@interface SCImageView : GLKView

@property (strong, nonatomic) CIImage *image;

@end

