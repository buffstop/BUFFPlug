//
//  BPHeadersViewController.h
//  bufFPlug
//
//  Created by Andreas Buff on 16.12.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPHeadersViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

+ (instancetype)newIntance;

@end

// Debugger issues defining cell in independent file
@interface BPValueCell : NSTableCellView
@property (weak) IBOutlet NSScrollView *scrollView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

-(void)addLinkDetection;

@end

NS_ASSUME_NONNULL_END
