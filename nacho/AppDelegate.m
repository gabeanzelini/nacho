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



static NSString *const NAGIOS_API_URL_KEY = @"NAGIOS_API_URL";
static NSString *const NAGIOS_LINK_URL_KEY = @"NAGIOS_LINK_URL";

-(void)applicationDidFinishLaunching:(NSNotification *)notification{
    
    [self setUpUserDefaults];
    
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:menu];
    [statusItem setImage:[NSImage imageNamed:@"all-good.png"]];
    [statusItem setHighlightMode:YES];
    
    somethingDown = [NSImage imageNamed:@"something-down.png"];
    allGood = [NSImage imageNamed:@"all-good.png"];
    errorFetching = [NSImage imageNamed:@"error-fetching.png"];
    errorSound = [NSSound soundNamed:@"Basso.aiff"];
    
    alreadyBeeped = NO;
    
    
    [self refreshList:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 30
                                             target: self
                                           selector: @selector(refreshList:) 
                                           userInfo: nil 
                                            repeats: YES];
    
}

-(void)setUpUserDefaults{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setValue:@"http://nagios:8080" forKey:NAGIOS_API_URL_KEY];
    [defaultValues setValue:@"http://nagios" forKey:NAGIOS_LINK_URL_KEY];
    
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
    
    
    BOOL allIsGood = YES;
    
    while (host = [enumerator nextObject]) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:host.hostName action:@selector(goToURL:) keyEquivalent:@""];
        [item setTarget:self];
        [menu insertItem:item atIndex:n];
        
        
        if (!host.alive) {
            [item setImage:somethingDown];
            allIsGood = NO;
            [statusItem setImage:somethingDown];
        }
        n = n + 1;
    }
    
    if(!allIsGood && !alreadyBeeped){
        alreadyBeeped = YES;
        [errorSound play];
    }
    
    if(allIsGood){
        alreadyBeeped = NO;
    }
}

- (void)refreshList:(id)sender{
    
    NSURL *domain = [NSURL URLWithString:[userDefaults valueForKey:NAGIOS_API_URL_KEY]];
    
    
    NSArray *hosts = [[[HostStatusFetcher alloc] init] fetchWithUrl:[NSURL URLWithString:@"/state" relativeToURL:domain]];
    
    
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
    
    NSURL *domain = [NSURL URLWithString:[userDefaults valueForKey:NAGIOS_LINK_URL_KEY]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"/extinfo.cgi?type=1&host=%@",sender.title] relativeToURL:domain];
    
    [[NSWorkspace sharedWorkspace] openURL: url];
}
@end
