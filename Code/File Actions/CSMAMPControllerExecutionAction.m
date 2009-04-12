//
//  CSMAMPControllerExecutionAction.m
//  MAMP-Controller.sugar
//
//  Created by Nicholas Penree on 4/10/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSMAMPControllerExecutionAction.h"
#import <EspressoFileActions.h>
#import <NSString+MRFoundation.h>
#import "GetPID.h"

@implementation CSMAMPControllerExecutionAction

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath
{
	self = [super init];
	if (self == nil)
		return nil;
	
	action = [[dictionary objectForKey:@"action"] retain];
	pathForMAMP = [[dictionary objectForKey:@"CSMAMPPath"] retain];
	
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)dealloc
{	
	[action autorelease];
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
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:pathForMAMP]) {
		if ([action isEqualToString:@"stop"] || [action isEqualToString:@"restart"]) {
			error = GetAllPIDsForProcessName("httpd", myArray, kPIDArrayLength, &numberMatches, NULL);
			
			if (error == 0) { // Success
				if (numberMatches >= 1) {
					return YES;
				}
			}
		} else if ([action isEqualToString:@"start"]) {
			return YES;
		}
	}
	
	return NO;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError
{
	NSString *cmd;
	if ([action isEqualToString:@"start"]) {
		cmd = [[pathForMAMP stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"start.sh"];
	} else if ([action isEqualToString:@"stop"]) {
		cmd = [[pathForMAMP stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"stop.sh"];
	} else if ([action isEqualToString:@"restart"]) {
		//cmd = [[pathForMAMP stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"start.sh"];
	} else {
		return NO;
	}
	
	system([cmd UTF8String]);
	/*NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:cmd];

    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
	
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
	
    [task launch];
	
    NSData *data;
    data = [file readDataToEndOfFile];
	
    NSString *string;
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog (@"got: %@", string);*/
	
	return YES;
}

@end
