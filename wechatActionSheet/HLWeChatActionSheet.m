//
//  HLWeChatActionSheet.m
//  wechatActionSheet
//
//  Created by lihang on 16/2/10.
//  Copyright © 2016年 herry. All rights reserved.
//

#import "HLWeChatActionSheet.h"
#import <Masonry/Masonry.h>

static NSMutableArray *actionSheetQueue;

#define KHLActionSheetBarTintColor [[UIColor whiteColor] colorWithAlphaComponent:0.5]

#define HLColorRGBA(r, g, b, a)           [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha: a]

#define HLColorRGB(r, g, b)            [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha: 1.0f]

#pragma mark - _HLctionSheetAction
@interface _HLActionSheetAction : NSObject
@property (nonatomic, assign) HLActionSheetActionType actionType;
@property (nonatomic, copy) dispatch_block_t actionBlock;
@property (nonatomic, copy) NSString *title;
@end

@implementation _HLActionSheetAction
- (instancetype)init {
    return [super init];
}
@end

#pragma mark -
@interface _HLActionSheetTitleWrapperView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIToolbar *contentView;
@end

@implementation _HLActionSheetTitleWrapperView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentView = [[UIToolbar alloc] init];
        _contentView.clipsToBounds = YES;
        _contentView.translucent = YES;
        _contentView.barStyle = UIBarStyleDefault;
        _contentView.barTintColor = KHLActionSheetBarTintColor;
        [_contentView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_contentView invalidateIntrinsicContentSize];
        [self addSubview:_contentView];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HLColorRGB(136, 136, 136);
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:_titleLabel];
        
        MASAttachKeys(_contentView, _titleLabel);
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerX.centerY.equalTo(self);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 15, 20, 15));
        }];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    
    [super layoutSubviews];
}

@end

#pragma mark - _HLActionSheetCell
@interface _HLActionSheetCell : UIButton
@property (nonatomic, strong) UIToolbar *contentView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) _HLActionSheetAction *actionSheetModel;
@property (nonatomic, copy) dispatch_block_t actionSheetBlock;

- (instancetype)initWithActionSheetModel:(_HLActionSheetAction *)actionSheetModel;
@end

@implementation _HLActionSheetCell
- (instancetype)initWithActionSheetModel:(_HLActionSheetAction *)actionSheetModel {
    NSParameterAssert(actionSheetModel);
    if (self = [super initWithFrame:CGRectZero]) {
        _actionSheetModel = actionSheetModel;
        
        _contentView = [UIToolbar new];
        [_contentView invalidateIntrinsicContentSize];
        _contentView.translucent = YES;
        _contentView.barStyle = UIBarStyleDefault;
        _contentView.barTintColor = KHLActionSheetBarTintColor;
        _contentView.userInteractionEnabled = NO;
        [_contentView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_contentView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:_contentView];
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = _actionSheetModel.actionType ==
        HLActionSheetActionTypeDefault ?[UIColor blackColor] : HLColorRGB(239, 74, 75);
        _textLabel.font = [UIFont systemFontOfSize:18.f];
        [self addSubview:_textLabel];
        
        _textLabel.text = _actionSheetModel.title;
        
        MASAttachKeys(_contentView, _textLabel);
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.leading.trailing.equalTo(self);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.centerY.equalTo(self);
        }];
        
        [self addTarget:self action:@selector(actionSheetCellInternalAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithActionSheetModel:nil];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    _contentView.barTintColor = highlighted ? nil : KHLActionSheetBarTintColor;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    return CGSizeMake(size.width, 50.f);
}

- (void)actionSheetCellInternalAction {
    if (self.actionSheetBlock) {
        self.actionSheetBlock();
    }
}

@end

#pragma mark - _HLActionSheetCancelCell
@interface _HLActionSheetCancelCell : _HLActionSheetCell
@property (nonatomic, strong) UIView *topSepView;
@end

@implementation _HLActionSheetCancelCell
- (instancetype)initWithActionSheetModel:(_HLActionSheetAction *)actionSheetModel {
    if (self = [super initWithActionSheetModel:actionSheetModel]) {
        
        _topSepView = [UIView new];
        _topSepView.opaque = YES;
        _topSepView.backgroundColor = HLColorRGB(216, 213, 214);
        [self addSubview:_topSepView];
    }
    return self;
}

- (void)updateConstraints {
    [_topSepView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(6.f);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topSepView.mas_bottom).offset(14);
        make.bottom.equalTo(self).offset(-14);
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@[self, self.textLabel]);
        make.top.equalTo(_topSepView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    [super updateConstraints];
}

@end

#pragma mark - HLWeChatActionSheet
@interface HLWeChatActionSheet ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray <_HLActionSheetAction *> *actionArray;
@property (nonatomic, strong) UIView *actionSheetWrapperView;
@property (nonatomic, assign) BOOL sheetShowing;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) MASConstraint *wrapperTopLayout;
@end

@implementation HLWeChatActionSheet
- (void)dealloc {

}

- (NSMutableArray *)actionArray {
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (void)addActionWithType:(HLActionSheetActionType)type
                    title:(NSString *)actionTitle
                    block:(dispatch_block_t)block {
    if (actionTitle.length == 0) {
        return;
    }
    _HLActionSheetAction *action = [_HLActionSheetAction new];
    action.title = actionTitle;
    action.actionBlock = block;
    action.actionType = type;
    [self.actionArray addObject:action];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        self.backgroundColor = HLColorRGBA(0, 0, 0, 0.6);
        self.windowLevel = UIWindowLevelAlert;
        self.opaque = YES;
        self.alpha = 1.0;
        self.hidden = YES;
        self.clipsToBounds = YES;
        _title = title;
        
        _actionSheetWrapperView = [UIView new];
        [self addSubview:_actionSheetWrapperView];
        
        [_actionSheetWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            _wrapperTopLayout = make.top.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitle:nil];
}

- (void)show {
    if (_title.length == 0 && self.actionArray.count == 0) {
        @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"title and actions can not be nil both" userInfo:nil];
        return;
    }
    
    if (self.sheetShowing || self.animating) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    
    if (!actionSheetQueue) {
        actionSheetQueue = [NSMutableArray array];
    }
    [actionSheetQueue addObject:self];
    
    self.hidden = NO;
    self.alpha = 0;
    
    self.animating = YES;
    
    _HLActionSheetTitleWrapperView *titleWrapperView = nil;
    if (self.title.length > 0) {
        titleWrapperView = [_HLActionSheetTitleWrapperView new];
        titleWrapperView.titleLabel.text = self.title;
        [self.actionSheetWrapperView addSubview:titleWrapperView];
        [titleWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.actionSheetWrapperView);
        }];
    }
    
    _HLActionSheetCell *lastActionSheetCell = nil;
    NSArray <_HLActionSheetAction *> *actionArray = [self.actionArray copy];
    size_t actionArrayCount = actionArray.count;
    for (size_t i = 0; i < actionArrayCount; i++) {
        _HLActionSheetAction *actionModel = actionArray[i];
        _HLActionSheetCell *cell = [[_HLActionSheetCell alloc] initWithActionSheetModel:actionModel];
        [self.actionSheetWrapperView addSubview:cell];
        
        if (!lastActionSheetCell) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleWrapperView ? titleWrapperView.mas_bottom : self.actionSheetWrapperView);
            }];
        } else {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastActionSheetCell.mas_bottom);
            }];
        }
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.actionSheetWrapperView);
        }];
        
        __weak __typeof(self)weakself = self;
        cell.actionSheetBlock = ^{
            __strong __typeof(weakself)strongSelf = weakself;
            if (actionModel.actionBlock) {
                actionModel.actionBlock();
            }
            [strongSelf dismiss];
        };
        lastActionSheetCell = cell;
    }
    
    _HLActionSheetAction *cancelActionModel = [_HLActionSheetAction new];
    cancelActionModel.title = @"取消";
    
    _HLActionSheetCancelCell *cancelCell = [[_HLActionSheetCancelCell alloc] initWithActionSheetModel:cancelActionModel];
    
    __weak __typeof(self)weakself = self;
    cancelCell.actionSheetBlock = ^{
        __strong __typeof(weakself)strongSelf = weakself;
        [strongSelf dismiss];
    };
    
    [self.actionSheetWrapperView addSubview:cancelCell];
    
    [cancelCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.actionSheetWrapperView);
        if (lastActionSheetCell) {
            make.top.equalTo(lastActionSheetCell.mas_bottom);
        } else if (titleWrapperView) {
            make.top.equalTo(titleWrapperView.mas_bottom);
        } else {
            make.top.equalTo(self);
        }
    }];
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    CGRect wrapperViewFrame = self.actionSheetWrapperView.frame;
    self.wrapperTopLayout.offset = -CGRectGetHeight(wrapperViewFrame);
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.animating = NO;
        self.sheetShowing = YES;
    }];
}

- (void)dismiss {
    if (self.animating) {
        return;
    }
    self.animating = YES;
    self.wrapperTopLayout.offset = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.sheetShowing = NO;
        self.animating = NO;
        
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        
        if ([actionSheetQueue containsObject:self]) {
            [actionSheetQueue removeObject:self];
        }
        if (actionSheetQueue.count == 0) {
            actionSheetQueue = nil;
        }
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect contentRect = [self.actionSheetWrapperView convertRect:self.actionSheetWrapperView.frame toView:self];
    CGRect blankRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetHeight(contentRect));
    if (CGRectContainsPoint(blankRect, point)) {
        [self dismiss];
    }
}

#pragma mark - Coding
- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    return [self initWithTitle:nil];
}

@end
