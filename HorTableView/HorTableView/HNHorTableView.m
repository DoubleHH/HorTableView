//
//  HNHorTableView.m
//  HorTableView
//
//  Created by DoubleHH on 14-6-11.
//  Copyright (c) 2014年 doubleHH. All rights reserved.
//

#import "HNHorTableView.h"
#import "VSView+Extend.h"

// Log
#ifdef DEBUG
#define HorTableViewLog(log, ...) NSLog(log, ## __VA_ARGS__)
#else
#define HorTableViewLog(log, ...)
#endif

@interface HNHorTableView() <UIScrollViewDelegate>

@end

@implementation HNHorTableView {
    NSMutableArray *mVisiableCells;
    NSMutableArray *mDequeueReusableCells;
    NSMutableArray *mCellWidths;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    mVisiableCells = [NSMutableArray array];
    mDequeueReusableCells = [NSMutableArray array];
    mCellWidths = [NSMutableArray array];
}

- (void)initView {
    self.showsHorizontalScrollIndicator = YES;
    self.showsVerticalScrollIndicator = NO;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setDelegate:(id<HNHorTableViewDelegate>)delegate {
    [super setDelegate:delegate];
    [self checkToLoadData];
}

- (void)setDataSource:(id<HNHorTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self checkToLoadData];
}

- (void)checkToLoadData {
    if (self.delegate && self.dataSource) {
        [self reloadData];
    }
}

- (void)reloadData {
    
    if (!(self.dataSource && self.delegate)) {
        assert(@"dataSource and delegate can't be nil!");
    }
    
    int rows = [self allRows];
    
    [mCellWidths removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(horTableView:widthForRowAtIndexPath:)]) {
        for (int i=0; i<rows; ++i) {
            float width = [self.delegate horTableView:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [mCellWidths addObject:[NSNumber numberWithFloat:MAX(width, 0)]];
        }
    }
    
    float contentWidth = 0;
    for (NSNumber *width in mCellWidths) {
        contentWidth += width.floatValue;
    }
    self.contentSize = CGSizeMake(MAX(contentWidth, CGRectGetWidth(self.frame)), CGRectGetHeight(self.frame));
    
    // 移除所有的Cell
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[HNHorTableViewCell class]]) {
            [view removeFromSuperview];
        }
    }
    [mVisiableCells removeAllObjects];
    [self fullVisiableCells];
}

- (int)allRows {
    int rows = 0;
    if ([self.dataSource respondsToSelector:@selector(horTableView:numberOfRowsInSection:)]) {
        rows = [self.dataSource horTableView:self numberOfRowsInSection:0];
    }
    return rows;
}

#pragma mark - 移除不可见的Cell 和 添加需要显示的Cell
- (void)removeInvisibleCells {
    float visiableXBegin = [self accurateContentOffsetX];
    float visiableXEnd = visiableXBegin + CGRectGetWidth(self.frame);
    CGPoint lineVisiable = CGPointMake(visiableXBegin, visiableXEnd);
    
    for (int i=0; i<mVisiableCells.count; ++i) {
        HNHorTableViewCell *cell = [mVisiableCells objectAtIndex:i];
        CGPoint lineCell = CGPointMake(cell.left, cell.right);
        if (![self isIntersectWithLineOne:lineVisiable lineTwo:lineCell]) {
            [cell removeFromSuperview];
            [mVisiableCells removeObject:cell];
            i--;
        }
    }
}

- (void)fullVisiableCells {
    CGPoint fromToIndex = [self caculateVisableFromAndToIndex];
    int fromIndex = fromToIndex.x;
    int toIndex = fromToIndex.y;
    
    if ([self.dataSource respondsToSelector:@selector(horTableView:cellForRowAtIndexPath:)]) {
        
        float startX = 0;
        for (int i=0; i<fromIndex; ++i) {
            startX += [[mCellWidths objectAtIndex:i] floatValue];
        }
        if (fromIndex >= 0 && toIndex >= 0 && fromIndex <= toIndex) {
            
            for (int i=fromIndex; i<=toIndex; ++i) {
                
                BOOL isExisted = NO;
                for (HNHorTableViewCell *cell in mVisiableCells) {
                    if (cell.index == i) {
                        isExisted = YES;
                        break;
                    }
                }
                if (!isExisted) {
                    HNHorTableViewCell *cell = (HNHorTableViewCell *)[self.dataSource horTableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                    cell.frame = CGRectMake(startX, 0, [[mCellWidths objectAtIndex:i] floatValue], CGRectGetHeight(self.frame));
                    HorTableViewLog(@"cell frame: %@", NSStringFromCGRect(cell.frame));
                    [self addSubview:cell];
                    cell.index = i;
                    [mVisiableCells addObject:cell];
                    [self cacheCell:cell];
                }
                
                startX += [[mCellWidths objectAtIndex:i] floatValue];
            }
        }
    }
}

- (float)accurateContentOffsetX {
    float visiableXBegin = self.contentOffset.x;
    // 处理最后的cell, 其实可以不处理, 待定
    if (visiableXBegin + CGRectGetWidth(self.frame) > self.contentSize.width) {
        visiableXBegin = self.contentSize.width - CGRectGetWidth(self.frame);
    }
    // 处理第一个
    visiableXBegin = MAX(0, visiableXBegin);
    return visiableXBegin;
}

/**
 *  计算可以cell的开头和结束的位置
 *
 *  @return 开头(x)和结束(y)的位置
 */
- (CGPoint)caculateVisableFromAndToIndex {
    float visiableXBegin = [self accurateContentOffsetX];
    float visiableXEnd = visiableXBegin + CGRectGetWidth(self.frame);
    float contentWidth = 0;
    int fromIndex = -1, toIndex = -1;
    for (int i=0; i<mCellWidths.count; ++i) {
        float preContentWidth = contentWidth;
        contentWidth += [[mCellWidths objectAtIndex:i] floatValue];
        if (fromIndex < 0) {
            if (preContentWidth <= visiableXBegin && visiableXBegin < contentWidth) {
                fromIndex = i;
            }
        }
        if (fromIndex >=0 && toIndex < 0) {
            if (preContentWidth <= visiableXEnd && visiableXEnd < contentWidth) {
                toIndex = i;
                break;
            }
        }
    }
    if (fromIndex >=0 && toIndex < 0) {
        toIndex = fromIndex;
    }
    HorTableViewLog(@"fromIndex:%d, toIndex:%d", fromIndex, toIndex);
    return CGPointMake(fromIndex, toIndex);
}

#pragma mark - Dequeue Reusable Cell
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    
    // TODO, 可以优化, 建立一个hash表, 每个identifier为key对应一个NSMutableArray
    id reusableCell = nil;
    for (int i=0; i<mDequeueReusableCells.count; ++i) {
        HNHorTableViewCell *cell = [mDequeueReusableCells objectAtIndex:i];
        if ([cell.reuseIdentifier isEqualToString:identifier] &&
            ![mVisiableCells containsObject:cell]) {
            reusableCell = cell;
        }
    }
    return reusableCell;
}

- (void)cacheCell:(HNHorTableViewCell *)cell {
    if (![mDequeueReusableCells containsObject:cell]) {
        [mDequeueReusableCells addObject:cell];
    }
}

#pragma mark - Tools
- (BOOL)isIntersectWithLineOne:(CGPoint)lineOne lineTwo:(CGPoint)lineTwo {
    
    CGPoint shorterLine = lineOne;
    CGPoint longerLine = lineTwo;
    if (lineOne.y - lineOne.x > lineTwo.y - lineTwo.x) {
        shorterLine = lineTwo;
        longerLine = lineOne;
    }
    BOOL bRet = false;
    if ((longerLine.x <= shorterLine.x && shorterLine.x <= longerLine.y) ||
        (longerLine.x <= shorterLine.y && shorterLine.y <= longerLine.y)) {
        bRet = true;
    }
    return bRet;
}

#pragma mark - Observe KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self kvoScrollViewDidScroll];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)kvoScrollViewDidScroll {
    
    [self removeInvisibleCells];
    [self fullVisiableCells];
}

@end
