//
//  AAUtils.h
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void AALog(NSString *text, ...);

BOOL isIPad();
BOOL isIPhone();

#define INSTAGRAM_CLIENT_ID @"3ba8d3a5f6874ec0aed2b906ca4856e3"
#define INSTAGRAM_CLIENT_SECRET @"3cfaa88813224a56adb5d84898a48d73"
#define INSTAGRAM_REDIRECT_URI @"https://www.yandex.ru/"
#define INSTAGRAM_ACCESS_TOKEN_URL @"https://api.instagram.com/oauth/access_token"

#define PRINT_RECT(rect) AALog(@"\nRECT origin: %f:%f,\nRECT SIZE: %f:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
