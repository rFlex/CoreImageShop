//
//  SCPositionCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCMediaDisplayerView.h"
#import "SCPositionCellView.h"

@implementation SCPositionCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDisplayerClicked:) name:kMediaDisplayerClickNotification object:nil];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
}

- (void)mediaDisplayerClicked:(NSNotification *)notification {
    if (self.editButton.state == 1) {
        NSValue *value = [notification.userInfo objectForKey:kMediaDisplayerClickLocationKey];
        CGPoint point = value.pointValue;
        [self setParameterValue:[CIVector vectorWithCGPoint:point]];
        
        self.editButton.state = 0;
    }
}

- (void)updateWithParameterValue:(id)parameterValue {
    [super updateWithParameterValue:parameterValue];
    
    CIVector *vector = parameterValue;
    self.xTextField.floatValue = vector.X;
    self.yTextField.floatValue = vector.Y;
}

- (IBAction)editPressed:(NSButton *)sender {
//    if (sender.state == 0) {
//        sender.state = 1;
//    } else {
//        sender.state = 0;
//    }
//    NSLog(@"Is now %d", sender.state);
}

@end
