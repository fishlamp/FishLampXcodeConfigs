//
//  CopyTemplate.h
//  NewProjectTool
//
//  Created by Mike Fullerton on 12/31/13.
//  Copyright (c) 2013 FishLamp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLShellScript.h"

#define TemplateUpdaterDefaultString @"TEMPLATE"

@interface TemplateUpdater : FLShellScript

@property (readwrite, strong, nonatomic) NSString* templateString;

@property (readwrite, strong, nonatomic) NSString* projectName;
@property (readwrite, strong, nonatomic) NSString* destinationPath;
@property (readwrite, strong, nonatomic) NSString* sourcePath;

@property (readwrite, assign, nonatomic) BOOL verboseOutput;
@property (readonly, assign, nonatomic) int count;
@property (readonly, assign, nonatomic) int updatedCount;

@end

