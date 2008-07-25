//
//  main.m
//  PYViewTest
//
//  Created by Jjgod Jiang on 7/24/08.
//  Copyright Jjgod Jiang 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PYView.h"

@interface NSApplication (JTKAdditions)
- (void) setAppleMenu:(NSMenu *)menu;
@end

static void create_menus(const char *app_title)
{
    [NSApp setMainMenu: [[[NSMenu alloc] init] autorelease]];
    
    NSMenu *appleMenu;
    NSMenuItem *menuItem;
    NSString *title;
    NSString *appName;
    
    // appName = [[[[NSBundle mainBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension];
    appName = [NSString stringWithUTF8String: app_title];
    appleMenu = [[NSMenu alloc] initWithTitle: @""];
    
    /* Add menu items */
    title = [@"About " stringByAppendingString: appName];
    [appleMenu addItemWithTitle:title 
                         action:@selector(orderFrontStandardAboutPanel:) 
                  keyEquivalent:@""];
    
    [appleMenu addItem:[NSMenuItem separatorItem]];
    
    // Hide AppName
    title = [@"Hide " stringByAppendingString: appName];
    [appleMenu addItemWithTitle:title action: @selector(hide:) keyEquivalent: @"h"];
    
    // Hide Others
    menuItem = (NSMenuItem *)[appleMenu addItemWithTitle: @"Hide Others" 
                                                  action: @selector(hideOtherApplications:) 
                                           keyEquivalent: @"h"];
    [menuItem setKeyEquivalentModifierMask: (NSAlternateKeyMask | NSCommandKeyMask)];
    
    // Show All
    [appleMenu addItemWithTitle: @"Show All" 
                         action: @selector(unhideAllApplications:) 
                  keyEquivalent: @""];
    
    [appleMenu addItem:[NSMenuItem separatorItem]];
    
    // Quit AppName
    title = [@"Quit " stringByAppendingString: appName];
    [appleMenu addItemWithTitle: title 
                         action: @selector(terminate:) 
                  keyEquivalent: @"q"];
    
    /* Put menu into the menubar */
    menuItem = [[NSMenuItem alloc] initWithTitle: @"" 
                                          action: nil 
                                   keyEquivalent: @""];
    [menuItem setSubmenu: appleMenu];
    [[NSApp mainMenu] addItem: menuItem];
    
    /* Tell the application object that this is now the application menu */
    [NSApp setAppleMenu: appleMenu];
    
    /* Finally give up our references to the objects */
    [appleMenu release];
    [menuItem release];
}

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    [NSApplication sharedApplication];
    
    NSWindow *window;
    PYView *view;
    
    NSRect contentRect;
    unsigned int style;
    
    contentRect = NSMakeRect(0, 0, 800, 600);
    style = NSTitledWindowMask | NSMiniaturizableWindowMask | 
    NSClosableWindowMask | NSResizableWindowMask;
    
    window = [[NSWindow alloc] initWithContentRect: contentRect
                                         styleMask: style
                                           backing: NSBackingStoreBuffered
                                             defer: NO];
    [window setOpaque: YES];
    [window center];
    [window setViewsNeedDisplay: NO];
    [window setTitle: @"PYViewTest"];
    [window makeKeyAndOrderFront: nil];
    
    create_menus("PYViewTest");
    
    NSRect viewRect = NSMakeRect(50, 250, 700, 80);
    view = [[PYView alloc] initWithFrame: viewRect
                                fontName: @"FZKai-Z03"
                                   color: [NSColor whiteColor]];
    NSArray *pinyin = [NSArray arrayWithObjects: @"nǐ", @"hǎo", @"zhōng", @"huá", 
                       @"rén", @"mín", @"gòng", @"hé", @"guó", nil];
    PYMarkerItem *item = [[PYMarkerItem alloc] initWithHanzi: @"你好中华人民共和国"
                                                      pinyin: pinyin
                                                        type: 1];
    [view setMarkerItem: item];
    [item release];

    [[window contentView] addSubview: view];
    [window makeFirstResponder: view];    
    
    [NSApp run];
    
    [pool release];
}
