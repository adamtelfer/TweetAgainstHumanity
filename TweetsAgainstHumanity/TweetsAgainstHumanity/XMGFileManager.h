//
//  XMGFileManager.h
//  XMGLib
//
//  Created by Andrew Toth on 7/26/10.
//  Copyright 2010 XMG Studio Inc. All rights reserved.
//

#import "NSDictionary+XMG.h"

// The name inside the XMGConfig plist 
// that is an array of all the first level folder references in the main bundle
#define FOLDER_REFERENCES @"FOLDER_REFERENCES"
#define FileManagerConfig @"FILE_MANAGER"
#define GENERATE_INDEX \
    ([XMGConfig getDictionary:FileManagerConfig] ? [[XMGConfig getDictionary:FileManagerConfig] boolForKey:@"GENERATE_INDEX" orElse:NO] : NO)
#define BUNDLE_INDEX_FILE \
    ([[XMGConfig getDictionary:FileManagerConfig] objectForKey:@"BUNDLE_INDEX_FILE"])
#define USE_INDEX_IN_BUNDLE \
    ([XMGConfig getDictionary:FileManagerConfig] ? [[XMGConfig getDictionary:FileManagerConfig] boolForKey:@"USE_INDEX_IN_BUNDLE" orElse:NO] : NO)

@interface XMGFileManager : NSObject {

}

// Don't call this directly
+ (void)init;

// Returns the full path to the filename
// Call this when accessing a resource
// i.e. an image or plist
// Takes care of finding the high res version of an image if using iPhone 4
+ (NSString*) pathForFile:(NSString *)filename;

// Returns whether or not a file exists
+ (BOOL) doesFileExist:(NSString *)filename;

// Returns the full path in documents for the filename
// Call this when writing a file, it will give the correct location to write to
+ (NSString*) pathForFileInDocuments:(NSString *)filename;
+ (NSString*) pathForFileInCache:(NSString*)filename;

// Returns whether or not a file exists
+ (BOOL) doesFileExistInDocuments:(NSString *)filename;
+ (BOOL) doesFileExistInCache:(NSString*)filename;

// Returns the full path in the main bundle for the filename
// Call this when accessing a resource that you need to not be overwritten
+ (NSString*) pathForFileInMainBundle:(NSString *)filename;

// Allows you to specify a directory to search in
+ (NSString*) pathForFileInMainBundle:(NSString *)filename inDirectory:(NSString *)directory;

// Returns whether or not a file exists
+ (BOOL) doesFileExistInMainBundle:(NSString *)filename;

// Returns the full path to the directory
+ (NSString*) pathForDirectory:(NSString *)directory;

// Reindexes the file paths
// Call this after downloading files
+ (void) reindexFilePaths;

// Adds a file in the documents directory to the index
+ (void) addFileInDocumentsToIndex:(NSString*)file;
+ (void) addFileInCacheToIndex:(NSString*)file;

// Accepts a resource filename <fullpath>/<name>.<extension>
// Returns <fullpath>/<name>@2x.<extension> if it exists, otherwise returns filename
+ (NSString*) highResVersionOfFile:(NSString*)filename;

// Removes files with a specific prefix and/or suffix
+ (void) removeFilesWithFilter:(NSString*)prefix suffix:(NSString*)suffix;

+ (NSMutableDictionary*) filePaths;

// Use this to mark items as "do not backup"
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
