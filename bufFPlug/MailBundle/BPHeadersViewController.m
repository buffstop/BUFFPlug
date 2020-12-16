//
//  BPHeadersViewController.m
//  bufFPlug
//
//  Created by Andreas Buff on 16.12.20.
//

#import "BPHeadersViewController.h"

#import "MCMessageHeaders.h"

@interface BPHeadersViewController ()
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) MCMessageHeaders *headers;
@end

@implementation BPHeadersViewController

// MARK: - Life Cycle

- (void)viewWillAppear {
    [super viewWillAppear];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

// MARK: Fatory

+ (instancetype)newIntance {
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"main"
                                                 bundle:[NSBundle bundleForClass:self.class]];
    NSString *storyboardID = @"BPHeadersViewController";
    BPHeadersViewController *createe = [sb instantiateControllerWithIdentifier:storyboardID];
    assert(createe);
    return createe;
}

// MARK: -

- (void)setRepresentedObject:(MCMessageHeaders*)representedObject {
    self.headers = representedObject;
    [self.tableView reloadData];
}

// MARK: - NSTableViewDelegate & NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"BUFF: self.headers.allHeaderKeys.count: %lu", self.headers.allHeaderKeys.count);
    return self.headers.allHeaderKeys.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *key = self.headers.allHeaderKeys[row];
    NSString *value = [self valueForHeaderKey:key];

    NSTableCellView *cell;
    if ([tableColumn.identifier isEqualToString:@"collumn1"]) {
        cell = [tableView makeViewWithIdentifier:@"keyCell" owner:self];
        cell.textField.stringValue = key;
    } else {
        BPValueCell *valueCell = (BPValueCell*)[tableView makeViewWithIdentifier:@"valueCell" owner:self];
        valueCell.textView.automaticLinkDetectionEnabled = YES;
        valueCell.textView.string = value;
        [valueCell addLinkDetection];
        cell = valueCell;
    }
    return  cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    NSString *key = self.headers.allHeaderKeys[row];
    NSString *value = [self valueForHeaderKey:key];
    NSTextView *tmp = [NSTextView new];
    [tmp.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:value]];
    tmp.frame = CGRectMake(0, 0, 300, 800);
    [tmp sizeToFit];
    return tmp.frame.size.height;
}

// MARK: - PRIVATE

- (NSString *)valueForHeaderKey:(NSString*)key {
    NSArray *value;
    if ([MCMessageHeaders isAddressHeaderKey:key]) {
        value = [self.headers addressListForKey:key];
    } else if ([MCMessageHeaders isURLHeaderKey:key]) {
        value = [self.headers urlListForKey:key];
    } else if ([MCMessageHeaders isMessageIDHeaderKey:key]) {
        value = [self.headers messageIDListForKey:key];
    } else {
        value = [self.headers headersForKey:key];
    }
    return [self stringWithValuesFrom:value];;
}

- (NSString *)stringWithValuesFrom:(NSArray *)array {
    NSMutableString *result = [NSMutableString new];
    for (NSString *value in array) {
        if (![result isEqualToString:@""]) {
            [result appendString:@"\n"];
        }
        [result appendString:[NSString stringWithFormat:@"%@", value]];
    }
    return result;
}
@end

// MARK: - BPValueCell

@implementation BPValueCell

- (void)awakeFromNib {
    if (@available(macOS 10.14, *)) {
        self.textView.usesAdaptiveColorMappingForDarkAppearance = YES;
    }
}

-(void)addLinkDetection {
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    if (dataDetector) {
        NSString *string = [self.textView.textStorage string];
        NSArray *matches = [dataDetector matchesInString:string options:0
                                                   range:NSMakeRange(0, [string length])];
        [self.textView.textStorage beginEditing];
        [self.textView.textStorage removeAttribute:NSForegroundColorAttributeName
                                             range:NSMakeRange(0, [string length])];
        [self.textView.textStorage removeAttribute:NSLinkAttributeName
                                             range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                [self.textView.textStorage addAttributes:@{NSLinkAttributeName:url.absoluteString}
                                                   range:matchRange];
            }
        }
        [self.textView.textStorage endEditing];
    }
}

@end
