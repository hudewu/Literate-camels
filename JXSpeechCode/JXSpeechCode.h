//
//  JXSpeechCode.h
//  JXSpeechCode
//
//  Created by dfxd on 16/5/12.
//  Copyright © 2016年 dfxd. All rights reserved.
//

#import <AppKit/AppKit.h>

@class JXSpeechCode;

static JXSpeechCode *sharedPlugin;

@interface JXSpeechCode : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end