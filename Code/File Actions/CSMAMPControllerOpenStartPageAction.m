//
//  CSMAMPControllerOpenStartPageAction.m
//  MAMP-Controller.sugar
//
//  Created by Nicholas Penree on 4/11/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSMAMPControllerOpenStartPageAction.h"
#import <EspressoFileActions.h>
#import <NSString+MRFoundation.h>
#import "GetPID.h"

@implementation CSMAMPControllerOpenStartPageAction

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath
{
	self = [super init];
	if (self == nil)
		return nil;
	
	page = [[dictionary objectForKey:@"page"] retain];
	pathForMAMP = [[dictionary objectForKey:@"CSMAMPPath"] retain];
	
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)dealloc
{	
	[page autorelease];
	[pathForMAMP autorelease];
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canPerformActionWithContext:(id)context
{
	const int kPIDArrayLength = 10;
	pid_t myArray[kPIDArrayLength];
	unsigned int numberMatches;
	int error;
	
	if (!port) {
		NSString *fileName = [[[pathForMAMP stringByAppendingPathComponent:@"conf"] stringByAppendingPathComponent:@"apache"] stringByAppendingPathComponent:@"httpd.conf"];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
			
			NSString *confFile = [[NSString alloc] initWithContentsOfFile:fileName];
			NSRange range = [confFile rangeOfString:@"Listen" options:NSBackwardsSearch];
			
			if (range.location == NSNotFound)
				return NO;
			
			NSString *crap = [confFile substringFromIndex:(range.location + range.length + 1)];
			port = [crap substringWithRange:NSMakeRange(0, 4)];
			
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:pathForMAMP]) {
				error = GetAllPIDsForProcessName("httpd", myArray, kPIDArrayLength, &numberMatches, NULL);
					
				if (error == 0) { // Success
					if (numberMatches >= 1) {
						return YES;
					}
				}
			}
		}
	} else {
		if ([[NSFileManager defaultManager] fileExistsAtPath:pathForMAMP]) {
			error = GetAllPIDsForProcessName("httpd", myArray, kPIDArrayLength, &numberMatches, NULL);
			if (error == 0) { if (numberMatches >= 1) return YES; }
		}
		return NO;
	}
	
	return NO;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError
{
	
	@try {
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Preferences/com.living-e.MAMP.plist" stringByExpandingTildeInPath]];
		NSString *urlToOpen;
		
		if (!page || [page isEqualToString:@""]) {
			urlToOpen = [dict objectForKey:@"startPage"];
		} else {
			urlToOpen = page;
		}
		
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%@%@", port, urlToOpen]]];
		
		return YES;		
	}
	@catch (NSException * e) {
		return NO;
	}
	
	return NO;
}

@end
