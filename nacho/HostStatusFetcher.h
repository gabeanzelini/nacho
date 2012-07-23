//
//  HostStatusFetcher.h
//  nacho
//
//  Created by Gabe Anzelini on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostStatusFetcher : NSObject
-(NSArray *)fetchWithUrl:(NSString *)url;
@end
