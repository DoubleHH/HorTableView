//
//  VSView+Extend.m
//  VSCommonLib
//
//  Created by Huang on 2/12/11.
//  Copyright 2011 Vita Stone Corp. All rights reserved.
//
// Permission is hereby granted to staffs of Vita Stone Ltd.
// Any person obtaining a copy of this software and associated documentation 
// files (the "Software") should not use, copy, modify, merge, publish, distribute, 
// sublicense, and/or sell copies of the Software without permission granted by 
// Vita Stone Ltd.
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 


#import "VSView+Extend.h"

@implementation UIView (KalAdditions)

-(UIViewController*)getSuperViewController
{
	for (UIView* next = [self superview]; next; next = next.superview) 
	{
		UIResponder *nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) 
		{
			return (UIViewController*)nextResponder;
		}
	}	
	return nil;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (UIView *)_hitTestUnlimitedBound:(CGPoint)point withEvent:(UIEvent *)event withView:(UIView *)view
{
	for (UIView *subView in view.subviews)
	{
		if(subView.alpha > .01f && !subView.hidden)
		{
			CGPoint p1 = CGPointMake(point.x - subView.frame.origin.x, point.y - subView.frame.origin.y);
			if ([subView pointInside:p1 withEvent:event])
			{
				return [self _hitTestUnlimitedBound:p1 withEvent:event withView:subView];
			}
		}
	}
	if ([view pointInside:point withEvent:event])
		return view;
	else
		return nil;
}

- (UIView *)hitTestUnlimitedBound:(CGPoint)point withEvent:(UIEvent *)event
{
	return [self _hitTestUnlimitedBound:point withEvent:event withView:self];
}

@end
