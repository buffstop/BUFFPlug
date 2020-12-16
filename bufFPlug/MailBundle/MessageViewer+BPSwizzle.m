////
////  MessageViewer+BPSwizzle.m
////  buFPlug
////
////  Created by Andreas Buff on 08.12.20.
////
#import "MessageViewer+BPSwizzle.h"

#import <AppKit/AppKit.h>
#import "MailToolbar+BPSwizzle.h"
#import "BPHeadersViewController.h"
#import "MCMessageHeaders.h"

@implementation MessageViewer_BP

static NSPopover *popover;

+ (void)updatePopoverWithHeaders:(MCMessageHeaders*)newHeaders {
    if (!popover) {
        popover = [NSPopover new];
        popover.contentViewController = [BPHeadersViewController newIntance];
    }
    [self currentlyPresentedViewController].representedObject = newHeaders;
}

+ (BPHeadersViewController*)currentlyPresentedViewController {
    return popover.contentViewController;
}

- (void)togglePopoverVisisble:(NSButton *)sender  {
    if (!popover) {
        popover = [NSPopover new];
        popover.contentViewController = [BPHeadersViewController newIntance];
    }

    // Should have an EventMonitor for closing
    if (popover.isShown) {
        [self closePopover: sender];
    } else {
        [self showPopover: sender];
    }
}

- (void)showPopover:(NSButton *)sender  {
    [popover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSRectEdgeMaxY];
}

- (void)closePopover:(NSButton *)sender  {
    [popover performClose:sender];
}



// MARK: - Swizzled

- (NSToolbarItem *)bp_toolbar:(NSToolbar *)arg1 itemForItemIdentifier:(NSString *)arg2 willBeInsertedIntoToolbar:(BOOL)arg3 {
    if (![arg2 isEqualToString:bpToolbarItemIdentifier]) {
        return [self bp_toolbar:arg1 itemForItemIdentifier:arg2 willBeInsertedIntoToolbar:arg3];
    }
    // Make sure our toolbar item was not already added
    for(NSToolbarItem *item in [arg1 items]) {
        if([item.itemIdentifier isEqualToString:bpToolbarItemIdentifier])
            return nil;
    }

    NSSize toolbarItemSize = NSMakeSize(75.0, 23.0);
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:bpToolbarItemIdentifier];
    //    [item setView:securityMethodAccessoryView];
    item.title = @"Feature 2";
    item.toolTip = @"Feature 2";
    item.minSize = toolbarItemSize;

    NSButton *button = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    button.title = @"Feature 2";
    button.toolTip = @"Feature 2";
    button.target = self;
    button.action = @selector(togglePopoverVisisble:);

    item.view = button;
    item.view.layer.backgroundColor = NSColor.greenColor.CGColor; //BUFF: RM


    item.target = nil;
//    item.action = @selector(togglePopoverVisisble:);
    return item;
}

- (NSArray *)bp_toolbarAllowedItemIdentifiers:(NSToolbar *)arg1 {
    NSMutableArray *allowedIdentifiers = [self bp_toolbarAllowedItemIdentifiers:arg1].mutableCopy;
    if (![allowedIdentifiers containsObject:bpToolbarItemIdentifier]) {
        // Only if not in already
        [allowedIdentifiers addObject:bpToolbarItemIdentifier];
    }
    return allowedIdentifiers;
}

- (void)bp_toolbarWillAddItem:(NSNotification *)arg1 {
    NSToolbarItem *item = arg1.userInfo[@"item"];
    if ([item.itemIdentifier isEqualToString:bpToolbarItemIdentifier]) {
        // We might get a handle on it here to update it later
    }
    [self bp_toolbarWillAddItem:arg1];
}
@end
