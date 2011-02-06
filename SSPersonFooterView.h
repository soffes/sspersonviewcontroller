//
//  SSPersonFooterView.h
//  SSToolkit
//
//  Created by Sam Soffes on 9/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

@interface SSPersonFooterView : UIView {

	UIButton *_editButton;
	UIButton *_deleteButton;
}

@property (nonatomic, retain, readonly) UIButton *editButton;
@property (nonatomic, retain, readonly) UIButton *deleteButton;

@end
