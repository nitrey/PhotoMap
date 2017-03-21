//
//  AAUtils.h
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

void AALog(NSString *text, ...);

BOOL isIPad();
BOOL isIPhone();

#define PRINT_RECT(rect) AALog(@"\nRECT origin: %f:%f,\nRECT SIZE: %f:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
