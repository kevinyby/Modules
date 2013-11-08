#import "TableViewBase.h"

#define CELL_CONTENT_DELIMITER @","
#define CELL_CONTENT_LABEL_TAG(_index) (_index + 505)
#define HEADER_CONTENT_LABEL_TAG(_index) (_index + 202)

/**
 *  Here , this align table's contentsDictionary's every line content should connect with CELL_CONTENT_DELIMITER
 *
 * i.e. {@"Section_1":@[@[@"1,2,3"],@[@"a,b,c"]]}, divided by ","
 *  
 *  Note , for more than one sections , the header will be the same 
 *
 *  So , for multi sections, pass the two dimensions array of headers and valuesXcoodinates, against to contentsDictionary
 *
 */


// import !!! Just for section header
@interface AlignTableView : TableViewBase

@property (strong) NSArray* headers ;               // array of string @[@"1H",@"2H"] or @[@[@"1H",@"2H"],@[@"1H",@"2H"]]
@property (strong) NSArray* valuesXcoodinates;     // array fo number @[@(50),@(250)] or @[@[@(50),@(250)], @[@(50),@(250)]]



+ (void)setAlignHeaders: (UIView*)headerView headers:(NSArray*)headers valuesXcoodinates:(NSArray*)valuesXcoodinates;

+ (void)separateCellTextToAlignHeaders: (UITableViewCell*)cell valuesXcoodinates:(NSArray*)valuesXcoodinates text:(NSString*)text;

@end
