//
//  SCFilterConfiguratorWindowController.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCFilterConfiguratorWindowController.h"
#import "SCDistanceCellView.h"
#import "SCUnsupportedCellView.h"
#import "NSTableView+Resize.h"
#import "SCFilterTranslator.h"

@interface SCFilterConfiguratorWindowController () {
    NSMutableArray *_parametersInputs;
}


@end

@implementation SCFilterConfiguratorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [self adjustTableSize];
    [super windowDidLoad];

    
    self.window.title = [NSString stringWithFormat:@"%@ Configuration", [CIFilter localizedNameForFilterName:[self.filter.coreImageFilter.attributes objectForKey:kCIAttributeFilterName]]];
    
    [self.parametersTableView reloadData];
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
    return NO;
}

- (void)adjustTableSize
{
    CGFloat height = [self.parametersTableView maximumHeightForContent];
    CGFloat barSize = self.window.frame.size.height - ((NSView *)self.window.contentView).frame.size.height;
    
    [self.window setFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, self.parametersTableView.frame.size.width, height + barSize) display:YES];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *inputParameters = [NSMutableArray new];
    for (NSString *key in self.filter.coreImageFilter.attributes.allKeys) {
        if ([key hasPrefix:@"input"] && ![key isEqualToString:@"inputImage"]) {
            [inputParameters addObject:key];
        }
    }
    
    _parametersInputs = inputParameters;
    
    return inputParameters.count + 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *parameter = nil;
    NSString *type = nil;
    
    if (row < _parametersInputs.count) {
        parameter = [_parametersInputs objectAtIndex:row];
        type = [[self.filter.coreImageFilter.attributes objectForKey:parameter] objectForKey:kCIAttributeType];
    } else {
        type = @"ResetDefaults";
    }
    
    SCFilterParameterConfigurationCellView *cellView = [tableView makeViewWithIdentifier:type owner:self];
    
    if (cellView == nil) {
        cellView = [tableView makeViewWithIdentifier:@"Unsupported" owner:self];
        
        SCUnsupportedCellView *unsupported = (SCUnsupportedCellView *)cellView;
        unsupported.errorTextField.stringValue = [NSString stringWithFormat:unsupported.errorTextField.stringValue, type];
    }
    
    cellView.filter = _filter;
    cellView.parameterName = parameter;
    cellView.titleTextField.stringValue = [SCFilterTranslator parameterName:parameter];
    
    [cellView rebuild];
    
    return cellView;
}

- (void)refreshSettingsValue {
    [self.parametersTableView reloadData];
}

- (IBAction)distanceChanged:(NSSlider *)sender {
    NSLog(@"Distance changed");
}

@end
