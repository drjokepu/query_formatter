//
//  VFFormatter.h
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFFormatter : NSObject

-(BOOL)canClean:(NSString*)str;
-(NSString*)clean:(NSString*)str;

@end
