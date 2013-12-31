//
//  CopyTemplate.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import "TemplateUpdater.h"
#import "Log.h"

#define kTemplate @"TEMPLATE"

#define ThrowError(error) \
            do { \
                NSError* __error = error; \
                if(__error) { \
                    @throw [NSException exceptionWithName:@"Copy Failed" reason:[__error localizedDescription] userInfo:nil]; \
                } \
            } \
            while(0)

@implementation TemplateUpdater 

@synthesize verboseOutput = _verboseOutput;
@synthesize count =_count;
@synthesize updatedCount = _updatedCount;

- (NSString*) renameItem:(NSString*) item newName:(NSString*) newName {

    return [item rangeOfString:kTemplate].length > 0 ?
                [item stringByReplacingOccurrencesOfString:kTemplate withString:newName] :
                item;
}

- (void) updateFileAtPath:(NSString*) destinationPath
           withFileAtPath:(NSString*) sourcePath
                  newName:(NSString*) newName {

    NSError* error = nil;
    NSString* srcContents = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:&error];

    if(error) {

        if([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == NSFileReadInapplicableStringEncodingError) {
            // this means it's not a text file, eg. a JPG., so we'll just skip it.
            return;
        }

        ThrowError(error);
    }

    NSString* newContents = [srcContents stringByReplacingOccurrencesOfString:kTemplate withString:newName];

    NSString* destContents = [NSString stringWithContentsOfFile:destinationPath encoding:NSUTF8StringEncoding error:&error];

    if(error) {

        if([error.domain isEqualToString:NSCocoaErrorDomain]) {
            switch (error.code) {
                case NSFileReadNoSuchFileError:
                case NSFileNoSuchFileError:
                    destContents = @"";
                    error = nil;
                    break;
            }

        }

        ThrowError(error);
    }

    if( ![newContents isEqualToString:destContents]) {
        [newContents writeToFile:destinationPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        ThrowError(error);

        _updatedCount++;

        Log(@"[!] Updated: %@", destinationPath);
    }
    else if(self.verboseOutput) {
        Log(@"[!] Unchanged: %@", destinationPath);
    }

    _count++;

}

- (void) updateOneItemAtPath:(NSString*) destinationPath withItemAtPath:(NSString*) sourcePath newName:(NSString*) newName {

    BOOL isDir = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir]) {
        if(isDir) {
            [self updateFolderAtPath:destinationPath withFolderAtPath:sourcePath withNewName:newName];
        }
        else {
            [self updateFileAtPath:destinationPath withFileAtPath:sourcePath newName:newName];
        }
    }
    else {
    // wtf?
    }
}

- (void) updateFolderAtPath:(NSString*) destinationPath
           withFolderAtPath:(NSString*) sourcePath
                withNewName:(NSString*) newName {

    NSError* error = nil;

    [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error];
    if(error && !([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == NSFileWriteFileExistsError)) {
        ThrowError(error);
    }

    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:&error];
    ThrowError(error);

    for(NSString* item in contents) {

        if([item characterAtIndex:0] == '.') {
            continue;
        }

        NSString* itemSourcePath = [sourcePath stringByAppendingPathComponent:item];

        NSString* itemDestPath = [destinationPath stringByAppendingPathComponent:[self renameItem:item newName:newName]];

        [self updateOneItemAtPath:itemDestPath withItemAtPath:itemSourcePath newName:newName];
    }
}

@end