//
//  BPCodeInjector
//  buFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BPSwizzle)

+ (void)injectMailBPExtensionsAndswizzleSelectors:(NSArray<NSString*>*)selectorNames;

@end

NS_ASSUME_NONNULL_END
