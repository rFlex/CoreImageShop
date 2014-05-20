//
//  SCRectangleCellView.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 20/05/14.
//
//

#import "SCFilterParameterConfigurationCellView.h"

@interface SCRectangleCellView : SCFilterParameterConfigurationCellView

@property (weak) IBOutlet NSSlider *value1;
@property (weak) IBOutlet NSTextField *valueTextField1;
@property (weak) IBOutlet NSSlider *value2;
@property (weak) IBOutlet NSTextField *valueTextField2;
@property (weak) IBOutlet NSSlider *value3;
@property (weak) IBOutlet NSTextField *valueTextField3;
@property (weak) IBOutlet NSSlider *value4;
@property (weak) IBOutlet NSTextField *valueTextField4;

@end
