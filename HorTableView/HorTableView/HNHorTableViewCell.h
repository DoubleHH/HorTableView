//
//  HNHorTableViewCell.h
//  HorTableView
//
//  Created by DoubleHH on 14-6-11.
//  Copyright (c) 2014年 doubleHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNHorTableViewCell : UIView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) int index;

@end
