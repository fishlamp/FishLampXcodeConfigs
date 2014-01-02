//
//  FLScriptArgsParser.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import "FLScriptArgsParser.h"

@implementation FLScriptArgsParser

- (id)init
{
    self = [super init];
    if (self) {
        _handlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setHandlerForArg:(NSString*) arg handler:(ArgHandler) handler {
    [_handlers setObject:handler forKey:arg];
}

- (void) parseWithScriptArgs:(FLScriptArgs*) args {

    for(int i = 1; i < args.count; i++) {

        NSString* arg = [args argAtIndex:i];

        ArgHandler handler = [_handlers objectForKey:arg];
        if(handler) {
            handler(i);
        }
    }
}

@end
