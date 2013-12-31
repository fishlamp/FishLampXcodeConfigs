//
//  OldUtils.m
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import "OldUtils.h"

#define kConfigFolder @"XcodeBuildSupportConfigs"
#define kProjectTemplate @"ProjectTemplate"

#define kTemplate @"TEMPLATE"

//BOOL CheckFileAtPath(NSString* path) {
//
//    return YES;
//
////    static NSString* const s_extensions = xcde
//
//    CFStringRef fileExtension = (__bridge CFStringRef) [path pathExtension];
//    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
//
//    BOOL checkFile = NO;
//
//    if (UTTypeConformsTo(fileUTI, kUTTypeText)) {
//        checkFile = YES;
//    }
//
//    CFRelease(fileUTI);
//
//    return checkFile;
//
//}
#if OLD

int main(int argc, const char * argv[]) {

    @autoreleasepool {

        if(argc < 1) {
            Log(@"[!] Usage:\n");
            Log(@"    NewProject <DestinationFolder>\n");
            return 1;
        }

        NSString* workingDir = [[NSFileManager defaultManager] currentDirectoryPath];

        NSString* pathToSelf = [workingDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", argv[0]]];

        NSString* templatesPath = [[pathToSelf stringByDeletingLastPathComponent] stringByAppendingPathComponent:kProjectTemplate];

        NSString* settingsPath = [[pathToSelf stringByDeletingLastPathComponent] stringByAppendingPathComponent:kConfigFolder];

        NSString* newName = [NSString stringWithFormat:@"%s", argv[1]];

        NSString* newSettingsPath = [[workingDir stringByAppendingPathComponent:newName] stringByAppendingPathComponent:kConfigFolder];

        NSString* destinationPath = [[workingDir stringByAppendingPathComponent:newName] stringByStandardizingPath];

#if kVebose
        log(@"path to templates: %@", templatesPath);
#endif

        NSError* error = nil;
        RemoveDestinationIfNeeded(destinationPath, &error);

        if(!error) {
            CopyTemplate(templatesPath, destinationPath, &error);
        }

        if(!error) {
            [[NSFileManager defaultManager] copyItemAtPath:settingsPath toPath:newSettingsPath error:&error];
        }

        if(error) {
            printf("[!] %s\n", [error.localizedDescription cStringUsingEncoding:NSUTF8StringEncoding]);
            exit(1);
        }


    }
    return 0;
}

#endif  


#if OLD
        NSError* error = nil;
        RemoveDestinationIfNeeded(destinationPath, &error);

        if(!error) {
            CopyTemplate(templatesPath, destinationPath, &error);
        }

        if(!error) {
            [[NSFileManager defaultManager] copyItemAtPath:settingsPath toPath:newSettingsPath error:&error];
        }

        if(error) {
            printf("[!] %s\n", [error.localizedDescription cStringUsingEncoding:NSUTF8StringEncoding]);
            exit(1);
        }
#endif

BOOL FixFileContents(NSString* path, NSString* newName, NSError** error) {

    NSError* aError = nil;
    NSString* contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&aError];

    if(aError) {

        if([aError.domain isEqualToString:NSCocoaErrorDomain] && aError.code == NSFileReadInapplicableStringEncodingError) {
            // this means it's not a text file, eg. a JPG., so we'll just skip it.
            return YES;
        }

        if(error) {
            *error = aError;
        }

        return NO;
    }

    NSString* newContents = [contents stringByReplacingOccurrencesOfString:kTemplate withString:newName];

    if( ![newContents isEqualToString:contents]) {

        [newContents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&aError];

        if(aError) {

            if(error) {
                *error = aError;
            }

            return NO;
        }

#if kVebose
        NSLog(@"Updated file %@", fullSubPath);
#endif
    }

    return YES;
}

BOOL RenameFolders(NSString* path, NSString* toName, NSError** error) {

    NSError* aError = nil;

    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&aError];

    if(aError) {

        if(error) {
            *error = aError;
        }

        return NO;
    }

    for(NSString* item in contents) {

        if([item characterAtIndex:0] == '.') {
            continue;
        }

        NSString* fullSubPath = [path stringByAppendingPathComponent:item];

        BOOL isDir = NO;
        if( [[NSFileManager defaultManager] fileExistsAtPath:fullSubPath isDirectory:&isDir]) {

            if(isDir) {
                if(!RenameFolders(fullSubPath, toName, error)) {
                    return NO;
                }
            }
            else {
                if(!FixFileContents(fullSubPath, toName, error)) {
                    return NO;
                }
            }

            if([item rangeOfString:kTemplate].length > 0) {

                NSString* newName = [item stringByReplacingOccurrencesOfString:kTemplate withString:toName];

                NSString* newPath = [path stringByAppendingPathComponent:newName];

                [[NSFileManager defaultManager] moveItemAtPath:fullSubPath toPath:newPath error:&aError];

                if(aError) {

                    if(error) {
                        *error = aError;
                    }

                    return NO;
                }

    #if kVebose
                NSLog(@"Renamed:\n%@\n%@\n", fullSubPath, newPath);
    #endif
            }
        }
    }

    return YES;
}

#define CheckError(inError, localError) \
    do { \
        if(localError) { \
            if(inError) { \
                *inError = localError; \
            } \
            return NO; \
        } \
    } while(0)

BOOL RemoveExtras(NSString* fromPath, NSError** error) {

    static NSString* const extras[] = {
        kConfigFolder
    };

    for(int i = 0; i < (sizeof(extras) / sizeof(NSString*)); i++) {

        NSString* thePathToRemove = [fromPath stringByAppendingPathComponent:extras[i] ];

        NSError* aError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:thePathToRemove error:&aError];

        if(aError && ![aError.domain isEqualToString:NSCocoaErrorDomain] && aError.code != NSFileNoSuchFileError) {

            if(error) {
                *error = aError;
            }

            return NO;
        }

    }

    return YES;
}

BOOL CopyTemplate(NSString* from, NSString* newPath, NSError** error) {

    NSError* aError = nil;
    [[NSFileManager defaultManager] copyItemAtPath:from toPath:newPath error:&aError];

    if(aError) {

        if(error) {
            *error = aError;
        }

        return NO;
    }

    if(!RenameFolders(newPath, [newPath lastPathComponent], error)) {
        return NO;
    }

    if(!RemoveExtras(newPath, error)) {
        return NO;
    }

    return YES;
}

BOOL GetYesFromUser() {

    char response = getchar();

    return response == 'y' || response == 'Y';
}

BOOL RemoveDestinationIfNeeded(NSString* destination, NSError** error) {

    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:&isDir] && isDir) {

        printf("[!] Project already exists at: \"%s\"\n", [destination cStringUsingEncoding:NSUTF8StringEncoding]);
        printf("[!] Continuing will completely delete and recreate this project.\n");
        printf("[!] Continue? [Y,N,Q]: ");

        if (GetYesFromUser()) {

            NSError* aError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:destination error:error];

            if(aError) {

                if(error) {
                    *error = aError;
                }

                return NO;
            }

        }
        else {
            printf("[!] bye.\n");
            exit(1);

            return NO;
        }
    }


    return YES;
}
