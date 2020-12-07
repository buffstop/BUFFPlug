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

@implementation BPMailBundle

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"

static NSString *bpToolbarItemIdentifier = @"bpToolbarItemIdentifier";

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

    // Makes sure init() is called.
    [BPMailBundle sharedInstance];

    // Register our plugin bundle in Apple Mail
    [[((MVMailBundle *)self) class] registerBundle];
    NSLog(@"regeistered");

    // Swizzle
    [self swizzleAddCustomMailToolbarItem];
}

// MARK: - Swizzle Mailtoolbar & Delegate (MessageView)

+ (void) swizzleAddCustomMailToolbarItem {
    [self swizzleMailtoolbarToolbarDelegateMethods];
    [self swizzleMessageViewerToolbarDelegateMethods];
}

- (NSToolbarItem *)bp_toolbar:(NSToolbar *)arg1
        itemForItemIdentifier:(NSString *)arg2
    willBeInsertedIntoToolbar:(BOOL)arg3 {
    //    if (![arg2 isEqualToString:bpToolbarItemIdentifier]) {
    //        return [self bp_toolbar:arg1 itemForItemIdentifier:arg2 willBeInsertedIntoToolbar:arg3]; //BUFF: BUG: fails on >1rst call
    //    }
    // Make sure our toolbar item was not already added
    for(NSToolbarItem *item in [arg1 items]) {
        if([item.itemIdentifier isEqualToString:bpToolbarItemIdentifier])
            return nil;
    }

    NSSize toolbarItemSize = NSMakeSize(75.0, 23.0);
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:bpToolbarItemIdentifier];
    //    [item setView:securityMethodAccessoryView];
    item.title = @"Feature 1";
    item.minSize = toolbarItemSize;
    item.target = mySelf;
    item.action = @selector(toolbarItemAction:);
    return item;
}

- (void)toolbarItemAction:(id *)sender {
    NSLog(@"Clicked!");
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
    [mySelf bp_toolbarWillAddItem:arg1]; //BUFF: BUG: fails on >1rst call
}

+ (void)swizzleMessageViewerToolbarDelegateMethods {
    static dispatch_once_t onceToken;
    [self swizzleMethodOfClassNamed:@"MessageViewer"
                   originalSelector:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
                   swizzledSelector:@selector(bp_toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
                          onceToken:onceToken];

    static dispatch_once_t onceToken2;
    [self swizzleMethodOfClassNamed:@"MessageViewer"
                   originalSelector:@selector(toolbarAllowedItemIdentifiers:)
                   swizzledSelector:@selector(bp_toolbarAllowedItemIdentifiers:)
                          onceToken:onceToken2];

    static dispatch_once_t onceToken3;
    [self swizzleMethodOfClassNamed:@"MessageViewer"
                   originalSelector:@selector(toolbarWillAddItem:)
                   swizzledSelector:@selector(bp_toolbarWillAddItem:)
                          onceToken:onceToken3];
}

// MARK: swizzleMailtoolbarToolbarDelegateMethods

- (NSArray *)bp_toolbarDefaultItemIdentifiers:(NSToolbar *)arg1 {
    NSMutableArray *defaultIdentifiers = [self bp_toolbarDefaultItemIdentifiers:arg1].mutableCopy;
    if (![defaultIdentifiers containsObject:bpToolbarItemIdentifier]) {
        // Only if not in already
        [defaultIdentifiers addObject:bpToolbarItemIdentifier];
    }
    return defaultIdentifiers;
}

+ (void)swizzleMailtoolbarToolbarDelegateMethods {
//    static dispatch_once_t onceToken;
//    [self swizzleMethodOfClassNamed:@"MailToolbar"
//                   originalSelector:@selector(toolbarDefaultItemIdentifiers:)
//                   swizzledSelector:@selector(bp_toolbarDefaultItemIdentifiers:)
//                          onceToken:onceToken];
    static dispatch_once_t onceToken2;
    [self swizzleMethodWithClassNameOfClassHoldingTheSwizzled:@"MailToolbar_BPAdditions"
                                         nameOfClassToSwizzle:@"MailToolbar"
                                             originalSelector:@selector(plistForToolbarWithIdentifier)
                                             swizzledSelector:@selector(bp_plistForToolbarWithIdentifier)
                                                    onceToken:onceToken2];
}

// ############### INVESTIGATE

// MARK: - Swizzle MessageViewer to get Mailtoolbar as param for investigation

//// only swizzeled to get Mailtoolbar as param to be able to investigate it.
//- (NSToolbarItem *)buff_toolbar:(NSToolbar *)arg1 itemForItemIdentifier:(NSString *)arg2 willBeInsertedIntoToolbar:(BOOL)arg3 {
//    NSLog(@"BUFF: Mailtoolbar respondsToSelector:@selector(toolbarSelectableItemIdentifiers:): %d", [arg1 respondsToSelector:@selector(toolbarSelectableItemIdentifiers:)]);
//    NSLog(@"BUFF: Mailtoolbar respondsToSelector:@selector(toolbarDefaultItemIdentifiers:): %d", [arg1 respondsToSelector:@selector(toolbarDefaultItemIdentifiers:)]);
//    /*
//     2020-12-07 11:12:30.740918+0100 Mail[36069:4925676] BUFF: Mailtoolbar respondsToSelector:@selector(toolbarSelectableItemIdentifiers:): 0
//     2020-12-07 11:12:30.740975+0100 Mail[36069:4925676] BUFF: Mailtoolbar respondsToSelector:@selector(toolbarDefaultItemIdentifiers:): 1
//     */
//    return [self buff_toolbar:arg1 itemForItemIdentifier:arg2 willBeInsertedIntoToolbar:arg3];
//}

//+ (void)swizzleMessageViewerToPrintMailtoolbarInvestigations {
//    static dispatch_once_t onceToken;
//    [self swizzleMethodOfClassNamed:@"MessageViewer"
//                   originalSelector:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
//                   swizzledSelector:@selector(buff_toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
//                          onceToken:onceToken];

// MARK: - Investigate MailToolbar Delegate //BUFF: RM

//- (id<NSToolbarDelegate>)buff_toolbarDelegate {
//    id<NSToolbarDelegate> delegate = [self buff_toolbarDelegate];
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbarDidRemoveItem:): %d", [delegate respondsToSelector:@selector(toolbarDidRemoveItem:)]);
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbarWillAddItem:): %d", [delegate respondsToSelector:@selector(toolbarWillAddItem:)]);
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbarSelectableItemIdentifiers:): %d", [delegate respondsToSelector:@selector(toolbarSelectableItemIdentifiers:)]);
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbarAllowedItemIdentifiers:): %d", [delegate respondsToSelector:@selector(toolbarAllowedItemIdentifiers:)]);
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbarDefaultItemIdentifiers:): %d", [delegate respondsToSelector:@selector(toolbarDefaultItemIdentifiers:)]);
//    NSLog(@"BUFF: delegate respondsToSelector:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:): %d", [delegate respondsToSelector:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)]);
//    NSLog(@"BUFF: MailToolbar delegate: %@", delegate);
//    /*
//     2020-12-07 10:37:06.716518+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbarDidRemoveItem:): 1
//     2020-12-07 10:37:06.716588+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbarWillAddItem:): 1
//     2020-12-07 10:37:06.716635+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbarSelectableItemIdentifiers:): 0
//     2020-12-07 10:37:06.716722+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbarAllowedItemIdentifiers:): 1
//     2020-12-07 10:37:06.716785+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbarDefaultItemIdentifiers): 0
//     2020-12-07 10:37:06.716829+0100 Mail[33232:4873368] BUFF: respondsToSelector:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:): 1
//     2020-12-07 10:37:06.716895+0100 Mail[33232:4873368] BUFF: MailToolbar delegate: <MessageViewer: 0x7fb55b423f40>
//     */
//    return [self buff_toolbarDelegate];
//}
//
//+ (void)swizzleMailToolbarToPrintDelegate {
//    static dispatch_once_t onceToken;
//    [self swizzleMethodOfClassNamed:@"MailToolbar"
//                   originalSelector:@selector(delegate)
//                   swizzledSelector:@selector(buff_toolbarDelegate)
//                          onceToken:onceToken];
////    dispatch_once(&onceToken, ^{
////
////        // MARK: toolbarDefaultItemIdentifiers
////
////        Class swizzleClass = NSClassFromString(@"MailToolbar");
////        Class selfClass = [self class];
////        SEL originalSelector = @selector(delegate);
////        SEL swizzledSelector = @selector(buff_toolbarDelegate);
////        Method originalMethod = class_getInstanceMethod(swizzleClass, originalSelector);
////        Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSelector);
////        assert(originalMethod);
////        assert(swizzledMethod);
////
////        BOOL didAddMethod = class_addMethod(swizzleClass,
////                                            originalSelector,
////                                            method_getImplementation(swizzledMethod),
////                                            method_getTypeEncoding(swizzledMethod));
////        if (didAddMethod) {
////            class_replaceMethod(swizzleClass,
////                                swizzledSelector,
////                                method_getImplementation(originalMethod),
////                                method_getTypeEncoding(originalMethod));
////        } else {
////            method_exchangeImplementations(originalMethod, swizzledMethod);
////        }
////    });
//}

// MARK: - TOOLBOX

+ (void)swizzleMethodOfClassNamed:(NSString *)className
                 originalSelector:(SEL)originalSelector
                 swizzledSelector:(SEL)swizzledSelector
                        onceToken:(dispatch_once_t) onceToken {
    dispatch_once(&onceToken, ^{
        Class swizzleClass = NSClassFromString(className);
        Class selfClass = [self class];
        Method originalMethod = class_getInstanceMethod(swizzleClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSelector);
        assert(originalMethod);
        assert(swizzledMethod);

        BOOL didAddMethod = class_addMethod(swizzleClass,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(swizzleClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (void)swizzleMethodWithClassNameOfClassHoldingTheSwizzled:(NSString *)origClassName
                                       nameOfClassToSwizzle:(NSString *)swizzleClassName
                                           originalSelector:(SEL)originalSelector
                                           swizzledSelector:(SEL)swizzledSelector
                                                  onceToken:(dispatch_once_t) onceToken {
    dispatch_once(&onceToken, ^{
        Class origClass = NSClassFromString(origClassName);
        Class swizzleClass = NSClassFromString(swizzleClassName);

        Method originalMethod = class_getInstanceMethod(swizzleClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(origClass, swizzledSelector);
        assert(originalMethod);
        assert(swizzledMethod);

        BOOL didAddMethod = class_addMethod(swizzleClass,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(swizzleClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
@end
