//
//  SCAppDelegate.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <AVFoundation/AVFoundation.h>
#import "SCAppDelegate.h"
#import "SCFilterDescriptionParser.h"
#import "SCFilterTranslator.h"
#import "SCMainWindowController.h"
#import "SCFilterCodeGenerator.h"

#define kFilterDescriptionFileUrlKey @"FilterDescriptionFileUrl"

@interface SCAppDelegate() {
    SCFilterDescriptionList *_filterDescriptions;
    NSMutableArray *_projectVCs;
    NSURL *_filterDescriptionURL;
    SCMainWindowController *_displayedWindow;
}

@end

@implementation SCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterDescriptionFileUrlKey];
    
    if (url != nil) {
        [self openFilterDescriptions:[NSURL URLWithString:url]];
        _projectVCs = [NSMutableArray new];
    }
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
    NSData *data = displayedWindow.documentData;
    NSError *error = nil;
    
    [data writeToURL:url options:NSDataWritingAtomic error:&error];
    
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
        
        [savePanel beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSOKButton) {
                [self save:displayedWindow to:savePanel.URL];
            }
            
        }];
    }
}

- (void)openProject:(NSURL *)url {
    NSData *data = nil;
    
    if (url != nil) {
        NSError *error = nil;
        data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        
        if (error != nil) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
            return;
        }
    }

    
    SCMainWindowController *mainViewController = [[SCMainWindowController alloc] initWithWindowNibName:@"SCMainWindowController"];
    mainViewController.window.delegate = self;
    
    if (data != nil) {
        [mainViewController applyDocument:data];
    }
    if (url != nil) {
        mainViewController.fileUrl = url;
    }
    
    [mainViewController showWindow:nil];
    [_projectVCs addObject:mainViewController];
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
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            [self openProject:openPanel.URL];
        }
    }];
}

- (IBAction)exportCode:(id)sender {
    if (_displayedWindow != nil) {
        NSSavePanel *savePen = [NSSavePanel savePanel];
    
        NSComboBox *comboBox = [[NSComboBox alloc] init];
        comboBox.frame = CGRectMake(0, 0, 70, 25);
        [comboBox addItemWithObjectValue:@"iOS"];
        [comboBox addItemWithObjectValue:@"OSX"];
        [comboBox selectItemAtIndex:0];
        [comboBox sizeToFit];
        
        savePen.accessoryView = comboBox;
        NSArray *filters = _displayedWindow.filters;
        
        [savePen beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSOKButton) {
                NSURL *url = savePen.URL;
                
                NSString *fileName = [url.lastPathComponent stringByDeletingPathExtension];
                
                SCFilterCodeGenerator *codeGenerator = [[SCFilterCodeGenerator alloc] init];
                codeGenerator.filters = filters;
                
                if ([comboBox.stringValue isEqualToString:@"OSX"]) {
                    codeGenerator.outputSystem = FilterCodeGeneratorOutputSystemMac;
                } else {
                    codeGenerator.outputSystem = FilterCodeGeneratorOutputSystemIOS;
                }
                
                [codeGenerator generateCode:fileName];
                [codeGenerator saveTo:url];
            }
        }];
    }
}

- (void)updateForFilterDescriptions:(SCFilterDescriptionList *)descriptionFilter {
    for (NSMenuItem *menuItem in self.filtersMenu.itemArray) {
        if (menuItem.isSeparatorItem) {
            break;
        }
        [self.filtersMenu removeItem:menuItem];
    }
    
    _filterDescriptions = descriptionFilter;
    
    for (NSString *category in descriptionFilter.allCategories) {
        NSString *categoryTitle = [SCFilterTranslator categoryName:category];
        NSMenuItem *categoryMenuItem = [[NSMenuItem alloc] initWithTitle:categoryTitle action:nil keyEquivalent:@""];
        
        NSMenu *menu = [[NSMenu alloc] initWithTitle:category];
        categoryMenuItem.submenu = menu;
        
        NSUInteger index = 0;
        for (SCFilterDescription *filter in [descriptionFilter filterDescriptionsForCategory:category]) {
            NSMenuItem *filterItem = [[NSMenuItem alloc] initWithTitle:filter.localizedName action:nil keyEquivalent:@""];
            
            filterItem.tag = filter.filterId;
            filterItem.target = self;
            filterItem.action = @selector(addFilterFired:);
            
            [menu addItem:filterItem];
        }
        
        [self.filtersMenu insertItem:categoryMenuItem atIndex:index++];
    }
}

- (void)addFilterFired:(NSMenuItem *)item {
    SCFilterDescription *filterDescription = [_filterDescriptions filterDescriptionForId:item.tag];
    
    SCFilter *filter = [SCFilter filterWithFilterDescription:filterDescription];
    
    if (filter != nil) {
        [_displayedWindow addFilter:filter];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to add filter" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Filter %@ not found in system", filterDescription.name];
        [alert runModal];
    }
}

- (void)openFilterDescriptions:(NSURL *)fileUrl {
    SCFilterDescriptionParser *parser = [[SCFilterDescriptionParser alloc] init];
    parser.fileUrl = fileUrl;
    
    if ([parser parse]) {
        SCFilterDescriptionList *descriptionFilter = parser.filterDescriptionList;

        [self updateForFilterDescriptions:descriptionFilter];
        [[NSUserDefaults standardUserDefaults] setObject:fileUrl.absoluteString forKey:kFilterDescriptionFileUrlKey];
        
        _filterDescriptionURL = fileUrl;
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Failed to open filter descriptions file" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error: %@", parser.error.localizedDescription];
        [alert runModal];
    }

}

- (IBAction)changeFilterDescriptionFile:(id)sender {
    NSOpenPanel *open = [NSOpenPanel openPanel];
    
    open.canChooseDirectories = NO;
    open.allowedFileTypes = @[@"cis"];
    open.allowsMultipleSelection = NO;
    
    if (_filterDescriptionURL != nil) {
        open.directoryURL = _filterDescriptionURL;
    }
    
    [open beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = open.URL;
            [self openFilterDescriptions:url];
        }
    }];
}

- (IBAction)reloadFileDescriptionFile:(id)sender {
    if (_filterDescriptionURL != nil) {
        [self openFilterDescriptions:_filterDescriptionURL];        
    }
}
@end
