//
//  NSTableView+Resize.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Cocoa/Cocoa.h>

@interface NSTableView (Resize)

- (void)sizeHeightToFit;
- (CGFloat)maximumHeightForContent;

@end
