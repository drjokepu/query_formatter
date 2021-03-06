//
//  VFCStyleFormatter.m
//  Query Formatter
//
//  Created by Tamas Czinege on 28/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import "VFCStyleFormatter.h"

@implementation VFCStyleFormatter

-(BOOL)canClean:(NSString *)str
{
    for (NSString *line in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedLine length] == 0) continue;
        if (![trimmedLine hasPrefix:@"\""])
            return NO;
        if (![trimmedLine hasSuffix:@"\" +"] && ![trimmedLine hasSuffix:@"\"+"] &&
            ![trimmedLine hasSuffix:@"\";"] && ![trimmedLine hasSuffix:@"\""])
            return NO;
    }
    return YES;
}

-(NSString *)clean:(NSString *)str
{
    if (![self canClean:str]) return str;
    
    NSMutableString *cleanedString = [[NSMutableString alloc] init];
    
    for (NSString *line in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedLine length] == 0) continue;
        
        NSRange substringRange;
        if ([trimmedLine hasSuffix:@"\" +"])
        {
            substringRange = NSMakeRange(1, [trimmedLine length] - 4);
        }
        else if ([trimmedLine hasSuffix:@"\""])
        {
            substringRange = NSMakeRange(1, [trimmedLine length] - 2);
        }
        else
        {
            substringRange = NSMakeRange(1, [trimmedLine length] - 3);
        }
        
        NSString *cleanedLine = [[[trimmedLine substringWithRange:substringRange] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        [cleanedString appendString:cleanedLine];
        [cleanedString appendString:@"\n"];
    }
    
    return [cleanedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
