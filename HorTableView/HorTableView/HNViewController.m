//
//  HNViewController.m
//  HorTableView
//
//  Created by DoubleHH on 14-6-11.
//  Copyright (c) 2014年 doubleHH. All rights reserved.
//

#import "HNViewController.h"
#import "VSView+Extend.h"

@interface HNViewController ()

@end

@implementation HNViewController {
    HNHorTableView *mHorTableView;
    UITableView *mTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mHorTableView = [[HNHorTableView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    mHorTableView.delegate = self;
    mHorTableView.dataSource = self;
    [self.view addSubview:mHorTableView];
    
    
//    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mHorTableView.bottom, 320, self.view.height - mHorTableView.bottom) style:UITableViewStylePlain];
//    mTableView.delegate = self;
//    mTableView.dataSource = self;
//    [self.view addSubview:mTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - HNHorTableViewDelegate

- (CGFloat)horTableView:(HNHorTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)horTableView:(HNHorTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - HNHorTableViewDataSource
- (NSInteger)horTableView:(HNHorTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (HNHorTableViewCell *)horTableView:(HNHorTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"HNHorTableViewCell";
    HNHorTableViewCell *cell = [mHorTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[HNHorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 320)];
        [cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1000;
        imageView.clipsToBounds = YES;
    }
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1000];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", indexPath.row % 4]];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor redColor] : [UIColor grayColor];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"HNHorTableViewCell00";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.backgroundColor = indexPath.row % 2 ? [UIColor blueColor] : [UIColor yellowColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (mTableView == scrollView) {
        NSLog(@"subViewCounts : %d", [mTableView subviews].count);
    }
    else if (mHorTableView == scrollView) {
        NSLog(@"hor subViewCounts : %d", [mHorTableView subviews].count);
    }
}

@end
