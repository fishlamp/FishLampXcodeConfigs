//
//  CopyTemplate.h
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateUpdater : NSObject


@property (readwrite, assign, nonatomic) BOOL verboseOutput;
@property (readonly, assign, nonatomic) int count;
@property (readonly, assign, nonatomic) int updatedCount;

// this will throw an exception if it fail.
- (void) updateFolderAtPath:(NSString*) destinationPath
           withFolderAtPath:(NSString*) sourcePath
                withNewName:(NSString*) newName;


@end

