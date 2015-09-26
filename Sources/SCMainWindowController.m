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
#import "SCAppDelegate.h"
#import "CIFilter+Categories.h"
#import "SCFilterGroup.h"

@interface SCMainWindowController () {
    NSMutableArray *_currentlyDisplayedVC;
    NSArray *_availableFilters;
}

@end

@implementation SCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _filter = [SCFilter emptyFilter];
        _currentlyDisplayedVC = [NSMutableArray new];
        
        NSMutableArray *availableFilters = [NSMutableArray new];
        for (NSString *categoryName in [CIFilter allCategoryNames]) {
            [availableFilters addObject:categoryName];
            
            for (NSString *filterName in [CIFilter filterNamesInCategory:categoryName]) {
                [availableFilters addObject:filterName];
            }
        }
        _availableFilters = availableFilters;
        
        [self.filtersTableView reloadData];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    self.filtersTableView.dataSource = self;
}

- (void)addFilter:(SCFilter *)filter {
    filter.delegate = self;
    [self.filtersTableView beginUpdates];
    
    [self.filtersTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:_filter.subFilters.count] withAnimation:NSTableViewAnimationSlideUp];
    
    [_filter addSubFilter:filter];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (void)removeFilter:(SCFilter *)filter {
    SCFilterConfiguratorWindowController *configurator = [self configuratorForFilter:filter];
    if (configurator != nil) {
        [_currentlyDisplayedVC removeObject:configurator];
    }
    
    [_filter removeSubFilter:filter];
    [self rebuildFilterPipeline];
}

- (void)filter:(SCFilter *)filter didChangeParameter:(NSString *)parameterKey {
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
    return [_filter.subFilters objectAtIndex:index];
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

- (void)updateTitle {
    self.window.title = [NSString stringWithFormat:@"%@ - %@", _filter.name, _fileUrl.lastPathComponent];
}

- (void)applyDocument:(NSData *)data {
    NSError *error = nil;

    SCFilter *filter = nil;
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if ([obj isKindOfClass:[SCFilterGroup class]]) {
            NSLog(@"Found an old version of SCFilter. Converting to new format.");
            SCFilterGroup *filterGroup = obj;
            filter = [SCFilter emptyFilter];
            filter.name = filterGroup.name;

            for (SCFilter *subFilter in filterGroup.filters) {
                [filter addSubFilter:subFilter];
            }
        } else if ([obj isKindOfClass:[SCFilter class]]) {
            filter = obj;
        }

        if (filter == nil) {
            error = [NSError errorWithDomain:@"FilterDomain" code:200 userInfo:@{
                                                                                 NSLocalizedDescriptionKey : @"Invalid serialized class type"
                                                                                 }];
        }
    } @catch (NSException *exception) {
        error = [NSError errorWithDomain:@"SCFilterGroup" code:200 userInfo:@{
                                                                              NSLocalizedDescriptionKey : exception.reason
                                                                              }];
    }

    if (error == nil && filter != nil) {
        for (SCFilter *subFilter in filter.subFilters) {
            subFilter.delegate = self;
        }
        
        _filter = filter;
        [self.filtersTableView reloadData];
        [self rebuildFilterPipeline];
    } else {
        [[NSAlert alertWithError:error] runModal];
    }
    
    [self updateTitle];
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    
    [self updateTitle];
}

- (void)rebuildFilterPipeline {
    self.mediaDisplayerView.filter = _filter;
}

- (IBAction)deleteActivated:(NSButton *)sender {
    NSInteger index = [self.filtersTableView rowForView:sender];
    
    [self.filtersTableView beginUpdates];
    
    [self.filtersTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
    [_filter removeSubFilterAtIndex:index];
    [self rebuildFilterPipeline];
    
    [self.filtersTableView endUpdates];
}

- (IBAction)addActivated:(id)sender {
    NSInteger index = [self.availableFiltersTableView rowForView:sender];
    NSString *filterName = [_availableFilters objectAtIndex:index];
    
    [self addFilter:[SCFilter filterWithCIFilterName:filterName]];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == self.filtersTableView) {
        return _filter.subFilters.count;
    } else {
        return _availableFilters.count;
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == self.filtersTableView) {
        SCFilterView *filterView = [tableView makeViewWithIdentifier:@"SCFilterView" owner:self];
        SCFilter *filter = [_filter.subFilters objectAtIndex:row];
        
        filterView.title.stringValue = [filter.CIFilter.attributes objectForKey:kCIAttributeFilterDisplayName];
        filterView.enabledCheckbox.state = (NSInteger)filter.enabled;
        
        return filterView;
    } else {
        NSString *filter = [_availableFilters objectAtIndex:row];
        
        NSTableCellView *view = nil;
        
        NSString *text = nil;
        
        if ([filter hasPrefix:@"CICategory"]) {
            view = [tableView makeViewWithIdentifier:@"Category" owner:self];
            text = [SCFilterTranslator categoryName:filter];
        } else {
            view = [tableView makeViewWithIdentifier:@"Filter" owner:self];
            text = [NSString stringWithFormat:@"  %@", [SCFilterTranslator filterName:filter]];
        }
        
        view.textField.stringValue = text;
        
        return view;
    }
}

- (NSArray *)filters {
    return _filter.subFilters;
}

@end
