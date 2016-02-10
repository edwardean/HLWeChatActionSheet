//
//  HLWeChatActionSheet.h
//  wechatActionSheet
//
//  Created by lihang on 16/2/10.
//  Copyright © 2016年 herry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  actionSheet按钮样式，cancel按钮自动添加
 */
typedef NS_ENUM(NSUInteger, HLActionSheetActionType) {
    HLActionSheetActionTypeDefault,
    HLActionSheetActionTypeDestructive
};

@interface HLWeChatActionSheet : UIWindow

@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (instancetype)initWithTitle:(NSString * _Nullable )title NS_DESIGNATED_INITIALIZER;
- (void)addActionWithType:(HLActionSheetActionType)type
                    title:(NSString *)actionTitle
                    block:(dispatch_block_t)block;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
