//
//  VFQuery.m
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import <Python/Python.h>
#import "VFQuery.h"
#import "VFFormatter.h"
#import "VFCSharpFormatter.h"

static NSOperationQueue *queryOperationQueue = nil;
static NSArray *formatters = nil;

static void setupQueryOperationQueue();
static void setupFormatters();

@implementation VFQuery

-(void)formatWithCallback:(void(^)(NSString *formattedQuery))callback
{
    [VFQuery format:self.queryText callback:callback];
}

+(void)format:(NSString*)query callback:(void(^)(NSString *formattedQuery))callback
{
    setupQueryOperationQueue();
    [queryOperationQueue addOperationWithBlock:^{
        NSString *formattedQuery = [VFQuery format:query];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(formattedQuery);
        }];
    }];
}

+(NSString*)format:(NSString*)query
{
    Py_Initialize();
    
    PyObject *sysPath = PySys_GetObject("path");
    PyObject *path = PyString_FromString((char*)[[NSString pathWithComponents:@[[[NSBundle mainBundle] bundlePath], @"Contents", @"Resources", @"scripts"]] UTF8String]);
    PyList_Insert(sysPath, 0, path);
    Py_DECREF(path);
    path = NULL;
    
    PyObject *sqlparse = PyImport_ImportModule("sqlparse");
    
    PyObject *formatArgs = Py_BuildValue("(s)", [query UTF8String]);    
    PyObject *formatKeywords = PyDict_New();
    PyDict_SetItemString(formatKeywords, "reindent", Py_True);
    
    PyObject *formattedStringObject = PyObject_Call(PyObject_GetAttrString(sqlparse, "format"), formatArgs, formatKeywords);
    Py_DECREF(formatArgs); formatArgs = NULL;
    Py_DECREF(formatKeywords); formatKeywords = NULL;
    
    NSString *formattedString = [[NSString alloc] initWithUTF8String:(const char*)PyString_AsString(formattedStringObject)];
    Py_DECREF(formattedStringObject);
    Py_DECREF(sqlparse);
    return formattedString;
}

-(NSString *)clean
{
    setupFormatters();
    for (VFFormatter *formatter in formatters)
    {
        if ([formatter canClean:self.queryText])
        {
            return [formatter clean:self.queryText];
        }
    }
    return self.queryText;
}

-(NSString *)formatAsStringForCopying:(VFFormatterType)formatterType
{
    setupFormatters();
    
    for (VFFormatter *formatter in formatters)
    {
        if ([formatter formatterType] == formatterType)
        {
            return [formatter formatAsStringForCopying:self.queryText];
        }
    }
    return self.queryText;
}

static void setupQueryOperationQueue()
{
    if (queryOperationQueue == nil)
    {
        queryOperationQueue = [[NSOperationQueue alloc] init];
    }
}

static void setupFormatters()
{
    if (formatters == nil)
    {
        formatters = @[[[VFCSharpFormatter alloc] init]];
    }
}

@end
