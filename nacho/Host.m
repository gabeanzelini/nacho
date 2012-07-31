//
//  Host.m
//  nacho
//
//  Created by Gabe Anzelini on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Host.h"

@implementation Host
-(id)initWithName:(NSString *)hostName andDictionary:(NSDictionary *)dict{
    _hostName = hostName;
    _dict = dict;
    return self;
}
-(NSString *)hostName{
    return _hostName;
}

-(BOOL)currentState:(NSDictionary *)dict
{
    BOOL hasCurrentState = [[dict allKeys] containsObject:@"current_state"];
    
    if (hasCurrentState && [[dict objectForKey:@"current_state"] intValue] == 0) {
        return true;
    }else{
        for(id obj in [dict allValues])
        {
            if([obj isKindOfClass:[NSDictionary class]]){
                return [self currentState: obj];
            }
        }
    }
    
    return false;
}

-(BOOL)alive{
    return [self currentState:_dict];
}

@end
