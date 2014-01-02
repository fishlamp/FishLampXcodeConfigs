//
//  FLScriptArgs.h
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLScriptArgs : NSObject {
@private
    NSArray* _args;
}

- (id) initWithArgs:(const char * []) args count:(int) argc;

- (NSString*) argAtIndex:(int) index;
- (BOOL) argAtIndex:(int) index equalsString:(NSString*) aString;
- (NSUInteger) count;

@end