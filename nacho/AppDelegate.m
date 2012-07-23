//
//  AppDelegate.m
//  nacho
//
//  Created by Gabe Anzelini on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <YAJL/YAJL.h>
#import "HostStatusFetcher.h"
#import "Host.h"

@implementation AppDelegate



static NSString *const NAGIOS_URL_KEY = @"NAGIOS_URL";
static NSString *const API_PORT_KEY = @"API_PORT";
static NSString *const REFRESH_INTERVAL_KEY = @"REFRESH_INTERVAL";

-(void)applicationDidFinishLaunching:(NSNotification *)notification{
    
    [self setUpUserDefaults];
    
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:menu];
    [statusItem setImage:[NSImage imageNamed:@"all-good.png"]];
    [statusItem setHighlightMode:YES];
    
    somethingDown = [NSImage imageNamed:@"something-down.png"];
    allGood = [NSImage imageNamed:@"all-good.png"];
    errorFetching = [NSImage imageNamed:@"error-fetching.png"];
    
    
    
    
    [self refreshList:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: [[userDefaults valueForKey:REFRESH_INTERVAL_KEY] intValue]
                                             target: self
                                           selector: @selector(refreshList:) 
                                           userInfo: nil 
                                            repeats: YES];
    
    
}

-(void)setUpUserDefaults{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setValue:@"http://nagios" forKey:NAGIOS_URL_KEY];
    [defaultValues setValue:@"8080" forKey:API_PORT_KEY];
    [defaultValues setValue:[NSNumber numberWithInt:30] forKey:REFRESH_INTERVAL_KEY];
    
    userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:defaultValues];
}


-(void)clearMenu{
    while ([[menu itemArray] count] > 5) {
        [menu removeItemAtIndex:2];
    }
}



-(void)populateMenu:(NSArray *)list{
    NSEnumerator *enumerator = [list objectEnumerator];
    NSInteger n = 2;
    Host *host;
    
    
    [statusItem setImage:allGood];
    
    while (host = [enumerator nextObject]) {
        NSMenuItem *item = [menu insertItemWithTitle: host.hostName
                                              action: @selector(goToURL:) 
                                       keyEquivalent: @"" atIndex:n];
        
        
        if (!host.alive) {
            [item setImage:somethingDown];
            [statusItem setImage:somethingDown];
        }
        n = n + 1;
    }
}

- (void)refreshList:(id)sender{
    
    NSString *domain = [userDefaults valueForKey:NAGIOS_URL_KEY];
    NSString *port = [userDefaults valueForKey:API_PORT_KEY];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/state",domain,port];
    
    
    NSArray *hosts = [[[HostStatusFetcher alloc] init] fetchWithUrl:urlString];
    
    
    [self clearMenu];
    
    if (hosts.count > 0) {
        [self populateMenu:hosts];
    }else{
        [statusItem setImage:errorFetching];
        [menu insertItemWithTitle: @"There was an error getting hosts from the server."
                           action: nil 
                    keyEquivalent: @"" 
                          atIndex: 2];
    }
    
}


-(IBAction)goToURL:(NSMenuItem *)sender{
    NSString *url = [NSString stringWithFormat: [NSString stringWithFormat:@"%@/extinfo.cgi?type=1&host=%@", 
                                                 [userDefaults valueForKey:NAGIOS_URL_KEY], [sender title]]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}
@end
