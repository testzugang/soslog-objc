/*
 Copyright (c) 2009, Meinhard Gredig
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

// SOSLog.m
#if SOSLOGGING
#import "Socket.h"
#endif

#import "SOSLog.h"


#if SOSLOGGING
	static Socket *sosSocket;
	static NSData *termination;
	static int globalLogLevel = 10;
	static NSMutableDictionary *components;
	static BOOL addLevel;
	// TODO add timestamp
	static BOOL addComponentName;
	static BOOL addLineNumber;

const char *const _sos_level_names[] = {
	"Off",
	"Fatal",
	"Error",
	"Warning",
	"Info",
	"Debug",
	"Trace"
};

const char *const _sos_level_short_names[] = {
	"-",
	"F",
	"E",
	"W",
	"I",
	"D",
	"T"
};
#endif

@interface SOSLog (hidden)

+ (void)connectTo:(NSString *)theHost;

@end


@implementation SOSLog

#if SOSLOGGING
+(void)initialize{
	sosSocket = [Socket socket];
	[sosSocket retain];
	
	#if TARGET_IPHONE_SIMULATOR
		NSLog(@"logging in Simulator");
		[SOSLog connectTo:@"localhost"];
		globalLogLevel = sos_Trace;
	#else
		NSLog(@"logging on device, init socket later");
	#endif
}

+(void)setGlobalLogLevel:(int)level{
	if([sosSocket isConnected]){
		globalLogLevel = level;
	}else{
		NSLog(@"socket not connected");
	}
}

+(void)setIP:(NSString *)theIP{
	if(![sosSocket isConnected])
		[SOSLog connectTo:theIP];
}

+(void)connectTo:(NSString *)theHost{
	@try{
		[sosSocket connectToHostName:theHost port:4444];
		const char bytes[] = {0};
		termination = [NSData dataWithBytes:bytes length:1];
		[termination retain];
		NSLog(@"connected: %i", [sosSocket isConnected]);
	}
	@catch (NSException *e) {
		NSLog(@"%@", e);
		globalLogLevel = sos_Off;
	}
}

+(void)setLogLevel:(int)theLevel forComponent:(NSString *)theComponentsName{
    if(!components) {
        components = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
	[components setValue:[NSNumber numberWithInt:theLevel] forKey:[theComponentsName lastPathComponent]];
}

+(void)showLogLevel:(BOOL)showLevel andComponentName:(BOOL)showComponentName andLineNumber:(BOOL)showLineNumber{
	addLevel = showLevel;
	addComponentName = showComponentName;
	addLineNumber = showLineNumber;
}

+(void)log:(int)atLevel fromFile:(NSString *)theFile fromLine:(int)theLine withMessage:(NSString *)theMessage, ...;{
    /*
	NSLog(@"logging enabled: %d %d",
	 [(NSNumber *)[components valueForKey:theFile] intValue],
	 atLevel);
    */
    BOOL logLevelNotMatched = globalLogLevel < atLevel || atLevel == sos_Off;
    if (logLevelNotMatched || (components && [(NSNumber *)[components valueForKey:theFile] intValue] < atLevel)) {
		return;
	}
	
	NSMutableString *add = [[NSMutableString alloc] init];
	if(addLevel){
		[add appendString:[NSString stringWithFormat:@"%s ", _sos_level_short_names[atLevel]]];
	}
	
	if(addComponentName){
		[add appendString:theFile];
		[add appendString:@" "];
	}
	
	if(addLineNumber){
		[add appendString:[NSString stringWithFormat:@"%i ", theLine]];
	}
	
	if([add length] > 0){
		[add appendString:@"- "];
	}
	
	va_list ap;
	NSString *format;
	va_start(ap, theMessage);
	format = [[NSString alloc] initWithFormat:theMessage arguments:ap];
	va_end(ap);
	
	NSString *msg = [NSString stringWithFormat:@"!SOS<showMessage key='%s'>%@%@</showMessage>",
					 _sos_level_names[atLevel],
					 add,
					 format];
    if([sosSocket isConnected]) {
        [sosSocket writeString:msg];
        [sosSocket writeData:termination];
    } else {
        NSLog(@"%@%@", add, format);
    }
    [add release];
    [format release];
}
#else
+ (void)setGlobalLogLevel:(int)level {
}

+ (void)setIP:(NSString *)theIP {
}

+ (void)connectTo:(NSString *)theHost {
}

+ (void)setLogLevel:(int)theLevel forComponent:(NSString *)theComponentsName {
}

+ (void)showLogLevel:(BOOL)showLevel andComponentName:(BOOL)showComponentName andLineNumber:(BOOL)showLineNumber {
}

+ (void)log:(int)atLevel fromFile:(NSString *)theFile fromLine:(int)theLine withMessage:(NSString *)theMessage, ...; {
}

#endif

@end