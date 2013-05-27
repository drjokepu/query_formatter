//
//  VFAppDelegate.m
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFAppDelegate.h"

@interface VFAppDelegate()
@property (nonatomic, strong) VFMainWindowController *mainWindowController;

@end

@implementation VFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self showMainWindow];
}

-(void)showMainWindow
{
    [self createMainWindow];
}

-(void)createMainWindow
{
    self.mainWindowController = [[VFMainWindowController alloc] init];
    [self.mainWindowController showWindow:self];
}

@end
