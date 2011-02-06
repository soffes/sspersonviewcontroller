//
//  SSPersonFooterView.m
//  SSToolkit
//
//  Created by Sam Soffes on 9/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "SSPersonFooterView.h"

@implementation SSPersonFooterView

@synthesize editButton = _editButton;
@synthesize deleteButton = _deleteButton;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UIColor *titleColor = [UIColor colorWithRed:0.318 green:0.400 blue:0.569 alpha:1.0];
		
		_editButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[_editButton setTitleColor:titleColor forState:UIControlStateNormal];
		[_editButton setTitle:@"Edit Contact" forState:UIControlStateNormal];
		_editButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		[self addSubview:_editButton];
		
		_deleteButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[_deleteButton setTitleColor:titleColor forState:UIControlStateNormal];
		[_deleteButton setTitle:@"Delete Contact" forState:UIControlStateNormal];
		_deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		[self addSubview:_deleteButton];
	}
	return self;
}


- (void)layoutSubviews {
	CGSize buttonSize = CGSizeMake(ceil(self.frame.size.width / 2.0) - 15.0, 44.0);
	
	_editButton.frame = CGRectMake(10.0, 10.0, buttonSize.width, buttonSize.height);
	_deleteButton.frame = CGRectMake(10.0 + buttonSize.width + 10, 10.0, buttonSize.width, buttonSize.height);
}

@end
