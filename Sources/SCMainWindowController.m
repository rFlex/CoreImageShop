//
//  SCMainWindowController.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import "SCMainWindowController.h"
#import "SCFilterView.h"
#import "SCMediaDisplayerView.h"
#import "SCFilterConfiguratorWindowController.h"
#import "SCFilterTranslator.h"

@interface SCMainWindowController () {
    SCFilterGroup *_filterGroup;
    NSMutableArray *_currentlyDisplayedVC;
}

@end

@implementation SCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _filterGroup = [[SCFilterGroup alloc] init];
        _currentlyDisplayedVC = [NSMutableArray new];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    self.filtersTableView.dataSource = self;
    
}

- (void)addFilter:(SCFilter *)filter {
    filter.delegate = self;
    [self.filtersTableView beginUpdates];
    
    [self.filtersTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:_filterGroup.filters.count] withAnimation:NSTableViewAnimationSlideUp];
    
    [_filterGroup addFilter:filter];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (void)removeFilter:(SCFilter *)filter {
    SCFilterConfiguratorWindowController *configurator = [self configuratorForFilter:filter];
    if (configurator != nil) {
        [_currentlyDisplayedVC removeObject:configurator];
    }
    
    [_filterGroup removeFilter:filter];
    [self rebuildFilterPipeline];
}

- (void)filter:(SCFilter *)filter didChangeParameter:(SCFilterParameterDescription *)parameterDescription {
    [self refreshDisplay];
}

- (void)filterDidResetToDefaults:(SCFilter *)filter {
    SCFilterConfiguratorWindowController *configurator = [self configuratorForFilter:filter];
    [configurator refreshSettingsValue];
    [self refreshDisplay];
}

- (SCFilter *)filterForView:(NSView *)view {
    return [self filterForIndex:[self.filtersTableView rowForView:view]];
}

- (SCFilter *)filterForIndex:(NSInteger)index {
    return [_filterGroup.filters objectAtIndex:index];
}

- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *window = notification.object;
    [_currentlyDisplayedVC removeObject:window.windowController];
}

- (SCFilterConfiguratorWindowController *)configuratorForFilter:(SCFilter *)filter {
    for (SCFilterConfiguratorWindowController *configurator in _currentlyDisplayedVC) {
        if (configurator.filter == filter) {
            return configurator;
        }
    }
    
    return nil;
}

- (IBAction)settingsTapped:(NSButton *)sender {
    SCFilter *filter = [self filterForView:sender];
    
    SCFilterConfiguratorWindowController *theConfigurator = [self configuratorForFilter:filter];
    
    if (theConfigurator == nil) {
        theConfigurator = [[SCFilterConfiguratorWindowController alloc] initWithWindowNibName:@"SCFilterConfiguratorWindowController"];
        theConfigurator.filter = filter;
        theConfigurator.window.delegate = self;
        
        [_currentlyDisplayedVC addObject:theConfigurator];
    }
    
    [theConfigurator showWindow:self];
}

- (IBAction)checkboxChanged:(NSButton *)sender {
    SCFilter *filter = [self filterForView:sender];
    filter.enabled = (BOOL)sender.state;
    [self rebuildFilterPipeline];
}

- (void)refreshDisplay {
    // I didn't find a cleaner way yet
    NSArray *filters = self.mediaDisplayerView.layer.filters;
    self.mediaDisplayerView.layer.filters = nil;
    self.mediaDisplayerView.layer.filters = filters;
}

- (NSData *)documentData {
    return [NSKeyedArchiver archivedDataWithRootObject:self.filters];
}

- (void)applyDocument:(NSData *)data {
    id obj = [SCFilterGroup filterGroupWithData:data];
    
    if ([obj isKindOfClass:[SCFilterGroup class]]) {
        _filterGroup = obj;
    } else {
        _filterGroup = [SCFilterGroup filterGroupWithFilters:obj];
    }
    
    [self.filtersTableView reloadData];
    [self rebuildFilterPipeline];
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    self.window.title = fileUrl.lastPathComponent.stringByDeletingPathExtension;
}

- (void)rebuildFilterPipeline {
    self.mediaDisplayerView.filterGroup = _filterGroup;
}

- (IBAction)deleteActivated:(NSButton *)sender {
    NSInteger index = [self.filtersTableView rowForView:sender];
    
    [self.filtersTableView beginUpdates];
    
    [self.filtersTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
    [_filterGroup removeFilterAtIndex:index];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _filterGroup.filters.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    SCFilterView *filterView = [tableView makeViewWithIdentifier:@"SCFilterView" owner:self];
    SCFilter *filter = [_filterGroup.filters objectAtIndex:row];
    
    filterView.title.stringValue = [SCFilterTranslator filterName:filter.filterDescription.name];
    filterView.enabledCheckbox.state = (NSInteger)filter.enabled;
    
    return filterView;
}

- (NSArray *)filters {
    return _filterGroup.filters;
}

@end
