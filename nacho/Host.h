//
//  Host.h
//  nacho
//
//  Created by Gabe Anzelini on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Host : NSObject{
    NSString *_hostName;
    NSDictionary *_dict;
}
-(id)initWithName:(NSString *)hostName andDictionary:(NSDictionary *)dict;
-(NSString *)hostName;
-(BOOL)alive;
@end
