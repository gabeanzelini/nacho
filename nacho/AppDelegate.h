//
//  AppDelegate.h
//  nacho
//
//  Created by Gabe Anzelini on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSMenu *menu;
    IBOutlet NSTextField *nagiosUrl;
    IBOutlet NSTextField *apiPort;
    IBOutlet NSTextField *refreshInterval;

    NSStatusItem *statusItem;
    NSTimer *timer;
    NSImage *somethingDown;
    NSImage *allGood;
    NSImage *errorFetching;
    NSUserDefaults *userDefaults;
}

- (IBAction)refreshList:(id)sender;
- (IBAction)goToURL:(NSMenuItem *)sender;
@end
