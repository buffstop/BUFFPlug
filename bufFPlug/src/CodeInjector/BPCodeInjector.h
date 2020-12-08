//
//  BPCodeInjector.h
//  bufFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BPCodeInjector)

+ (void)injectExtensionCodeAndSwizzleSelectors:(NSArray<NSString*>*)selectorNames;

@end

NS_ASSUME_NONNULL_END

