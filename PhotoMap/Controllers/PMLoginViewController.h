//
//  PMLoginViewController.h
//  PhotoMap
//
//  Created by Александр on 22.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMAccessToken, PMUser;

typedef void(^PMLoginCompletionBlock)(PMAccessToken *token, PMUser *user);

@interface PMLoginViewController : UIViewController

- (instancetype)initWithCompletionBlock:(PMLoginCompletionBlock)completionBlock;

@end
