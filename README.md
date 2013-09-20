SOSLog-ObjC
===========

<img src="https://raw.github.com/testzugang/soslog-objc/master/assets/sos_logging_objc1.jpg"/>

SOSLog is a small and efficient logging library to use all the features of Powerflasher SOS max (http://sos.powerflasher.com) for logging with Objective-C.


## Features

As alternative for using Xcode's builtin _NSLog_ mechanism _SOSLog_ comes with the following features:
  * **Different log levels:**
  You can use the levels _Trace_, _Debug_, _Info_, _Warn_, _Error_ and _Fatal_.
  * **Global log level:**
  Set a threshold for all components from _Off_ up to _Fatal_.
  * **Individual log level for each component:**
  Set each component's (class) log level individually. This can be done at application startup or any later time.
  * **Configurable log messages:**
  Each log message can be printed with log level, component's name or line number.
  * **Works with the iPhone simulator and test devices:**
  To use a test device only the ip of your system has to be set.
  * **No overhead in the release version of an app:**
  _SOSLog_ doesn't contain any implementation when a release version is build.
  * **<a href="http://sos.powerflasher.com">SOS max</a> features:**
  Search within log messages and filter messages using regular expressions. Log from different sources at the same time, e.q. client and backend.

## How to use SOSLog in a project

To add logging functionality to a class the SOSLog.h header file has to be imported:

  `#import "SOSLog.h"`

A preprocessor macro (`SOSLOGGING`) has to be defined to enable the implementation. To define this variable open the project settings and add the preprocessor macro `SOSLOGGING` within the debug configuration.
<img src="https://raw.github.com/testzugang/soslog-objc/master/assets/SOSLog%20preprocessor%20setting%20XCode%204.png"/>

To configure _SOSLog_ there are some static methods which are more or less optional:

  `[SOSLog setGlobalLogLevel:sos_Warn];` (optional, default is sos_Trace)

  `[SOSLog showLogLevel:YES andComponentName:YES andLineNumber:YES];` (by default only the logged message will be shown)

To enable logging for a component its log level has to be set explicitly:
  `[SOSLog setLogLevel:sos_Trace forComponent:@__FILE__]; // this file's name`

  `[SOSLog setLogLevel:sos_Warn forComponent:@"SOSLoggingDemoViewController.m"];`

To log a message the C function `log(level, format, args)` has to be called where the level is an integer value between 1 and 6. A more convenient way is to use a predefined enum for each level. These are `sos_Trace`, `sos_Debug`, `sos_Info`, `sos_Warn`, `sos_Error` and `sos_Fatal`. Also formatted strings can be used for logging:

  `log(sos_Trace, @"I'm a trace log");`

  `log(sos_Debug, @"You can also use %i instead of sos_Debug", 4);`

  `log(sos_Warn, @"It's getting more serious");`

  `log(sos_Error, @"%i is equal to sos_Error", 2);`

If logging is needed when testing on a device the ip of the os has to be set:

  `[SOSLog setIP:@"192.168.1.1"];`

## How SOSLog works

_SOSLog_ leverages the socket implementation of Steven Frank's _Smallsocket Library_ (http://smallsockets.sourceforge.net/) to establish a connection to SOS max at application startup. Log messages are sent through this connection as binary data.


## License

SOSLog-ObjC is available under the MIT license. See the LICENSE file for more info.

## Changelog

#### 1.5
Sep 20th 2013
* Migration from Google Code (SVN) to GitHub
* Added convenience macros for all log levels (`logd` etc.)

#### 1.4
Jun 12th 2011
 * updated project to XCode 4
 * added new demo project

### 1.3
Mar 28th 2010
 * added unit tests for logging implementation
 * handling when not connected via WLAN or connection to SOS max could not be established
 * checking of component level can be deactivated
 * a log message sent for a component which was not set up with a default log level before will then be registered with global log level. This enables logging for any component without registering it first by setting a log level for it.

#### 1.2
Jan 4th 2010
 * added support for formatted log message
 * fixed EXC_BAD_ACCESS bug

#### 1.1
Sep 5th 2009
 * added version number

#### 1.0
Aug 31st 2009
 * initial commit
