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
    
    self.urlTextField.stringValue = [NSString stringWithFormat:@"Data size: %d bytes", (int)data.length];
}

- (IBAction)openClicked:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setExtensionHidden:YES];
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSData *data = [NSData dataWithContentsOfURL:openPanel.URL];
            NSLog(@"Data is %d bytes", data.length);
            
            self.parameterValue = data;
        }
    }];
}


@end
