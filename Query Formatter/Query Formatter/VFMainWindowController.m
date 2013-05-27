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
-(IBAction)formatQuery:(id)sender;
-(IBAction)cleanQuery:(id)sender;
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

-(void)formatQuery:(id)sender
{
    VFQuery *query = [[VFQuery alloc] init];
    query.queryText = [self.textView string];
    [query formatWithCallback:^(NSString *formattedQuery) {
        [self.textView setString:formattedQuery];
    }];
}

-(void)cleanQuery:(id)sender
{
    VFQuery *query = [[VFQuery alloc] init];
    query.queryText = [self.textView string];
    [self.textView setString:[query clean]];
}

@end
