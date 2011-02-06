//
//  SSPersonHeaderView.h
//  SSToolkit
//
//  Created by Sam Soffes on 9/8/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

@interface SSPersonHeaderView : UIView {

	BOOL _alignImageToLeft;
	BOOL _organization;
	UIImageView *_imageView;
	NSString *_personName;
	NSString *_organizationName;
}

@property (nonatomic, assign, getter=isOrganization) BOOL organization;
@property (nonatomic, assign) BOOL alignImageToLeft;
@property (nonatomic, retain, readonly) UIImageView *imageView;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *organizationName;

@end
