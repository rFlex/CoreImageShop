//
//  CIFilter+Categories.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 22/05/14.
//
//

#import "CIFilter+Categories.h"

@implementation CIFilter (Categories)

+ (NSArray *)allCategoryNames {
    return @[ @"CICategoryBlur", @"CICategoryColorAdjustment", @"CICategoryColorEffect", @"CICategoryCompositeOperation", @"CICategoryDistortionEffect", @"CICategoryGenerator", @"CICategoryGeometryAdjustment", @"CICategoryGradient", @"CICategoryHalftoneEffect", @"CICategoryReduction", @"CICategorySharpen",
              @"CICategoryStylize", @"CICategoryTileEffect", @"CICategoryTransition"];
}

@end
