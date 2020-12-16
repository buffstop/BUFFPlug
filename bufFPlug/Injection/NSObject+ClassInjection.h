//
//  NSObject+ClassInjection.h
//  bufFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ClassInjecting)
/**
 Mimics posing.
 Use to inject your class in an existing class hierarchy.
 Example:
 * create a class XY inheriting from MFLibraryStore:
 ```
 class XY: MFLibraryStore {}
 ```
 * call `[XY transferSubclassesFromSuperclass]` once from MFMailBundle
 * Now XY will be in the class hierarchy of every class that has MFLibraryStore in it´s class hierarchy.
 This:
 MFIMAPLibraryStore -> MFLibraryStore -> NSObject
 will become:
 MFIMAPLibraryStore -> XY -> MFLibraryStore -> NSObject
 This enables you to override every method of MFLibraryStore, add custom implementation (e.g. change a message's content) and call `super` when done.
 */
+ (void)transferSubclassesFromSuperclass;

@end

NS_ASSUME_NONNULL_END
