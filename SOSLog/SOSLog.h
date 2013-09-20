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

// SOSLog.h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SOSLogLevel) {
    sos_Off = 0,
    sos_Fatal,
    sos_Error,
	sos_Warn,
    sos_Info,
    sos_Debug,
    sos_Trace,
};

#if SOSLOGGING
#import "Socket.h"
#define log(level, message, ...){\
[SOSLog log:(int)level fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}
#define log_f(message, ...){\
[SOSLog log:sos_Fatal fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#define log_e(message, ...){\
[SOSLog log:sos_Error fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#define log_w(message, ...){\
[SOSLog log:sos_Warn fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#define log_i(message, ...){\
[SOSLog log:sos_Info fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#define log_d(message, ...){\
[SOSLog log:sos_Debug fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#define log_t(message, ...){\
[SOSLog log:sos_Trace fromFile:[@__FILE__ lastPathComponent] fromLine:__LINE__ withMessage:(NSString *)message,##__VA_ARGS__];\
}

#else
#define log(level, message, ...){}
#define log_f(message, ...){}
#define log_e(message, ...){}
#define log_w(message, ...){}
#define log_i(message, ...){}
#define log_d(message, ...){}
#define log_t(message, ...){}
#endif

@interface SOSLog : NSObject {}

+(void)setIP:(NSString *)theIP;
+(void)setGlobalLogLevel:(int)level;
+(void)setLogLevel:(int)theLevel forComponent:(NSString *)theComponentsName;
+(void)showLogLevel:(BOOL)showLevel andComponentName:(BOOL)showComponentName andLineNumber:(BOOL)showLineNumber;
+(void)log:(int)atLevel fromFile:(NSString *)theFile fromLine:(int)theLine withMessage:(NSString *)theMessage, ... ;

@end
