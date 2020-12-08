//
//  BPMailBundle.m
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.
//

#import "BPMailBundle.h"

@import ObjectiveC.runtime;
@import AppKit;
#import "MVMailBundle.h"
#import "BPCodeInjector.h"

@implementation BPMailBundle

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"

- (id)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}

+ (void)initialize {

    Class mvMailBundleClass = NSClassFromString(@"MVMailBundle");
    assert(mvMailBundleClass);

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    class_setSuperclass([self class], mvMailBundleClass);
#pragma GCC diagnostic pop

    // Makes sure init() is called.
    [BPMailBundle sharedInstance];

    // Register our plugin bundle in Apple Mail
    [[((MVMailBundle *)self) class] registerBundle];
    NSLog(@"regeistered");

    // Swizzle
    [self injectCodeForCustomMailToolbarItem];
}

// MARK: - Mailtoolbar & Delegate (MessageViewer)

static NSString *bpToolbarItemIdentifier = @"bpToolbarItemIdentifier";

+ (void) injectCodeForCustomMailToolbarItem {
    [self injectCodeToMailtoolbar];
    [self injectCodeToMessageViewer];
}

+ (void)injectCodeToMessageViewer {
    Class class = NSClassFromString(@"MessageViewer");
    NSArray<NSString*> * selectors = @[@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:",
                                       @"toolbarAllowedItemIdentifiers:",
                                       @"toolbarWillAddItem:"];
    [class injectExtensionCodeAndSwizzleSelectors:selectors];
}

+ (void)injectCodeToMailtoolbar {
    Class class = NSClassFromString(@"MailToolbar");
    NSArray<NSString*> * selectors = @[@"toolbarDefaultItemIdentifiers:",
                                       @"_plistForToolbarWithIdentifier:"];
    [class injectExtensionCodeAndSwizzleSelectors:selectors];
}
@end
