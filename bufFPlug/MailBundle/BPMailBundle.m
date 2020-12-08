//
//  BPMailBundle.m
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.

#import "BPMailBundle.h"

#import "BPSwizzleUtil.h"

@import ObjectiveC.runtime;
@import AppKit;
#import "MVMailBundle.h"

@implementation BPMailBundle

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"

static BPMailBundle *mySelf;

- (id)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    mySelf = self;
    
    return self;
}

+ (void)initialize {
    
    Class mvMailBundleClass = NSClassFromString(@"MVMailBundle");
    assert(mvMailBundleClass);
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    class_setSuperclass([self class], mvMailBundleClass);
#pragma GCC diagnostic pop
    
    // Makes sure init() is called. Trigger trickery there.
    [BPMailBundle sharedInstance];
    
    // Register our plugin bundle in Apple Mail
    [[((MVMailBundle *)self) class] registerBundle];
    NSLog(@"regeistered");

    [self swizzleAddCustomInMailToolbarItem]; //BUFF: mv to init
}

// MARK: - Swizzle Mailtoolbar & Delegate (MessageView)

+ (void) swizzleAddCustomInMailToolbarItem {
    [self swizzleMailtoolbarToolbarDelegateMethods];
    [self swizzleMessageViewerToolbarDelegateMethods];
}

+ (void)swizzleMessageViewerToolbarDelegateMethods {
    Class class = NSClassFromString(@"MessageViewer");
    NSArray<NSString*> * selectors = @[@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:",
                                       @"toolbarAllowedItemIdentifiers:",
                                       @"toolbarWillAddItem:"];
    [class swizzleSelectors:selectors];
}

+ (void)swizzleMailtoolbarToolbarDelegateMethods {
    Class class = NSClassFromString(@"MailToolbar");
    NSArray<NSString*> * selectors = @[@"toolbarDefaultItemIdentifiers:",
                                       @"_plistForToolbarWithIdentifier:"];
    [class swizzleSelectors:selectors];
}

@end
