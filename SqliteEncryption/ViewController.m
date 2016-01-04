//
//  ViewController.m
//  SqliteEncryption
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import <ArcGIS/ArcGIS.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//#define SQLITE_HAS_CODEC
//#define SQLITE_TEMP_STORE 2
//#define SQLITE_CORE 1
//#define SQLITE_AMALGAMATION 1
//#ifndef SQLITE_PRIVATE
//# define SQLITE_PRIVATE static
//#endif
//#ifndef SQLITE_API
//# define SQLITE_API
//#endif

@interface ViewController ()

- (IBAction)btClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)test
{
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.sqlite"];
    
    FMDatabase *_db = [FMDatabase databaseWithPath:path];
    if (![_db open]) {
        _db = nil;
        return;
    }else{
        [_db setKey:@"123456"];
    }
    
    if(![_db goodConnection]){ //无效连接
        [_db close];
        [self upgradeDatabase:path];
    }
    
    NSLog(@">>>>>>>>>>>");

    FMResultSet *rs = [_db executeQuery:@"select * from test"];
    NSLog(@"<<<<<<<<<<<");

    while ([rs next]) {
        NSLog(@"%@",[rs stringForColumn:@"name"]);

    }
    

}

- (void)upgradeDatabase:(NSString *)path{
    NSString *tmppath = [self changeDatabasePath:path];
    if(tmppath){
        const char* sqlQ = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@'",path,@"123456"] UTF8String];
        
        sqlite3 *unencrypted_DB;
        if (sqlite3_open([tmppath UTF8String], &unencrypted_DB) == SQLITE_OK) {
            
            // Attach empty encrypted database to unencrypted database
           int status = sqlite3_exec(unencrypted_DB, sqlQ, NULL, NULL, NULL);
            
            // export database
            status = sqlite3_exec(unencrypted_DB, "SELECT sqlcipher_export('encrypted');", NULL, NULL, NULL);
            
            // Detach encrypted database
            status = sqlite3_exec(unencrypted_DB, "DETACH DATABASE encrypted;", NULL, NULL, NULL);
            
            status = sqlite3_close(unencrypted_DB);
            
            //delete tmp database
            [self removeDatabasePath:tmppath];
        }
        else {
            sqlite3_close(unencrypted_DB);
            NSAssert1(NO, @"Failed to open database with message ‘%s‘.", sqlite3_errmsg(unencrypted_DB));
        }
    }
}
- (NSString *)changeDatabasePath:(NSString *)path{
    NSError * err = NULL;
    NSFileManager * fm = [[NSFileManager alloc] init];
    NSString *tmppath = [path stringByReplacingOccurrencesOfString:@"sqlite" withString:@"tem"];
    BOOL result = [fm moveItemAtPath:path toPath:tmppath error:&err];
    if(!result){
        NSLog(@"Error: %@", err);
        return nil;
    }else{
        return tmppath;
    }
}

-(void)removeDatabasePath:(NSString *)path
{
    NSError * err = NULL;
    NSFileManager * fm = [[NSFileManager alloc] init];
    BOOL result = [fm removeItemAtPath:path error:&err];
    if(!result){
        NSLog(@"Error: %@", err);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btClick:(id)sender {
    [self test];

}
@end
