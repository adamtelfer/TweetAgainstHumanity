//
//  XMGFileManager.m
//  XMGLib
//
//  Created by Andrew Toth on 7/28/10.
//  Copyright 2010 XMG Studio Inc. All rights reserved.
//

#import "XMGFileManager.h"
#import "XMGMacros.h"
#import <UIKit/UIKit.h>
#include <sys/xattr.h>

#define CACHE_FOLDER @"Library/Caches"

@interface XMGFileManager (Private)

+ (void) addFilesInDirectoryToFilePaths:(NSString*)directory;

+ (void) writeIndexFile;
+ (void) loadIndexFile;

@end


@implementation XMGFileManager

static NSMutableDictionary* filePaths_ = nil;

+ (NSMutableDictionary*) filePaths
{
    return filePaths_;
}

+ (void) init {
	NSAssert(filePaths_ == nil, @"[XMGFileManager init] called again");
	filePaths_ = [[NSMutableDictionary alloc] init];
	NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
	
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER] isDirectory:&isDirectory])
    {
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER] withIntermediateDirectories:NO attributes:nil error:nil];
        [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER]]];
    }
    
    if(USE_INDEX_IN_BUNDLE) {
        // Use a pregenerated index file
        [self loadIndexFile];
    } else {
        // Generate the index file by scanning all files in the bundle
        for (NSString * path in [XMGConfig getArray:FOLDER_REFERENCES]) {
            NSString * fullPath = [bundlePath stringByAppendingPathComponent:[path stringByAppendingString:@"/"]];
            [self addFilesInDirectoryToFilePaths:fullPath];
        }
        [self reindexFilePaths];
    }
    
    if(GENERATE_INDEX) {
        [self writeIndexFile];
    }
}

+ (void) writeIndexFile {
    @synchronized(filePaths_) {
        NSString* basePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"/"];
        NSString* newIndexFilePath = [XMGFileManager pathForFileInDocuments:BUNDLE_INDEX_FILE];
        
        // The filePaths_ dictionary contains the _full_ path to the resources. This
        // includes the volume and base dirs. We need to strip these before saving.
        NSMutableDictionary* files = [NSMutableDictionary dictionary];
        for(NSString* key in [filePaths_ allKeys]) {
            NSString* path = [filePaths_ objectForKey:key];
            NSString* simplePath = [path stringByReplacingOccurrencesOfString:basePath withString:@""];
            [files setObject:simplePath forKey:key];
        }
        
        [files writeToFile:newIndexFilePath atomically:YES];
    }
}

+ (void) loadIndexFile {
    @synchronized(filePaths_) {
        NSString* basePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"/"];
        NSString* indexPath = [[NSBundle mainBundle] pathForResource:BUNDLE_INDEX_FILE ofType:nil];
        XMGAssert(indexPath, @"The index file cannot be found! Please make sure BUNDLE_INDEX_FILE is set in XMGConfig.plist");
        NSDictionary* pregeneratedIndex = [NSDictionary dictionaryWithContentsOfFile:indexPath];
        
        for(NSString* key in [pregeneratedIndex allKeys]) {
            NSString* path = [pregeneratedIndex objectForKey:key];
            NSString* fullPath = [basePath stringByAppendingPathComponent:path];
            [filePaths_ setObject:fullPath forKey:key];
        }
    }
}

+ (void) reindexFilePaths {
	@synchronized(filePaths_){		
		// Overwrite any file refs, with the files in the documents directory
        // Overwrite any file refs, with the files in the documents directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		
		[self addFilesInDirectoryToFilePaths:documentsPath];
		[self addFilesInDirectoryToFilePaths:[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER]];
	}
}

+ (void) addFileInDocumentsToIndex:(NSString*)file {
    [filePaths_ setValue:[self pathForFileInDocuments:file] forKey:file];
}

+ (void) addFileInCacheToIndex:(NSString*)file {
    [filePaths_ setValue:[self pathForFileInCache:file] forKey:file];
}

+ (void) addFilesInDirectoryToFilePaths:(NSString*)directory {
	NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directory];
	for(NSString* string in enumerator){
		NSDictionary* fileAttributes = [enumerator fileAttributes];
		NSArray* pathComponents = [string pathComponents];
		NSString* filename = [pathComponents lastObject];
		
		// Recursively go through all directories
		if([fileAttributes fileType] == NSFileTypeDirectory){
			[self addFilesInDirectoryToFilePaths:[directory stringByAppendingPathComponent:string]];
		} else {
			[filePaths_ setValue:[self highResVersionOfFile:[directory stringByAppendingPathComponent:string]] forKey:filename];
			NSRange range = [filename rangeOfString:@"@2x"];
			if ((IS_IPAD_DEVICE || IS_RETINA_DISPLAY) && range.location != NSNotFound) {
				NSString * lowResFilename = [NSString stringWithFormat:@"%@.%@", [filename substringToIndex:range.location], [filename pathExtension]];
				[filePaths_ setValue:[filePaths_ valueForKey:filename] forKey:lowResFilename]; 
			}
            if (IS_IPAD_DEVICE)
            {
                NSRange range2 = [filename rangeOfString:@"~ipad"];
                if (range2.location != NSNotFound) {
                    NSString * lowResFilename = [NSString stringWithFormat:@"%@.%@", [filename substringToIndex:range2.location], [filename pathExtension]];
                    [filePaths_ setValue:[filePaths_ valueForKey:filename] forKey:lowResFilename]; 
                }
            }
		}
	}
}

+ (NSString*) pathForFile:(NSString *)filename {
	NSAssert((filename != nil),@"pathForFile filename is nil");
	@synchronized(filePaths_) {
		NSString * returnValue = [filePaths_ valueForKey:filename];
		if (returnValue != nil) {
			return returnValue;
		}
		return [self highResVersionOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
	}
}

+ (BOOL) doesFileExist:(NSString *)filename {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFile:filename]];
}

+ (NSString*) pathForFileInCache:(NSString *)filename {
    return [self highResVersionOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER] stringByAppendingPathComponent:filename]];
}

+ (NSString*) pathForFileInDocuments:(NSString *)filename {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsPath = [paths objectAtIndex:0];
	return [self highResVersionOfFile:[documentsPath stringByAppendingPathComponent:filename]];
}

+ (BOOL) doesFileExistInDocuments:(NSString *)filename {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFileInDocuments:filename]];
}
         
+ (BOOL) doesFileExistInCache:(NSString *)filename {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self highResVersionOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:CACHE_FOLDER] stringByAppendingPathComponent:filename]]];
}

+ (NSString*) pathForFileInMainBundle:(NSString *)filename {
	return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}

+ (NSString*) pathForFileInMainBundle:(NSString *)filename inDirectory:(NSString *)directory {
	return [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:directory];
}

+ (BOOL) doesFileExistInMainBundle:(NSString *)filename {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFileInMainBundle:filename]];
}

+ (NSString*) pathForDirectory:(NSString *)directory {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:directory];
}

+ (NSString*)highResVersionOfFile:(NSString*)filename {

    if (IS_IPAD_DEVICE) {
        // If there is the specific ipad file, then return that.
        // Otherwise, fallback on the retina file
        NSString * highResFilename = [NSString stringWithFormat:@"%@~ipad.%@", [filename stringByDeletingPathExtension], [filename pathExtension]];
		if ([[NSFileManager defaultManager] fileExistsAtPath:highResFilename]) {
			return highResFilename;
		}
    }
    
	if (IS_RETINA_DISPLAY || IS_IPAD_DEVICE) {
		NSString * highResFilename = [NSString stringWithFormat:@"%@@2x.%@", [filename stringByDeletingPathExtension], [filename pathExtension]];
		if ([[NSFileManager defaultManager] fileExistsAtPath:highResFilename]) {
			return highResFilename;
		}
	}
	return filename;
}

+ (void) removeFilesWithFilter:(NSString*)prefix suffix:(NSString*)suffix
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:CACHE_FOLDER];
	NSError* error;
	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
	for (NSString* filePath in files) {
		if ([filePath hasPrefix:prefix] && [filePath hasSuffix:suffix]) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:filePath];
			XMGLog(@"DELETED %@",fullPath);
			NSError* error;
			[[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
		}
	}
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	documentsDirectory = [paths objectAtIndex:0];
	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
	for (NSString* filePath in files) {
		if ([filePath hasPrefix:prefix] && [filePath hasSuffix:suffix]) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:filePath];
			XMGLog(@"DELETED %@",fullPath);
			NSError* error;
			[[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
		}
	}
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
