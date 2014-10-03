//
//  SCImageCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 03/10/14.
//
//

#import "SCImageCellView.h"

@implementation SCImageCellView

- (void)updateWithParameterValue:(id)parameterValue {
    [super updateWithParameterValue:parameterValue];
    
    CIImage *image = self.parameterValue;
    
    NSString *path = image.url.path;
    
    self.urlTextField.stringValue = path == nil ? @"(not set)" : path;
}

- (IBAction)openClicked:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = [NSImage imageFileTypes];
    [openPanel setExtensionHidden:YES];
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSURL *url = openPanel.URL;
            self.parameterValue = [CIImage imageWithContentsOfURL:url];
        }
    }];
}

@end
