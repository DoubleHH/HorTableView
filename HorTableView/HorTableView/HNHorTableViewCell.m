//
//  HNHorTableViewCell.m
//  HorTableView
//
//  Created by DoubleHH on 14-6-11.
//  Copyright (c) 2014年 doubleHH. All rights reserved.
//

#import "HNHorTableViewCell.h"

@implementation HNHorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.index = - 1;
    }
    return self;
}

@end
