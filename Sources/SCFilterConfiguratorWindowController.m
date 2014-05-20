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

@interface SCFilterConfiguratorWindowController ()

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
    [super windowDidLoad];

    [self adjustTableSize];
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
    return _filter.filterDescription.parameters.count + 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SCFilterParameterDescription *parameter = nil;
    NSString *type = nil;
    
    if (row < _filter.filterDescription.parameters.count) {
        parameter = [_filter.filterDescription.parameters objectAtIndex:row];
        type = parameter.type;
    } else {
        type = @"ResetDefaults";
    }
    
    SCFilterParameterConfigurationCellView *cellView = [tableView makeViewWithIdentifier:type owner:self];
    
    if (cellView == nil) {
        cellView = [tableView makeViewWithIdentifier:@"Unsupported" owner:self];
        
        SCUnsupportedCellView *unsupported = (SCUnsupportedCellView *)cellView;
        unsupported.errorTextField.stringValue = [NSString stringWithFormat:unsupported.errorTextField.stringValue, parameter.type];
    }
    
    cellView.filter = _filter;
    cellView.parameter = parameter;
    cellView.titleTextField.stringValue = [SCFilterTranslator parameterName:parameter.name];
    
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
