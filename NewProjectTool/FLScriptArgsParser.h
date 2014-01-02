//
//  FLScriptArgsParser.h
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLScriptArgs.H"

typedef void (^ArgHandler)(int index);

@interface FLScriptArgsParser : NSObject {
@private
    NSMutableDictionary* _handlers;
}

- (void) setHandlerForArg:(NSString*) arg handler:(ArgHandler) handler;
- (void) parseWithScriptArgs:(FLScriptArgs*) args;

@end
