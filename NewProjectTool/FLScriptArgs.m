//
//  FLScriptArgs.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 1/1/14.
//  Copyright (c) 2014 FishLamp. All rights reserved.
//

#import "FLScriptArgs.h"

@interface FLScriptArgs()
@property (readonly, strong, nonatomic) NSArray* args;
@end

@implementation FLScriptArgs

@synthesize args = _args;

- (id) init {	
	self = [super init];
	if(self) {
		_args = [[[NSProcessInfo processInfo] arguments] copy];
	}
	return self;
}

- (id)initWithArgs:(const char* []) argsArray count:(int) count
{
    self = [super init];
    if (self) {
        NSMutableArray* args = [[NSMutableArray alloc] initWithCapacity:count];
        for(int i = 0; i < count; i++) {
            [args addObject:[NSString stringWithCString:argsArray[i] encoding:NSUTF8StringEncoding]];
        }
        _args = args;
    }

    return self;
}

- (NSString*) argAtIndex:(int) index {
    return [self.args objectAtIndex:index];
}

- (BOOL) argAtIndex:(int) index equalsString:(NSString*) aString {
    return [[self.args objectAtIndex:index] isEqualToString:aString];
}

- (NSUInteger) count {
    return self.args.count;
}

- (NSString*) description {
    return [self.args description];
}

@end

