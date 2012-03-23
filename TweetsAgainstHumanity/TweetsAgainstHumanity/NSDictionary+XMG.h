/**
 *  \file       NSDictionary+XMG.h
 *  \author     Adam Telfer
 *  \date       11-01-25
 *  \ingroup    Pirates
 **/

/**
 *  \class      NSDictionary_XMG
 *  \extends    
 *  \implements 
 *  \brief      
 *  \details    
 **/
#define NSDictionaryExceptionBadKeys @"NSDictionaryExceptionBadKeys"
#define NSDictionaryExceptionBadValues @"NSDictionaryExceptionBadValues"

@interface NSDictionary (XMG)

- (BOOL) hasKey:(NSString*)key;

- (id) assertForKey:(NSString*)key;
- (id) assertForKey:(NSString *)key withClass:(Class)c;

- (id) safeForKey:(NSString*)key orElse:(id)value;
- (int) intForKey:(NSString*)key orElse:(int)value;
- (float) floatForKey:(NSString*)key orElse:(float)value;
- (BOOL) boolForKey:(NSString*)key orElse:(BOOL)value;

- (id) randomObjectForKey:(NSString*)key;

// Throws an exception if the objects or keys are bad, this is better then a crash or assert
+ (id) safeDictionaryWithObjects:(NSArray*)objects forKeys:(NSArray*)keys;

@end

@interface NSMutableDictionary (XMG)

- (BOOL) hasKey:(NSString*)key;

- (id) assertForKey:(NSString*)key;
- (id) assertForKey:(NSString *)key withClass:(Class)cl;

- (id) safeForKey:(NSString*)key orElse:(id)value;
- (int) intForKey:(NSString*)key orElse:(int)value;
- (float) floatForKey:(NSString*)key orElse:(float)value;
- (BOOL) boolForKey:(NSString*)key orElse:(BOOL)value;

// Throws an exception if the objects or keys are bad, this is better then a crash or assert
+ (id) safeDictionaryWithObjects:(NSArray*)objects forKeys:(NSArray*)keys;

@end

@interface NSArray (XMG)

- (id) randomItem;

@end
