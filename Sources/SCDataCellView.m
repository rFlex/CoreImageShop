//
//  SCDataCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 03/10/14.
//
//

#import "SCDataCellView.h"

@implementation SCDataCellView

- (void)updateWithParameterValue:(id)parameterValue {
    [super updateWithParameterValue:parameterValue];
    
    NSData *data = self.parameterValue;
    
    self.urlTextField.stringValue = [NSString stringWithFormat:@"Data size: %d", (int)data.length];
}

CGImageRef CreateCGImageFromURL (NSURL *url)
{
    CGImageRef        myImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[2];
    CFTypeRef         myValues[2];
    
    // Set up options if you want them. The options here are for
    // caching the image in a decoded form and for using floating-point
    // values if the image format supports them.
    myKeys[0] = kCGImageSourceShouldCache;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceShouldAllowFloat;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    // Create the dictionary
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    // Create an image source from the URL.
    myImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, myOptions);
    CFRelease(myOptions);
    // Make sure the image source exists before continuing
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }
    // Create an image from the first item in the image source.
    myImage = CGImageSourceCreateImageAtIndex(myImageSource,
                                              0,
                                              NULL);
    
    CFRelease(myImageSource);
    // Make sure the image exists before continuing
    if (myImage == NULL){
        fprintf(stderr, "Image not created from image source.");
        return NULL;
    }
    
    return myImage;
}


- (IBAction)openClicked:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setExtensionHidden:YES];
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSURL *url = openPanel.URL;
            
            NSString *pathExtension = url.pathExtension;
            
            if ([pathExtension isEqualToString:@"png"]) {
                CGImageRef image = CreateCGImageFromURL(url);
                
                self.parameterValue = [SCDataCellView dataWithCGImage:image dimension:kCubeDimensionSize];
            } else {
                self.parameterValue = [NSData dataWithContentsOfURL:url];
            }
        }
    }];
}

/////
// The following code was taken from https://github.com/NghiaTranUIT/FeSlideFilter
//
+(NSData *) dataWithCGImage:(CGImageRef )image dimension:(NSInteger)n {
    
    NSInteger width = CGImageGetWidth(image);
    NSInteger height = CGImageGetHeight(image);
    NSInteger rowNum = height / n;
    NSInteger columnNum = width / n;
    
    if ((width % n != 0) || (height % n != 0) || (rowNum * columnNum != n)) {
        return nil;
    }
    
    unsigned char *bitmap = [self createRGBABitmapFromImage:image];
    
    if (bitmap == NULL) {
        return nil;
    }
    
    NSInteger size = n * n * n * sizeof(float) * 4;
    float *data = malloc(size);
    int bitmapOffest = 0;
    int z = 0;
    for (int row = 0; row <  rowNum; row++) {
        for (int y = 0; y < n; y++) {
            int tmp = z;
            for (int col = 0; col < columnNum; col++) {
                for (int x = 0; x < n; x++) {
                    float r = (unsigned int)bitmap[bitmapOffest];
                    float g = (unsigned int)bitmap[bitmapOffest + 1];
                    float b = (unsigned int)bitmap[bitmapOffest + 2];
                    float a = (unsigned int)bitmap[bitmapOffest + 3];
                    
                    NSInteger dataOffset = (z*n*n + y*n + x) * 4;
                    
                    data[dataOffset] = r / 255.0;
                    data[dataOffset + 1] = g / 255.0;
                    data[dataOffset + 2] = b / 255.0;
                    data[dataOffset + 3] = a / 255.0;
                    
                    bitmapOffest += 4;
                }
                z++;
            }
            z = tmp;
        }
        z += columnNum;
    }
    
    free(bitmap);
    
    return [NSData dataWithBytesNoCopy:data length:size freeWhenDone:YES];
}

+ (unsigned char *)createRGBABitmapFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    NSInteger bitmapSize;
    NSInteger bytesPerRow;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow   = (width * 4);
    bitmapSize     = (bytesPerRow * height);
    
    bitmap = malloc( bitmapSize );
    if (bitmap == NULL) {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        free(bitmap);
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmap,
                                     width,
                                     height,
                                     8,
                                     bytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease( colorSpace );
    
    if (context == NULL) {
        free (bitmap);
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    CGContextRelease(context);
    
    return bitmap;
}

@end
