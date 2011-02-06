//
//  SSPersonViewController.h
//  SSToolkit
//
//  Created by Sam Soffes on 9/8/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import <AddressBook/AddressBook.h>

@class SSPersonHeaderView;
@class SSPersonFooterView;

extern NSInteger kSSPersonViewControllerDeleteActionSheetTag;

@interface SSPersonViewController : UITableViewController <UIActionSheetDelegate> {
	
	ABRecordRef _displayedPerson;
	ABAddressBookRef _addressBook;
	
	SSPersonHeaderView *_headerView;
	SSPersonFooterView *_footerView;
	NSInteger _numberOfSections;
	NSMutableArray *_rowCounts;
	NSMutableDictionary *_cellData;
}

@property (nonatomic, assign) ABRecordRef displayedPerson;
@property (nonatomic, assign) ABAddressBookRef addressBook;

- (id)initWithPerson:(ABRecordRef)aPerson;
- (id)initWithPerson:(ABRecordRef)aPerson addressBook:(ABAddressBookRef)anAddressBook;

- (void)editPerson:(id)sender;
- (void)deletePerson:(id)sender;

@end
