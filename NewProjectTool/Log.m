//
//  Log.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import "Log.h"

void Log(NSString* format, ...) {

    if(format) {
        va_list va_args;
        va_start(va_args, format);
        
        NSString* string = [[NSString alloc] initWithFormat:format arguments:va_args];
        va_end(va_args);

        printf("%s\n", [string cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}