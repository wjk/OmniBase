// Copyright 2013 The Omni Group. All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.
//
// $Id$

#import <Foundation/NSObject.h>

/**
 This is a utility class for doing user-preference and environment-variable controlled logging with customizable levels. Log messages are written to the console log and, optionally, to files in iOS (where the console log can be truncated). Typical interaction with the class is via the OBLoggerInitializeLogLevel() macro and by the OBLog() function, perhaps wrapping the later in a custom macro for a particular logger instance.
 */
@interface OBLogger : NSObject
@property (nonatomic, readonly) NSInteger level;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BOOL shouldLogToFile;

/**
 Initializes the logger according to user preferences or environment variables.
 
 If an environment variable matching the name parameter exists and has a numeric value greater than 0, then that is used as the threshold for messages to be logged by the logger. If such an environment variable exists and has a non-numeric value or has the value 0, then nil is returned. Otherwise, if a user preference matching the name parameter exists, it is used similarly.
 Messages sent to the logger---via OBLog()---that are at the preference level or higher are logged. Message with a lower level are ignored.
 If the log level is set at 0, then before returning nil, this method removes any existing log files for 'name'. This allows the logger to clean up after itself when logging is turned off.
 \param name the name of the logger, also used as the name of the environment variable or user preference for setting the logging level and in the name of any files logged.
 \param shouldLogToFile if YES, then log to files in addition to console.
 */
- (id)initWithName:(NSString *)name shouldLogToFile:(BOOL)shouldLogToFile; // We support logging to files for iOS only, where the console is truncated by the system.
- (void)log:(NSString *)format arguments:(va_list)args;
@end

/**
 Log the given format string and arguments to the given logger at the given message priority level.
 \param logger may be nil, in which case the function returns immediately, useful when preferences specify no logging
 \param messageLevel priority level for the current message. Higher levels are more likely to be logged. Level 0 is never logged, so you probably want to start at 1.
 \param format a format string, as in -[NSString initWithFormat:]
 \param ... additional arguments to format string
 */
extern void OBLog(OBLogger *logger, NSInteger messageLevel, NSString *format, ...);

/// Helper for initializing log level globals. Invokes -[OBLogger initWithName:shouldLogToFile] and sets outLogger to point to the result.
extern void _OBLoggerInitializeLogLevel(OBLogger **outLogger, NSString *name, BOOL useFile);
#if defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE
#define OBLoggerInitializeLogLevel(name) _OBLoggerInitializeLogLevel(&name, @#name, YES)
#else
#define OBLoggerInitializeLogLevel(name) _OBLoggerInitializeLogLevel(&name, @#name, NO)
#endif
