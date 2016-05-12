//
//  JXSpeech.m
//  ChaJian
//
//  Created by dfxd on 16/5/12.
//  Copyright © 2016年 dfxd. All rights reserved.
//

#import "JXSpeech.h"
#import <AppKit/AppKit.h>

@interface JXSpeech()<NSSpeechSynthesizerDelegate>

@end

@implementation JXSpeech
{
    NSSpeechSynthesizer * speech;
}
+ (instancetype)sharedSpeech{
    static JXSpeech * jx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jx = [[JXSpeech alloc] init];
        
    });
    
    return jx;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        speech = [[NSSpeechSynthesizer alloc] init];
        speech.delegate = self;
    }
    return self;
}

- (void)startSpeakingString:(NSString *)string{
    [speech startSpeakingString:string];
}

- (void)stopSpeaking{
    [speech stopSpeaking];
}

- (BOOL)isSpeaking{
    return speech.isSpeaking;
}



#pragma mark - delegate
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking{
    if (finishedSpeaking) {
        self.speakGrade = 0;
    }
}

@end
