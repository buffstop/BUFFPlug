//
//  NSObject+ClassInjection.m
//  bufFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import "NSObject+ClassInjection.h"

@import ObjectiveC.runtime;

@implementation NSObject (ClassInjecting)

+ (void)transferSubclassesFromSuperclass {
    Class myClass = [self class];
    Class superClass = class_getSuperclass(myClass);

    // grab the list of all registered classes
    int numOfClasses = objc_getClassList(NULL, 0);
    Class *subclasses = (__unsafe_unretained Class *)malloc(numOfClasses * sizeof(Class));
    objc_getClassList(subclasses, numOfClasses);
    // iterate over the entire class list and re-super all subclasses of superclass except for this one
    for (int i = 0; i < numOfClasses; ++i) {
        if (class_getSuperclass(subclasses[i]) == superClass && subclasses[i] != self) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
            class_setSuperclass(subclasses[i], self);
#pragma GCC diagnostic pop
        }
    }
}

@end
