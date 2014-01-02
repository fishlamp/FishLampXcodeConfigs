//
//  FLScriptUtils.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import "FLShellScript.h"

@implementation FLShellScript

static id s_instance = nil;

+ (id) instance {
    return s_instance;
}

@synthesize startDirectory = _startDirectory;

- (id)init
{
    self = [super init];
    if (self) {
        s_instance = self;
        _startDirectory = [self workingDirectory];
        _args = [[FLScriptArgs alloc] init];
    }
    return self;
}

- (NSString*) workingDirectory {
    return [[NSFileManager defaultManager] currentDirectoryPath];
}

- (void) setWorkingDirectory:(NSString *)workingDirectory {
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:workingDirectory];
}

- (FLScriptArgs*) arguments {
    return _args;
}

- (NSString*) pathToSelf {
    return [self.arguments argAtIndex:0];
}

- (void) prepareArguments:(FLScriptArgs*) args withParser:(FLScriptArgsParser*) parser {

}

- (void) run {

}

- (int) runScript {
    @try {
        FLScriptArgsParser* parser = [[FLScriptArgsParser alloc] init];

        [parser setHandlerForArg:@"-?" handler:^(int index) {
            [self printUsage];
        }];

        [self prepareArguments:self.arguments withParser:parser];
        [parser parseWithScriptArgs:self.arguments];

        [self run];
    }
    @catch (NSException* ex) {
        if(ex.reason.length > 0) {
            Log(@"Script Failed: %@", ex.reason);
        }
        return 1;
    }

    return 0;
}

+ (int) runScript {

#if DEBUG
// this allows the debugger time to connect to us.
   [NSThread sleepForTimeInterval:0.25];
#endif

    FLShellScript* script = [[[self class] alloc] init];
    return [script runScript];
}

- (void) printUsage {
    Log(@"Usage:\n");
}

- (void) exitWithFailure:(NSString*) failure, ... {
    NSString* string = @"";

    if(failure) {
        va_list va_args;
        va_start(va_args, failure);
        
        string = [[NSString alloc] initWithFormat:failure arguments:va_args];
        va_end(va_args);
    }

    @throw [NSException exceptionWithName:@"Script failed" reason:string userInfo:nil];

}

- (void) exitWithFailure {
    @throw [NSException exceptionWithName:@"Script failed" reason:@"" userInfo:nil];
}

- (NSString*) willLogString:(NSString*) string {
    return [NSString stringWithFormat:@"[!] %@\n", string];
}

- (void) log:(NSString*) aString, ... {
    if(aString) {
        va_list va_args;
        va_start(va_args, aString);

        NSString* theString = [[NSString alloc] initWithFormat:aString arguments:va_args];
        va_end(va_args);

        printf("%s", [theString cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

@end


