//
//  HostStatusFetcher.m
//  nacho
//
//  Created by Gabe Anzelini on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HostStatusFetcher.h"
#import <YAJL/YAJL.h>
#import "Host.h"

@implementation HostStatusFetcher
-(NSArray *)fetchWithUrl:(NSString *)url{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    if(error){
        return [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    NSString *bodyString = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = [[bodyString yajl_JSON] objectForKey:@"content"];

    NSMutableArray *hosts = [[NSMutableArray alloc] initWithCapacity:[[dict allKeys] count]];

    NSEnumerator *enumerator = [dict keyEnumerator];
    
    NSString *hostName;
    

    
    while (hostName = [enumerator nextObject]) {
        [hosts addObject:[[Host alloc] initWithName: hostName 
                                      andDictionary: [dict objectForKey:hostName]]];
    }
    
    return hosts;
}
@end
