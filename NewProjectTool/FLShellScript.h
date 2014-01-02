//
//  FLScriptUtils.h
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLScriptArgs.h"
#import "FLScriptArgsParser.h"

@interface FLShellScript : NSObject {
@private
    NSString* _startDirectory;
    FLScriptArgs* _args;
}

+ (id) instance;

@property (readonly, strong, nonatomic) NSString* startDirectory;

@property (readwrite, strong, nonatomic) NSString* workingDirectory;

@property (readonly, strong, nonatomic) NSString* pathToSelf;
@property (readonly, strong, nonatomic) FLScriptArgs* arguments;


// typical overrides
- (void) prepareArguments:(FLScriptArgs*) args
               withParser:(FLScriptArgsParser*) parser;

- (void) run;


// utils
- (void) exitWithFailure:(NSString*) failure, ...;
- (void) exitWithFailure;

// optional overrides
- (void) log:(NSString*) aString, ...;

- (NSString*) willLogString:(NSString*) string;

+ (int) runScript;

@end


#define Log(FORMAT...) [[FLShellScript instance] log:[[FLShellScript instance] willLogString:[NSString stringWithFormat:FORMAT]]]

#define ThrowError(error, EXCEPTION_NAME...) \
            do { \
                NSError* __error = error; \
                if(__error) { \
                    NSString* __name = [NSString stringWithFormat:@"" EXCEPTION_NAME]; \
                    @throw [NSException exceptionWithName:__name reason:[__error localizedDescription] userInfo:nil]; \
                } \
            } \
            while(0)
