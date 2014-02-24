#import "FilterTableView.h"

#define CELL_CONTENT_DELIMITER @"`"
#define CELL_CONTENT_LABEL_TAG(_index) (_index + 505)
#define HEADER_CONTENT_LABEL_TAG(_index) (_index + 202)

/**
 *  Here , this align table's contentsDictionary's every line content should connect with CELL_CONTENT_DELIMITER
 *
 * i.e. {@"Section_1":@[@[@"1,2,3"],@[@"a,b,c"]]}, divided by ","
 *  
 *  Note , for more than one sections , the header will be the same 
 *
 *  So , for multi sections, pass the two dimensions array of headers and valuesXcoordinates, against to contentsDictionary
 *
 */


// import !!! Just for section header
@interface AlignTableView : FilterTableView

// array of string @[@"1H",@"2H"] or @[@[@"1H",@"2H"],@[@"1H",@"2H"]]
@property (strong) NSArray* headers ;

// here , tow dimension array of number @[@(50),@(250)] or @[@[@(50),@(250)], @[@(50),@(250)]]
@property (strong) NSArray* headersXcoordinates;
@property (strong) NSArray* valuesXcoordinates;

@property (strong) NSArray* headersYcoordinates;
@property (strong) NSArray* valuesYcoordinates;


#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (UITableView*)tableView headerView:(UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates headersYcoordinates:(NSArray*)headersYcoordinates;
+ (void)separateCellTextToAlignHeaders: (UITableView*)tableView cell:(UITableViewCell*)cell valuesXcoordinates:(NSArray*)valuesXcoordinates valuesYcoordinates:(NSArray*)valuesYcoordinates;

@end
