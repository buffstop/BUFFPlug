//
//  BPMailBundle.m
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.

#import "BPMailBundle.h"

#import "BPCodeInjector.h"

@import ObjectiveC.runtime;
@import AppKit;
#import "MVMailBundle.h"

@implementation BPMailBundle

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"

- (id)init {
    if (self = [super init]) {
        NSLog(@"init");
    }

    [BPMailBundle injectCodeForMainToolbarItem];
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
}

// MARK: - Swizzle Mailtoolbar & Delegate (MessageView)

+ (void) injectCodeForMainToolbarItem {
    [self injectCodeInMailtoolbar];
    [self injectCodeInMessageViewer];
    [self injectCodeInConversationMember];
}

+ (void)injectCodeInMessageViewer {
    Class class = NSClassFromString(@"MessageViewer");
    NSArray<NSString*> * selectors = @[@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:",
                                       @"toolbarWillAddItem:"];
    [class injectMailBPExtensionsAndswizzleSelectors:selectors];
}

+ (void)injectCodeInMailtoolbar {
    Class class = NSClassFromString(@"MailToolbar");
    NSArray<NSString*> * selectors = @[@"_plistForToolbarWithIdentifier:"];
    [class injectMailBPExtensionsAndswizzleSelectors:selectors];
}

+ (void)injectCodeInConversationMember {
    Class class = NSClassFromString(@"ConversationMember");
    NSArray<NSString*> * selectors = @[@"headers"];
    [class injectMailBPExtensionsAndswizzleSelectors:selectors];
}

@end
