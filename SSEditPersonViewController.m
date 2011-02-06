//
//  SSEditPersonViewController.m
//  SSToolkit
//
//  Created by Sam Soffes on 9/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "SSEditPersonViewController.h"

@implementation SSEditPersonViewController

#pragma mark NSObject

- (id)init {
	if ((self = [super init])) {
		self.allowsEditing = YES;
		self.editing = YES;
	}
	return self;
}


#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Edit Contact";
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}


#pragma mark UITableViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	if (editing == NO) {
		ABAddressBookSave(self.addressBook, nil);
		
		[self dismissModalViewControllerAnimated:YES];
	}
}


#pragma mark Actions

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
