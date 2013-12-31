//
//  main.m
//  NewProject
//
//  Created by Mike Fullerton on 12/30/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConfigFolder @"XcodeBuildSupportConfigs"
#define kProjectTemplate @"ProjectTemplate"
#define kVerbose 0

#import "TemplateUpdater.h"
#import "Log.h"

int main(int argc, const char * argv[]) {

    @autoreleasepool {

#if DEBUG
        [NSThread sleepForTimeInterval:0.25];
#endif

        if(argc < 1) {
            Log(@"[!] Usage:\n");
            Log(@"    NewProject <DestinationFolder>\n");
            return 1;
        }

        NSString* workingDir = [[NSFileManager defaultManager] currentDirectoryPath];

        NSString* pathToSelf = [[workingDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", argv[0]]] stringByStandardizingPath];

        NSString* templatesPath = [[pathToSelf stringByDeletingLastPathComponent] stringByAppendingPathComponent:kProjectTemplate];

        NSString* newName = [NSString stringWithFormat:@"%s", argv[1]];

        NSString* destinationPath = [[workingDir stringByAppendingPathComponent:newName] stringByStandardizingPath];

        TemplateUpdater* updater = [[TemplateUpdater alloc] init];
        updater.verboseOutput = NO;

        @try {
            [updater updateFolderAtPath:destinationPath
                       withFolderAtPath:templatesPath
                            withNewName:newName];

            Log(@"[!] Installed project at \"%@\"", destinationPath);
            Log(@"[!] Updated %d of %d files", updater.updatedCount, updater.count);
        }
        @catch (NSException *exception) {
            Log(@"[!] Updating Project failed: %@", exception.reason);
            return 1;
        }
    }
    return 0;
}

