//
//  VFQuery.h
//  Query Formatter
//
//  Created by Tamas Czinege on 27/05/2013.
//  Copyright (c) 2013 Tamas Czinege. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Python/Python.h>

@interface VFQuery : NSObject
@property (nonatomic, strong) NSString *queryText;

-(void)formatWithCallback:(void(^)(NSString *formattedQuery))callback;

@end
