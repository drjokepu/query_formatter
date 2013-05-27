//
//  VFObjectiveCFormatter.m
//  Query Formatter
//
//  Created by Tamas Czinege on 28/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFObjectiveCFormatter.h"

@implementation VFObjectiveCFormatter

-(VFFormatterType)formatterType
{
    return VFFormatterTypeObjectiveC;
}

-(BOOL)canClean:(NSString *)str
{
    BOOL first = YES;
    for (NSString *line in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (first)
        {
            first = NO;
            if (![trimmedLine hasPrefix:@"@\""])
                return NO;
            if (![trimmedLine hasSuffix:@"\";"] && ![trimmedLine hasSuffix:@"\""])
                return NO;
        }
        else
        {
            if (![trimmedLine hasPrefix:@"\""])
                return NO;
            if (![trimmedLine hasSuffix:@"\";"] && ![trimmedLine hasSuffix:@"\""])
                return NO;
        }
    }
    return YES;
}

-(NSString *)clean:(NSString *)str
{
    if (![self canClean:str]) return str;
    
    NSMutableString *cleanedString = [[NSMutableString alloc] init];
    
    BOOL first = YES;
    for (NSString *line in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        const int prefixLength = first ? 2 : 1;
        NSRange substringRange;
        if ([trimmedLine hasSuffix:@"\";"])
        {
            substringRange = NSMakeRange(prefixLength, [trimmedLine length] - 2 - prefixLength);
        }
        else
        {
            substringRange = NSMakeRange(prefixLength, [trimmedLine length] - 1 - prefixLength);
        }
        
        NSString *cleanedLine = [[[trimmedLine substringWithRange:substringRange] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        [cleanedString appendString:cleanedLine];
        [cleanedString appendString:@"\n"];
        
        if (first)
        {
            first = NO;
        }
    }
    
    return [cleanedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
            [formattedString appendString:@"@\""];
        }
        else
        {
            [formattedString appendString:@" \"\n\" "];
        }
        [formattedString appendString:[[line stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
    }
    [formattedString appendString:@"\";\n"];
    return formattedString;
}

@end
