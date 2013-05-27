//
//  VFFormatter.m
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFFormatter.h"

@implementation VFFormatter

-(VFFormatterType)formatterType
{
    return VFFormatterTypeUnknown;
}

-(BOOL)canClean:(NSString *)str
{
    return NO;
}

-(NSString *)clean:(NSString *)str
{
    return str;
}

-(NSString *)formatAsStringForCopying:(NSString *)str
{
    return str;
}

@end
