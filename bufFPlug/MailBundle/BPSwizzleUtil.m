//
//  BPSwizzleUtil.m
//  buFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import "BPSwizzleUtil.h"
@import ObjectiveC.runtime;
#import <objc/objc-class.h>

@implementation NSObject (BPSwizzle)

// MARK: - API

+ (void)swizzleSelectors:(NSArray<NSString*>*)selectorNames {
    Class extensionClass = [self extensionClass];
    [self addMethodsFromClass:extensionClass];
    [self onlySwizzleSelectors:selectorNames];
}

// MARK: - Private

+ (Class)extensionClass {
    NSString *selfClassName = NSStringFromClass(self.class);
    NSString *extensionClassName = [NSString stringWithFormat:@"%@_BP", selfClassName];
    return NSClassFromString(extensionClassName);
}

+(void)onlySwizzleSelectors:(NSArray<NSString*>*)selectorNames {
    Class class = self.class;
    NSString *prefix = @"bp_";
    for(NSString *selectorName in selectorNames) {
        NSString *mailSelectorName = selectorName;
        NSString *extensionSelectorName = [NSString stringWithFormat:@"%@%@", prefix, selectorName];

        SEL selector = NSSelectorFromString(mailSelectorName);
        SEL extensionSelector = NSSelectorFromString(extensionSelectorName);
        // First try to add as instance method.
        if(![class swizzleMethod:selector withMethod:extensionSelector]) {
            // If that didn't work, try to add as class method.
            if(![class swizzleClassMethod:selector withClassMethod:extensionSelector])
                NSLog(@"Assumed as inject only (intentionally not swizzled)");
        }
    }

}

+ (void)addMethodsFromClass:(Class)aClass {
    unsigned int methodCount;
    SEL currentSelector;
    Method *classMethods;
    for(unsigned int i = 0; i < 2; i++) {
        classMethods = class_copyMethodList(i == 0 ? aClass : object_getClass(aClass), &methodCount);
        for (unsigned int j = 0; j < methodCount; j++) {
            currentSelector = method_getName((Method)classMethods[j]);
            [i == 0 ? self : object_getClass(self) addMethod:currentSelector fromClass:i == 0 ? aClass : object_getClass(aClass)];
        }
        free(classMethods);
    }
}

+ (void)addMethod:(SEL)selector fromClass:(Class)class {
    Method method = class_getInstanceMethod(class, selector);
    assert(method);
    class_addMethod(self, selector, method_getImplementation(method), method_getTypeEncoding(method));
}

+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzleSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    if (!originalMethod) {
        return NO;
    }
    Method swizzleMethod = class_getInstanceMethod(self, swizzleSelector);
    if (!swizzleMethod) {
        return NO;
    }
    class_addMethod(self,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    swizzleSelector,
                    class_getMethodImplementation(self, swizzleSelector),
                    method_getTypeEncoding(swizzleMethod));

    method_exchangeImplementations(class_getInstanceMethod(self, originalSelector),
                                   class_getInstanceMethod(self, swizzleSelector));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector withClassMethod:(SEL)swizzleSelector{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    if (!originalMethod) {
        return NO;
    }
    Method swizzleMethod = class_getClassMethod(self, swizzleSelector);
    if (!swizzleMethod) {
        return NO;
    }
    class_addMethod(self,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    swizzleSelector,
                    class_getMethodImplementation(self, swizzleSelector),
                    method_getTypeEncoding(swizzleMethod));

    method_exchangeImplementations(class_getClassMethod(self, originalSelector),
                                   class_getClassMethod(self, swizzleSelector));
    return YES;
}

@end
