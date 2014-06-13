//
//  HNHorTableView.h
//  HorTableView
//
//  Created by DoubleHH on 14-6-11.
//  Copyright (c) 2014年 doubleHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNHorTableViewCell.h"

@class HNHorTableView;

@protocol HNHorTableViewDelegate<NSObject, UIScrollViewDelegate>

@optional
- (CGFloat)horTableView:(HNHorTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)horTableView:(HNHorTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HNHorTableViewDataSource<NSObject>

@required

- (NSInteger)horTableView:(HNHorTableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (HNHorTableViewCell *)horTableView:(HNHorTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//@optional
//- (NSInteger)numberOfSectionsInHorTableView:(UITableView *)tableView;              // Default is 1 if not implemented

@end

@interface HNHorTableView : UIScrollView

@property (nonatomic, assign)   id <HNHorTableViewDataSource> dataSource;
@property (nonatomic, assign)   id <HNHorTableViewDelegate>   delegate;

- (void)reloadData;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.

//- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;                         // returns nil if point is outside of any row in the table
//- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;                      // returns nil if cell is not visible
//- (NSArray *)indexPathsForRowsInRect:(CGRect)rect;                              // returns nil if rect not valid
//
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;            // returns nil if cell is not visible or index path is out of range
//- (NSArray *)visibleCells;
//- (NSArray *)indexPathsForVisibleRows;

@end
