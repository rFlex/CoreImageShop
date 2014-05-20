//
//  NSTableView+Resize.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "NSTableView+Resize.h"

@implementation NSTableView (Resize)

- (CGFloat)maximumHeightForContent {
    CGFloat height = 0.f;
    if ([self.delegate respondsToSelector:@selector(tableView:heightOfRow:)]) {
        for (NSInteger i = 0; i < self.numberOfRows; ++i)
            height = height +
            [self.delegate tableView:self heightOfRow:i] +
            self.intercellSpacing.height;
    } else {
        height = (self.rowHeight + self.intercellSpacing.height) *
        self.numberOfRows;
    }
    
    return height;
}

- (void)sizeHeightToFit {
    NSSize frameSize = self.frame.size;
    frameSize.height = [self maximumHeightForContent];
    [self.enclosingScrollView setFrameSize:frameSize];
}

@end
