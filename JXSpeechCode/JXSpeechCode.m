//
//  ChaJian.m
//  ChaJian
//
//  Created by dfxd on 16/5/9.
//  Copyright © 2016年 dfxd. All rights reserved.
//

#import "JXSpeechCode.h"
#import <objc/runtime.h>
#import "DVTSourceTextView+Hook.h"
#import "JXSpeech.h"
@interface JXSpeechCode()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@end
  
@implementation JXSpeechCode
{
    NSMenuItem *selecteMenuItem;
}
  
+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        
        
    }
    
    
    
    
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    
    
    
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:NSTextViewDidChangeSelectionNotification object:nil];
    
    //    NSEvent * (^monitor)(NSEvent *);
    //    monitor = ^NSEvent * (NSEvent * theEvent){
    //        NSLog(@"%d",theEvent.keyCode);
    //        [theEvent modifierFlags];
    //
    //        return  theEvent;
    //    };
    //
    //    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:monitor];
    
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Action speech" action:@selector(doMenuAction:) keyEquivalent:@""];
        actionMenuItem.state = 1;
        [actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTag:10080];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        
        selecteMenuItem = [[NSMenuItem alloc] initWithTitle:@"Selecte speech" action:@selector(doMenuAction:) keyEquivalent:@""];
        selecteMenuItem.state = 1;
        [selecteMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [selecteMenuItem setTag:10016];
        [selecteMenuItem setTarget:self];
        [[menuItem submenu] addItem:selecteMenuItem];
        
    }
}

- (void)notificationLog:(NSNotification *)notify
{
    NSLog(@"%@",[notify.object class]);
    if ([notify.object isKindOfClass:[NSTextView class]]) {
        NSTextView * textView = (NSTextView *)notify.object;
        NSArray * ranges = textView.selectedRanges;
        if (ranges.count == 0) {
            return;
        }
        NSRange range = [[ranges objectAtIndex:0] rangeValue];
        
        NSString * text = textView.textStorage.string;
        NSString * selecteText = [text substringWithRange:range];
        
        
        if ([JXSpeech sharedSpeech].speakGrade == 0) {
            if ([JXSpeech sharedSpeech].isSpeaking) {
                [[JXSpeech sharedSpeech] stopSpeaking];
            }
            [[JXSpeech sharedSpeech] startSpeakingString:selecteText];
        }
    }
    
    NSLog(@"%@",notify.object);
    
}

// Sample Action, for menu item:
- (void)doMenuAction:(NSMenuItem *)sender
{
    //    NSLog(@"%ld",(long)sender.state);
    sender.state = sender.state == 0?1:0;
    if (sender.tag == 10016) {
        if (sender.state == 0) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextViewDidChangeSelectionNotification object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:NSTextViewDidChangeSelectionNotification object:nil];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
