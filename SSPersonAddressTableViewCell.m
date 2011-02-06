//
//  SSPersonAddressTableViewCell.m
//  SSToolkit
//
//  Created by Sam Soffes on 9/12/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "SSPersonAddressTableViewCell.h"

@implementation SSPersonAddressTableViewCell

#pragma mark Class Methods

+ (CGFloat)heightForDetailText:(NSString *)detailText tableWidth:(CGFloat)tableWidth {
	static UILineBreakMode lineBreakMode = UILineBreakModeWordWrap;
	UIFont *font = [UIFont boldSystemFontOfSize:15.0];
	
	CGFloat height = [detailText sizeWithFont:font constrainedToSize:CGSizeMake(tableWidth - 113.0, 1000.0) lineBreakMode:lineBreakMode].height + 23.0;
	return fmax(44.0, height);
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier])) {
		self.detailTextLabel.numberOfLines = 0;
		self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	}
	return self;
}

@end
