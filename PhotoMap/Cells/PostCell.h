//
//  PostCell.h
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PostCellType) {
    PostCellHeader,
    PostCellBody,
    PostCellFooter
};

//ABSTRACT CLASS

@interface PostCell : UITableViewCell

@property (assign, nonatomic) PostCellType cellType;

@end
