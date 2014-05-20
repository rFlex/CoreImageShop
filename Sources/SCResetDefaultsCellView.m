//
//  SCResetDefaultsCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCResetDefaultsCellView.h"

@implementation SCResetDefaultsCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)resetDefaultsPressed:(id)sender {
    [self.filter resetToDefaults];
}

@end
