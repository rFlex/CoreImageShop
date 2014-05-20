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

@interface SCMainWindowController () {
    NSMutableArray *_filters;
    NSMutableArray *_currentlyDisplayedVC;
}

@end

@implementation SCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _filters = [NSMutableArray new];
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
    
    [self.filtersTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:_filters.count] withAnimation:NSTableViewAnimationSlideUp];
    
    [_filters addObject:filter];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (void)removeFilter:(SCFilter *)filter {
    SCFilterConfiguratorWindowController *configurator = [self configuratorForFilter:filter];
    if (configurator != nil) {
        [_currentlyDisplayedVC removeObject:configurator];
    }
    
    [_filters removeObject:filter];
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
    return [_filters objectAtIndex:index];
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
    _filters = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    [self.filtersTableView reloadData];
    [self rebuildFilterPipeline];
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    self.window.title = fileUrl.lastPathComponent;
}

- (void)rebuildFilterPipeline {
    SCFilterGroup *filterGroup = [[SCFilterGroup alloc] init];
    for (SCFilter *filter in _filters) {
        if (filter.enabled) {
            [filterGroup addFilter:filter.coreImageFilter];
        }
    }
    
    self.mediaDisplayerView.filterGroup = filterGroup;
}

- (IBAction)deleteActivated:(NSButton *)sender {
    NSInteger index = [self.filtersTableView rowForView:sender];
    
    [self.filtersTableView beginUpdates];
    
    [self.filtersTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
    [_filters removeObjectAtIndex:index];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _filters.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    SCFilterView *filterView = [tableView makeViewWithIdentifier:@"SCFilterView" owner:self];
    SCFilter *filter = [_filters objectAtIndex:row];
    
    filterView.title.stringValue = filter.filterDescription.localizedName;
    filterView.enabledCheckbox.state = (NSInteger)filter.enabled;
    
    return filterView;
}

- (NSArray *)filters {
    return _filters;
}

@end
