//
//  SSEditPersonViewController.h
//  SSToolkit
//
//  Created by Sam Soffes on 9/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@protocol SSEditPersonViewControllerDelegate

- (void)dismissEditViewControllerWithData:(id)data;

@end

@interface SSEditPersonViewController : ABPersonViewController {

}

@property (nonatomic, retain) id<SSEditPersonViewControllerDelegate> delegate;

- (void)cancel:(id)sender;

@end
