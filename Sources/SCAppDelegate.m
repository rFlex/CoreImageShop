//
//  SCAppDelegate.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <AVFoundation/AVFoundation.h>
#import "SCAppDelegate.h"
#import "SCFilterTranslator.h"
#import "SCMainWindowController.h"
#import "CIFilter+Categories.h"

@interface SCAppDelegate() {
    NSMutableArray *_projectVCs;
    NSURL *_filterDescriptionURL;
    SCMainWindowController *_displayedWindow;
    NSArray *_filters;
}

@end

@implementation SCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _projectVCs = [NSMutableArray new];
        
    NSString *lastSavedUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSavedFilterFileUrlKey];
    
    NSURL *projectUrl = lastSavedUrl != nil ? [NSURL URLWithString:lastSavedUrl] : nil;
    
    [self openProject:projectUrl];
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
    if (item.tag == 1) {
        return _displayedWindow != nil;
    }
    
    return YES;
}

- (void)performClose:(id)sender {
    if (_displayedWindow != nil) {
        [self closeWindow:_displayedWindow];
    }
}

- (void)saveDocument:(id)sender {
    if (_displayedWindow != nil) {
        if (_displayedWindow.fileUrl == nil) {
            [self saveDocumentAs:sender];
        } else {
            [self save:_displayedWindow to:_displayedWindow.fileUrl];
        }
    }
}

- (void)save:(SCMainWindowController *)displayedWindow to:(NSURL *)url {
    NSError *error = nil;
    [displayedWindow.filter writeToFile:url error:&error];
    
    if (error == nil) {
        displayedWindow.fileUrl = url;
        [[NSUserDefaults standardUserDefaults] setObject:url.absoluteString forKey:kLastSavedFilterFileUrlKey];
    } else {
        [[NSAlert alertWithError:error] runModal];
    }
}

- (void)saveDocumentAs:(id)sender {
    if (_displayedWindow != nil) {
        SCMainWindowController *displayedWindow = _displayedWindow;
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setExtensionHidden:YES];
        savePanel.allowedFileTypes = @[@"cisf"];
        
        [savePanel beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSOKButton) {
                [self save:displayedWindow to:savePanel.URL];
            }
        }];
    }
}

- (void)openProject:(NSURL *)url {
    NSData *data = nil;
    
    SCMainWindowController *mainViewController = [[SCMainWindowController alloc] initWithWindowNibName:@"SCMainWindowController"];
    [_projectVCs addObject:mainViewController];
    mainViewController.window.delegate = self;
    
    if (url != nil) {
        NSError *error = nil;
        data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        
        if (error != nil) {
            url = nil;
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        }
    }
    
    if (data != nil) {
        [mainViewController applyDocument:data];
    }
    
    if (url != nil) {
        mainViewController.fileUrl = url;
    }
    
    [mainViewController showWindow:nil];
}

- (void)closeWindow:(SCMainWindowController *)windowVC {
    if (windowVC == _displayedWindow) {
        _displayedWindow = nil;
    }
    
    [_projectVCs removeObject:windowVC];
}

- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *window = notification.object;
    [self closeWindow:window.windowController];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    _displayedWindow = ((NSWindow *)notification.object).windowController;
}

- (void)newDocument:(id)sender {
    [self openProject:nil];
}

- (void)openDocument:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"cisf"];
    [openPanel setExtensionHidden:YES];
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            [self openProject:openPanel.URL];
        }
    }];
}

- (void)updateFilters {
    for (NSMenuItem *menuItem in self.filtersMenu.itemArray) {
        if (menuItem.isSeparatorItem) {
            break;
        }
        [self.filtersMenu removeItem:menuItem];
    }
    
    NSMutableArray *filters = [NSMutableArray new];
    
    for (NSString *category in [CIFilter allCategoryNames]) {
        NSString *categoryTitle = [SCFilterTranslator categoryName:category];
        NSMenuItem *categoryMenuItem = [[NSMenuItem alloc] initWithTitle:categoryTitle action:nil keyEquivalent:@""];
        
        NSMenu *menu = [[NSMenu alloc] initWithTitle:category];
        categoryMenuItem.submenu = menu;
        
        NSUInteger index = 0;
        for (NSString *filter in [CIFilter filterNamesInCategory:category]) {
            NSString *filterName = [SCFilterTranslator filterName:filter];
            NSMenuItem *filterItem = [[NSMenuItem alloc] initWithTitle:filterName action:nil keyEquivalent:@""];
            
            filterItem.tag = filters.count;
            filterItem.target = self;
            filterItem.action = @selector(addFilterFired:);
            
            [menu addItem:filterItem];
            [filters addObject:filter];
        }
        
        [self.filtersMenu insertItem:categoryMenuItem atIndex:index++];
    }
    
    _filters = filters;
}

- (NSString *)input: (NSString *)prompt defaultValue: (NSString *)defaultValue {
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    
    if (defaultValue == nil) {
        defaultValue = @"";
    }
    
    [input setStringValue:defaultValue];
    
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        return [input stringValue];
    } else if (button == NSAlertAlternateReturn) {
        return nil;
    } else {
        return nil;
    }
}

- (IBAction)editName:(id)sender {
    NSString *entered = [self input:@"Enter the filter name" defaultValue:_displayedWindow.filter.name];
    
    if (entered != nil) {
        _displayedWindow.filter.name = entered;
        [_displayedWindow updateTitle];
    }
}

- (void)addFilterFired:(NSMenuItem *)item {
    NSString *filterName = [_filters objectAtIndex:item.tag];
    
    SCFilter *filter = [SCFilter filterWithCIFilterName:filterName];
    
    if (filter != nil) {
        [_displayedWindow addFilter:filter];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to add filter" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Filter %@ not found in system", filterName];
        [alert runModal];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return _projectVCs.count == 0;
}

+ (SCAppDelegate *)sharedInstance {
    return (SCAppDelegate *)[NSApplication sharedApplication].delegate;
}

@end
