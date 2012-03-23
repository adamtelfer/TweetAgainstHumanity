/**
 *  \file       NSDictionary+XMG.m
 *  \author     Adam Telfer
 *  \date       11-01-25
 *  \ingroup    Pirates
 **/

#import "NSDictionary+XMG.h"
#import "Category.h"
#import "XMGMacros.h"

FIX_CATEGORY_BUG(NSDictionary_XMG);

@implementation NSDictionary (XMG)

- (BOOL) hasKey:(NSString*)key
{
	return [[self allKeys] containsObject:key];
}

- (id) assertForKey:(NSString*)key
{
	if ([self hasKey:key]) {
		return [self objectForKey:key];
	} else {
		NSString* errorMsg = [NSString stringWithFormat:@"Assertion Error : dictionary does not containt key '%@'",key];
		[NSException raise:NSInternalInconsistencyException format:@"%@",errorMsg];
		return nil;
	}
}

- (id) assertForKey:(NSString *)key withClass:(Class)cl
{
	NSObject* o = [self assertForKey:key];
	if ([o isKindOfClass:cl]) {
		return o;
	} else {
		NSString* errorMsg = [NSString stringWithFormat:@"Assertion Error : dictionary element for key '%@' is not of type '%@'",key,NSStringFromClass(cl)];
		[NSException raise:NSInternalInconsistencyException format:@"%@",errorMsg];
	}
	return nil;
}

- (id) randomObjectForKey:(NSString*)key
{
	NSObject* obj = [self assertForKey:key];
	if ([obj isKindOfClass:[NSArray array]]) {
		NSArray* arr = (NSArray*)obj;
		int ind = rand() % [arr count];
		return [arr objectAtIndex:ind];
	} else {
		return obj;
	}
}

- (id) safeForKey:(NSString*)key orElse:(id)value
{
	if ([self hasKey:key]) {
		return [self objectForKey:key];
	} else {
		return value;
	}
}

- (int) intForKey:(NSString*)key orElse:(int)value
{
	return [[self safeForKey:key orElse:[NSNumber numberWithInt:value]] intValue];
}

- (float) floatForKey:(NSString*)key orElse:(float)value
{
	return [[self safeForKey:key orElse:[NSNumber numberWithFloat:value]] floatValue];
}

- (BOOL) boolForKey:(NSString*)key orElse:(BOOL)value
{
	return [[self safeForKey:key orElse:[NSNumber numberWithBool:value]] boolValue];
}

+ (id) safeDictionaryWithObjects:(NSArray*)objects forKeys:(NSArray*)keys
{
	if ([objects count] != [keys count]) {
		NSLog(NSDictionaryExceptionBadKeys);
		[NSException raise:NSDictionaryExceptionBadKeys format:@""];
		return nil;
	}
	for (id Object in objects) {
		if (Object == nil) {
			NSLog(NSDictionaryExceptionBadValues);
			[NSException raise:NSDictionaryExceptionBadValues format:@""];
			return nil;
		}
	}
	return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

@end

@implementation NSMutableDictionary (XMG)

- (BOOL) hasKey:(NSString*)key
{
	return [[self allKeys] containsObject:key];
}

- (id) assertForKey:(NSString*)key
{
	if ([self hasKey:key]) {
		return [self objectForKey:key];
	} else {
		NSString* errorMsg = [NSString stringWithFormat:@"Assertion Error : dictionary does not containt key '%@'",key];
		[NSException raise:NSDictionaryExceptionBadKeys format:@"%@", errorMsg];
		return nil;
	}
}

- (id) assertForKey:(NSString *)key withClass:(Class)cl
{
	NSObject* o = [self assertForKey:key];
	if ([o isKindOfClass:cl]) {
		return o;
	} else {
		NSString* errorMsg = [NSString stringWithFormat:@"Assertion Error : dictionary element for key '%@' is not of type '%@'",key,NSStringFromClass(cl)];
		[NSException raise:NSInternalInconsistencyException format:@"%@",errorMsg];
	}
	return nil;
}

- (id) safeForKey:(NSString*)key orElse:(id)value
{
	if ([self hasKey:key]) {
		return [self objectForKey:key];
	} else {
		return value;
	}
}

- (float) floatForKey:(NSString*)key orElse:(float)value
{
	return [[self safeForKey:key orElse:[NSNumber numberWithFloat:value]] floatValue];
}

- (BOOL) boolForKey:(NSString*)key orElse:(BOOL)value
{
	return [[self safeForKey:key orElse:[NSNumber numberWithBool:value]] boolValue];
}
		 
- (id) randomObjectForKey:(NSString*)key
{
	NSObject* obj = [self assertForKey:key];
	if ([obj isKindOfClass:[NSArray array]]) {
		NSArray* arr = (NSArray*)obj;
		int ind = rand() % [arr count];
		return [arr objectAtIndex:ind];
	} else {
		return obj;
	}
}

+ (id) safeDictionaryWithObjects:(NSArray*)objects forKeys:(NSArray*)keys
{
	if ([objects count] != [keys count]) {
		[NSException raise:NSDictionaryExceptionBadKeys format:@""];
		return nil;
	}
	for (id Object in objects) {
		if (Object == nil) {
			[NSException raise:NSDictionaryExceptionBadValues format:@""];
			return nil;
		}
	}
	return [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
}

@end
