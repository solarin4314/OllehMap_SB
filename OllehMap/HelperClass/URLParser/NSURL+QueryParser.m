//
//  NSURL+QueryParser.m
//  OllehMap
//
//  Created by 이제민 on 14. 3. 20..
//  Copyright (c) 2014년 이제민. All rights reserved.
//

#import "NSURL+QueryParser.h"

@implementation NSURL (QueryParser)

-(NSDictionary *)queryDictionary
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[self query] componentsSeparatedByString:@"&"]) {
        NSArray *parts = [param componentsSeparatedByString:@"="];
        if([parts count] < 2) continue;
        [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
    }
    return params;
}

@end
