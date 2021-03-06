//
//  VFMainWindowController.m
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFMainWindowController.h"
#import "VFQuery.h"

@interface VFMainWindowController ()
@property (nonatomic, strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSPopUpButton *languagePopUpButton;

-(IBAction)formatQuery:(id)sender;
-(IBAction)cleanQuery:(id)sender;

-(IBAction)didClickSpecialCopy:(id)sender;
-(IBAction)didClickSpecialCopyCSharp:(id)sender;
-(IBAction)didClickSpecialCopyObjectiveC:(id)sender;

@end

@implementation VFMainWindowController

-(NSString *)windowNibName
{
    return @"VFMainWindowController";
}

-(void)windowDidLoad
{
    [super windowDidLoad];
    self.textView.font = [NSFont fontWithName:@"Menlo" size:12];
}

-(void)windowWillClose:(NSNotification *)notification
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

-(void)formatQuery:(id)sender
{
    NSString *currentContents = [[NSString alloc] initWithString:[self.textView string]];
    VFQuery *query = [[VFQuery alloc] init];
    query.queryText = currentContents;
    [query formatWithCallback:^(NSString *formattedQuery) {
        NSUndoManager *undoManager = [self.textView undoManager];
        [undoManager registerUndoWithTarget:self
                                   selector:@selector(setQueryText:)
                                     object:currentContents];
        [undoManager setActionName:@"Format"];
        [self.textView setString:formattedQuery];
    }];
}

-(void)setQueryText:(NSString*)queryText
{
    [self.textView setString:queryText];
}

-(void)cleanQuery:(id)sender
{
    NSString *currentContents = [[NSString alloc] initWithString:[self.textView string]];
    VFQuery *query = [[VFQuery alloc] init];
    query.queryText = currentContents;
    NSString *cleanedQuery = [query clean];
    NSUndoManager *undoManager = [self.textView undoManager];
    [undoManager registerUndoWithTarget:self
                               selector:@selector(setQueryText:)
                                 object:currentContents];
    [undoManager setActionName:@"Clean"];
    [self.textView setString:cleanedQuery];
}

-(void)didClickSpecialCopy:(id)sender
{
    [self formatQueryForCopyingWithFormatter:((VFFormatterType)[[self.languagePopUpButton selectedItem] tag])];
}

-(void)didClickSpecialCopyCSharp:(id)sender
{
    [self formatQueryForCopyingWithFormatter:VFFormatterTypeCSharp];
}

-(void)didClickSpecialCopyObjectiveC:(id)sender
{
    [self formatQueryForCopyingWithFormatter:VFFormatterTypeObjectiveC];
}

-(void)formatQueryForCopyingWithFormatter:(VFFormatterType)formatterType
{
    VFQuery *query = [[VFQuery alloc] init];
    query.queryText = [self.textView string];
    NSString *formattedString = [query formatAsStringForCopying:formatterType];
    query = nil;
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:formattedString forType:NSPasteboardTypeString];
}

@end
