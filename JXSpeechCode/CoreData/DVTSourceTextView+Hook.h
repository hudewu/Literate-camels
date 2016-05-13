//
//  DVTSourceTextView+Hook.h
//  ChaJian
//
//  Created by dfxd on 16/5/11.
//  Copyright © 2016年 dfxd. All rights reserved.
//

#import "DVTSourceTextView.h"
@interface DVTSourceTextView (Hook)
  
@property(nonatomic,strong)NSSpeechSynthesizer * speech;
- (void)jx_selectFirstPlaceholderInCharacterRange:(struct _NSRange)arg1;

@end
