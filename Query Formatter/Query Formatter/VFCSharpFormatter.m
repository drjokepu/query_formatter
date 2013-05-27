//
//  VFCSharpFormatter.m
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFCSharpFormatter.h"

@implementation VFCSharpFormatter

-(VFFormatterType)formatterType
{
    return VFFormatterTypeCSharp;
}

-(BOOL)canClean:(NSString *)str
{
    if ([VFCSharpFormatter isVerbatimCSharpString:str])
    {
        return YES;
    }
    else
    {
        return [super canClean:str];
    }
}

+(BOOL)isVerbatimCSharpString:(NSString*)str
{
    NSString *trimmed = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmed hasPrefix:@"@\""] &&  ([trimmed hasSuffix:@"\";"] || [trimmed hasSuffix:@"\""]);
}

-(NSString *)clean:(NSString *)str
{
    if ([VFCSharpFormatter isVerbatimCSharpString:str])
    {
        NSString *trimmed = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        const int suffixLength = [trimmed hasSuffix:@"\";"] ? 3 : 2;
        const NSRange range = NSMakeRange(1, [trimmed length] - suffixLength);
        return [[trimmed substringWithRange:range] stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\""];
    }
    else
    {
        return [super clean:str];
    }
}

-(NSString *)formatAsStringForCopying:(NSString *)str
{
    NSMutableString *formattedString = [[NSMutableString alloc] init];
    
    BOOL first = YES;
    for (NSString *line in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        if (first)
        {
            first = NO;
        }
        else
        {
            [formattedString appendString:@" \" +\n"];
        }
        [formattedString appendString:@"\""];
        [formattedString appendString:[[line stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
    }
    [formattedString appendString:@"\";\n"];
    return formattedString;
}

@end
