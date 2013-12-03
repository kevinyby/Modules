#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SQLiteManager : NSObject

- (sqlite3*) SQLiteInstance;
- (void) setSQLiteInstance: (sqlite3*)sqlite3;
- (NSString*) SQLiteInstancePath;
- (void) setSQLiteInstancePath: (NSString*)sqlite3Path;


-(void) openDataBase;
-(int) execute: (char*)sql;

@end
