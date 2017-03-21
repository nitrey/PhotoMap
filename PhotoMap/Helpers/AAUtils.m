//
//  AAUtils.m
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "AAUtils.h"
#import <UIKit/UIKit.h>

void AALog(NSString *text, ...) {
    
#if LOGS_ENABLED
    
    va_list argumentList;
    va_start(argumentList, text);
    NSLogv(text, argumentList);
    va_end(argumentList);
    
#endif
}

BOOL isIPad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

BOOL isIPhone() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}
