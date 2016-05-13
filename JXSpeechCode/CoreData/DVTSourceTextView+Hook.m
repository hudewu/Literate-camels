//
//  DVTSourceTextView+Hook.m
//  ChaJian
//
//  Created by dfxd on 16/5/11.
//  Copyright © 2016年 dfxd. All rights reserved.
//

#import "DVTSourceTextView+Hook.h"
#import <objc/runtime.h>
#import "NSString+JXRegular.h"
#import "JXSpeech.h"
  
static NSSpeechSynthesizer * speech;
@implementation DVTSourceTextView (Hook)


- (NSSpeechSynthesizer *)speech{
    return objc_getAssociatedObject(self,&speech);
}

- (void)setSpeech:(NSSpeechSynthesizer *)speech{
    objc_setAssociatedObject(self, &speech, speech, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    
    //NSString *className = NSStringFromClass([self class]);
    //const char *cClassName = [className UTF8String];
    //id theClass = objc_getClass(cClassName);
    //unsigned int outCount;
    //Method *m =  class_copyMethodList(theClass,&outCount);
    
    //NSLog(@"%d",outCount);
    //for (int i = 0; i<outCount; i++) {
        //SEL a = method_getName(*(m+i));
        //NSString *sn = NSStringFromSelector(a);
        //NSLog(@"%@",sn);
    //}
    speech = [[NSSpeechSynthesizer alloc] init];

    Method obj1 = class_getInstanceMethod(self, @selector(jx_selectFirstPlaceholderInCharacterRange:));
    Method obj2 = class_getInstanceMethod(self , @selector(selectFirstPlaceholderInCharacterRange:));
    method_exchangeImplementations(obj1, obj2);
   
}



-(void)jx_selectFirstPlaceholderInCharacterRange:(struct _NSRange)arg1{
    NSLog(@"--------%@",NSStringFromRange(arg1));
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    NSMenuItem *manuAction = [[menuItem submenu] itemWithTag:10080];
    if (manuAction.state == 1) {
        NSString * inputText = [self.textStorage.string substringWithRange:arg1];
        NSString * expression = @"[a-zA-Z][a-z]*[a-z]";
        NSString * expressionRemove = @"(<#)[^#>]*(#>)";
        NSArray<NSTextCheckingResult *> * array = [inputText getTheResultFromTheExpression:expressionRemove];
        NSMutableString * mString = [NSMutableString stringWithString:inputText];
        for (NSUInteger i = 0; i < array.count; i++) {
            NSTextCheckingResult * result = [array objectAtIndex:(array.count - i - 1)];
            [mString deleteCharactersInRange:result.range];
        }
        NSArray * wordArray = [mString getTheTextFromTheExpression:expression];
        NSMutableString * newString = [NSMutableString string];
        for (NSString * str in wordArray) {
            [newString appendString:str];
        }
        
        if ([JXSpeech sharedSpeech].isSpeaking) {
            [[JXSpeech sharedSpeech] stopSpeaking];
        }
        [[JXSpeech sharedSpeech] startSpeakingString:newString];
        [JXSpeech sharedSpeech].speakGrade = 1;
    }

    [self jx_selectFirstPlaceholderInCharacterRange:arg1];
}



@end
