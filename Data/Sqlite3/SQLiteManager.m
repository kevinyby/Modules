#import "SQLiteManager.h"

#import "FileManager.h"


@implementation SQLiteManager
{
    sqlite3* database;
    NSString* databasePath;      // i.e. [Documents]/test.sql
}


- (void) setSQLiteInstance: (sqlite3*)sqlite3
{
    database = sqlite3;
}

- (void) setSQLiteInstancePath: (NSString*)sqlite3Path
{
    databasePath = sqlite3Path;
}

- (sqlite3*) SQLiteInstance
{
    return database;
}

- (NSString*) SQLiteInstancePath
{
    return databasePath;
}

// A . First set sqlite3 file path , and sqlite3* reference in the two above methos, or use the default
- (id)init
{
    self = [super init];
    if (self) {
        databasePath = [[FileManager documentsPath] stringByAppendingPathComponent: @"SQLite/sqlite3.sql"];     // default
    }
    return self;
}


// B . Than open 'current database'
-(void) openDataBase
{    
    [self openDB: &database sqlFile:databasePath];
}
-(void) openDB: (sqlite3**)sqlite3 sqlFile: (NSString*)sqlFile
{
    [FileManager createFolderIfNotExist: sqlFile];
    if (sqlite3_open([sqlFile UTF8String], sqlite3)==SQLITE_OK)
    {
        NSLog(@"open sqlite db ok.");
    }
    else
    {
        NSLog( @"can not open sqlite db " );
        
        //close database
        sqlite3_close(*sqlite3);
    }
}



// C. After open data base , you can do the following operations . To Be continued ...

-(int) execute: (char*)sql
{
    char *errorMsg;
    int status = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    return status;
}

- (void)createTable
{
    char *errorMsg;
    const char *createSql="create table if not exists persons (id integer primary key autoincrement,name text)";
    
    if (sqlite3_exec(database, createSql, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"create ok.");
    }
    else
    {
        NSLog( @"can not create table" );
//        [self ErrorReport:(NSString *)createSql];
    }
}

- (void)queryTable
{
    const char *selectSql="select id,name from persons";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, selectSql, -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"select ok.");
        while (sqlite3_step(statement)==SQLITE_ROW)//SQLITE_OK SQLITE_ROW
        {
            int _id=sqlite3_column_int(statement, 0);
            NSString *name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSLog(@"row>>id %i, name>> %@",_id,name);
        }
        
    }
    else
    {
        //error
        NSLog( @"can not query it" );
//        [self ErrorReport: (NSString *)selectSql];
    }
    
    sqlite3_finalize(statement);
}


- (void)deleteTable
{
    char *errorMsg;
    [self openDataBase];
    
    const char *sql = "DELETE FROM persons where id=24";
    if (sqlite3_exec(database, sql, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"delete ok.");
    }
    else
    {
        NSLog( @"can not delete it" );
//        [self ErrorReport: (NSString *)sql];
    }
    
}

@end
