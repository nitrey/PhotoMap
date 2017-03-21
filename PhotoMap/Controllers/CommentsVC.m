//
//  CommentsVC.m
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CommentsVC.h"

//Model
#import "PMComment.h"

//API
#import "PMServerManager.h"

//Cells
#import "CommentCell.h"

//Helpers
#import "PMImageDownloader.h"
#import "AAUtils.h"

static NSString *const commentCellIdentifier = @"CommentCell";
CGFloat commentFontSize = 15.0;
CGFloat defaultCellHeight = 44.0;
CGFloat userImageWidthConstant = 35.0;
CGFloat leftOffset = 5.0;
CGFloat rightOffset = 8.0;
CGFloat trailingOffset = 12.0;
CGFloat commentCellTopAndBottomOffset = 16.0;

@interface CommentsVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray; //of PMComments

@end

@implementation CommentsVC

@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self getCommentsInfo];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)setup {
    self.title = @"Comments";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - API

- (void)getCommentsInfo {
    [[PMServerManager sharedManager] getCommentsForMedia:self.mediaID
                                               onSuccess:^(NSDictionary *responseObject) {
                                                   NSLog(@"%@", responseObject);
                                                   NSArray *commentsInfo = responseObject[@"data"];
                                                   NSLog(@"LENGTH = %ld", [commentsInfo count]);
                                                   NSLog(@"COMMENTS INFO:\n%@", commentsInfo);
                                                   NSMutableArray *comments = [NSMutableArray array];
                                                   for (NSDictionary *info in commentsInfo) {
                                                       PMComment *comment = [[PMComment alloc] initWithInfo:info];
                                                       [comments addObject:comment];
                                                   }
                                                   self.dataArray = [comments copy];

                                               } onFailure:^(NSError *error) {
                                                   AALog(@"Failure loading comments");
                                                   AALog(@"ERROR: %@", [error userInfo]);
                                               }];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *commentCellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    PMComment *comment = self.dataArray[indexPath.row];
    [cell configureWithComment:comment];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMComment *comment = self.dataArray[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:commentFontSize];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:commentFontSize];
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:comment.text attributes:attributes];
    NSAttributedString *username = [[NSAttributedString alloc] initWithString:comment.username attributes:@{NSFontAttributeName : boldFont}];
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@" " attributes:attributes];
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] init];
    [resultText appendAttributedString:username];
    [resultText appendAttributedString:separator];
    [resultText appendAttributedString:text];
    
    CGFloat labelWidth = CGRectGetWidth(self.tableView.bounds) - leftOffset - userImageWidthConstant - trailingOffset - rightOffset;
    CGRect requiredRect = [resultText boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             context:nil];
    CGFloat requiredHeight = requiredRect.size.height + commentCellTopAndBottomOffset;
    CGFloat result = MAX(defaultCellHeight, requiredHeight);
    AALog(@"%f", result);
    return result;
}

@end
