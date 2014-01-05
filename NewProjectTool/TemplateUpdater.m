//
//  CopyTemplate.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import "TemplateUpdater.h"

#define kConfigFolder @"XcodeBuildSupportConfigs"
#define kProjectTemplate @"ProjectTemplate"
#define kVerbose 0

@implementation TemplateUpdater 

@synthesize verboseOutput = _verboseOutput;
@synthesize count =_count;
@synthesize updatedCount = _updatedCount;
@synthesize destinationPath = _destinationPath;
@synthesize projectName = _projectName;
@synthesize sourcePath = _sourcePath;

- (id)init
{
    self = [super init];
    if (self) {
        self.templateString = TemplateUpdaterDefaultString;
        self.projectName = [self.startDirectory lastPathComponent];
        self.destinationPath = [self.startDirectory stringByAppendingPathComponent:@"XcodeProject"];
        self.sourcePath = [[self.pathToSelf stringByDeletingLastPathComponent] stringByAppendingPathComponent:kProjectTemplate];
    }
    return self;
}

- (BOOL) shouldReplaceExistingFileAtPath:(NSString*) path
                              sourcePath:(NSString*) sourcePath
                        existingContents:(NSString*) existingContents
                        templateContents:(NSString*) templateContents {

    if(existingContents == nil || existingContents.length == 0) {
        return YES;
    }

    if([newContents isEqualToString:destContents]) {
        return NO;
    }

    if([path rangeOfString:@"SharedTargetSettings"].length > 0) {
        Log(@"Skipping file: %@ (to update this file, delete it first.)", path);
        return NO;
    }


    return YES;
}


- (void) updateFileAtPath:(NSString*) destinationPath
           withFileAtPath:(NSString*) sourcePath {

    NSError* error = nil;
    NSString* srcContents = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:&error];

    if(error) {

        if([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == NSFileReadInapplicableStringEncodingError) {
            // this means it's not a text file, eg. a JPG., so we'll just skip it.
            return;
        }

        ThrowError(error);
    }

    NSString* newContents = [srcContents stringByReplacingOccurrencesOfString:self.templateString withString:self.projectName];

    NSString* destContents = [NSString stringWithContentsOfFile:destinationPath encoding:NSUTF8StringEncoding error:&error];

    if(error) {

        if([error.domain isEqualToString:NSCocoaErrorDomain]) {
            switch (error.code) {
                case NSFileReadNoSuchFileError:
                case NSFileNoSuchFileError:
                    destContents = nil;
                    error = nil;
                    break;
            }

        }

        ThrowError(error);
    }

    if( [self shouldReplaceExistingFileAtPath:destinationPath
                                   sourcePath:sourcePath
                             existingContents:destContents
                             templateContents:newContents]) {

        [newContents writeToFile:destinationPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        ThrowError(error);

        _updatedCount++;

        Log(@"Updated: %@", destinationPath);
    }
    else if(self.verboseOutput) {
        Log(@"Unchanged: %@", destinationPath);
    }

    _count++;

}

- (void) createFolderIfNeededAtPath:(NSString*) path {
    NSError* error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(error && !([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == NSFileWriteFileExistsError)) {
        ThrowError(error);
    }
}

- (void) updateOneItemAtPath:(NSString*) destinationPath withItemAtPath:(NSString*) sourcePath {

    BOOL isDir = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir]) {
        if(isDir) {
            [self updateFolderAtPath:destinationPath withFolderAtPath:sourcePath];
        }
        else {
            [self updateFileAtPath:destinationPath withFileAtPath:sourcePath];
        }
    }
    else {
    // wtf?
    }
}

- (NSString*) renameItem:(NSString*) item {

    return [item rangeOfString:self.templateString].length > 0 ?
                [item stringByReplacingOccurrencesOfString:self.templateString withString:self.projectName] :
                item;
}

- (void) updateFolderAtPath:(NSString*) destinationPath
           withFolderAtPath:(NSString*) sourcePath {

    [self createFolderIfNeededAtPath:destinationPath];

    NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:&error];
    ThrowError(error);

    for(NSString* item in contents) {

        if([item characterAtIndex:0] == '.') {
            continue;
        }

        NSString* itemSourcePath = [sourcePath stringByAppendingPathComponent:item];

        NSString* itemDestPath = [destinationPath stringByAppendingPathComponent:[self renameItem:item]];

        [self updateOneItemAtPath:itemDestPath withItemAtPath:itemSourcePath];
    }
}

- (void) printUsage {
    Log(@"Usage:");
    [self log:@"    NewProject -d <DestinationFolder> -p <ProjectName> -v (optional) \n"];
}

- (void) prepareArguments:(FLScriptArgs *)args withParser:(FLScriptArgsParser *)parser {

    [parser setHandlerForArg:@"-v" handler:^(int index) {
        self.verboseOutput = YES;
    }];

    [parser setHandlerForArg:@"-d" handler:^(int index) {

        NSString* path = [args argAtIndex:index + 1];

        path = [self.startDirectory stringByAppendingPathComponent:path];

        self.destinationPath = path;
    }];

    [parser setHandlerForArg:@"-p" handler:^(int index) {
        self.projectName = [args argAtIndex:index+1];
    }];


}

- (void) run {

    if(self.destinationPath.length == 0 || self.projectName.length == 0) {
        [self printUsage];
        [self exitWithFailure];
    }

    self.sourcePath = [self.sourcePath stringByStandardizingPath];
    self.destinationPath = [self.destinationPath stringByStandardizingPath];

    [self updateFolderAtPath:self.destinationPath withFolderAtPath:self.sourcePath];

    Log(@"Installed project \"%@\" at \"%@\"", self.projectName, self.destinationPath);
    Log(@"Updated %d of %d files", self.updatedCount, self.count);
}


@end