//
//  SSPersonViewController.m
//  SSToolkit
//
//  Created by Sam Soffes on 9/8/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "SSPersonViewController.h"
#import "SSPersonHeaderView.h"
#import "SSPersonFooterView.h"
#import "SSPersonAddressTableViewCell.h"
#import "SSEditPersonViewController.h"
#import <AddressBookUI/AddressBookUI.h>

NSInteger kSSPersonViewControllerDeleteActionSheetTag = 987;

@interface SSPersonViewController (PrivateMethods)
+ (NSString *)_formatLabel:(NSString *)rawLabel;
@end

@implementation SSPersonViewController

@synthesize addressBook = _addressBook;
@synthesize displayedPerson = _displayedPerson; 

#pragma mark Class Methods

+ (NSString *)_formatLabel:(NSString *)rawLabel {
	NSString *label = nil;
	
	// Strip weird wrapper
	if ([rawLabel length] > 9 && [[rawLabel substringWithRange:NSMakeRange(0, 4)] isEqual:@"_$!<"]) {
		label = [rawLabel substringWithRange:NSMakeRange(4, [rawLabel length] - 8)];
	} else {
		label = [[rawLabel copy] autorelease];
	}
	
	// Lowercase unless iPhone
	if ([label isEqual:(NSString *)kABPersonPhoneIPhoneLabel] == NO) {
		label = [label lowercaseString];
	}
	
	return label;
}


#pragma mark NSObject

- (id)init {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		_headerView = [[SSPersonHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 84.0)];
		_numberOfSections = 1;
		_rowCounts = [[NSMutableArray alloc] init];
		_cellData = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void)dealloc {
	if (_addressBook) {
		CFRelease(_addressBook);
		_addressBook = nil;
	}
	
	if (_displayedPerson) {
		CFRelease(_displayedPerson);
		_displayedPerson = nil;
	}
	
	[_headerView release];
	[_footerView release];
	[_rowCounts release];
	[_cellData release];
	[super dealloc];
}


#pragma mark Initializers

- (id)initWithPerson:(ABRecordRef)aPerson {
	self = [self initWithPerson:aPerson addressBook:nil];
	return self;
}


- (id)initWithPerson:(ABRecordRef)aPerson addressBook:(ABAddressBookRef)anAddressBook {
	if ((self = [self init])) {		
		if (aPerson) {
			self.displayedPerson = aPerson;
			
			if (anAddressBook) {
				self.addressBook = anAddressBook;
			}
		}
	}
	return self;
}


#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Info";
	self.tableView.tableHeaderView = _headerView;
	
	_footerView = [[SSPersonFooterView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 74.0)];
	self.tableView.tableFooterView = _footerView;
	
	[_footerView.editButton addTarget:self action:@selector(editPerson:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView.deleteButton addTarget:self action:@selector(deletePerson:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark Actions

- (void)editPerson:(id)sender {
	SSEditPersonViewController *viewController = [[SSEditPersonViewController alloc] init];
	viewController.displayedPerson = self.displayedPerson;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	[navigationController release];
}


- (void)deletePerson:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Contact" otherButtonTitles:nil];
	actionSheet.tag = kSSPersonViewControllerDeleteActionSheetTag;
	[actionSheet showInView:self.view];
	[actionSheet release];
}


#pragma mark Getters

- (ABAddressBookRef)addressBook {
	if (_addressBook) {
		return _addressBook;
	}
	
	// Create one if none exists	
	_addressBook = ABAddressBookCreate();
	return _addressBook;
}


#pragma mark Setters

- (void)setAddressBook:(ABAddressBookRef)book {
	if (_addressBook) {
		CFRelease(_addressBook);
		_addressBook = nil;
	}
	
	if (!book) {
		return;
	}
	
	_addressBook = CFRetain(book);
}


- (void)setDisplayedPerson:(ABRecordRef)person {
	if (_displayedPerson) {
		CFRelease(_displayedPerson);
		_displayedPerson = nil;
	}
	
	if (!person) {
		return;
	}
	_displayedPerson = CFRetain(person);
	
	// Image
	if (ABPersonHasImageData(_displayedPerson)) {
		NSData *imageData = (NSData *)ABPersonCopyImageData(_displayedPerson);
		UIImage *image = [UIImage imageWithData:imageData];
		_headerView.image = image;
		[imageData release];
	} else {
		_headerView.image = nil;
	}
	
	// Name
	ABPropertyID nameProperties[] = {
		kABPersonPrefixProperty,
		kABPersonFirstNameProperty,
		kABPersonMiddleNameProperty,
		kABPersonLastNameProperty,
		kABPersonSuffixProperty
	};
	
	NSMutableArray *namePieces = [[NSMutableArray alloc] init];
	NSInteger namePiecesTotal = sizeof(nameProperties) / sizeof(ABPropertyID);
	for (NSInteger i = 0; i < namePiecesTotal; i++) {
		NSString *piece = (NSString *)ABRecordCopyValue(_displayedPerson, nameProperties[i]);
		if (piece) {
			[namePieces addObject:piece];
			[piece release];
		}
	}
	
	_headerView.personName = [namePieces componentsJoinedByString:@" "];
	[namePieces release];
	
	// Organization
	NSString *organizationName = (NSString *)ABRecordCopyValue(_displayedPerson, kABPersonOrganizationProperty);
	_headerView.organizationName = organizationName;
	[organizationName release];
	
	// Multivalues
	_numberOfSections = 0;
	[_rowCounts removeAllObjects];
	ABPropertyID multiProperties[] = {
		kABPersonPhoneProperty,
		kABPersonEmailProperty,
		kABPersonURLProperty,
		kABPersonAddressProperty
	};
	
	NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
	for (NSInteger i = 0; i < multiPropertiesTotal; i++) {
		// Get values count
		ABPropertyID property = multiProperties[i];
		ABMultiValueRef valuesRef = ABRecordCopyValue(_displayedPerson, property);
		NSInteger valuesCount = 0;
		if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
		
		if (valuesCount > 0) {
			_numberOfSections++;
			[_rowCounts addObject:[NSNumber numberWithInteger:valuesCount]];
		} else {
			//CFRelease(valuesRef);
			continue;
		}
		
		// Loop through values
		for (NSInteger k = 0; k < valuesCount; k++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k inSection:_numberOfSections - 1];
			
			// Get label
			NSString *rawLabel = (NSString *)ABMultiValueCopyLabelAtIndex(valuesRef, k);
			NSString *label = [[self class] _formatLabel:rawLabel];
			[rawLabel release];
			
			// Get value
			NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(valuesRef, k);
			
			// Merge address dictionary
			if (i == 3 && [value isKindOfClass:[NSDictionary class]]) {
				NSDictionary *addressDictionary = (NSDictionary *)value;
				
				NSMutableString *addressString = [[NSMutableString alloc] init];
				
				NSString *street = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
				NSString *city = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
				NSString *state = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
				NSString *zip = [addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];
				NSString *country = [addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey];
				
				// Street
				if (street) {
					[addressString appendString:street];
				}
				
				// City
				if (city) {
					if ([addressString length] > 0) {
						[addressString appendString:@"\n"];
					}
					[addressString appendString:city];
				}
				
				// State
				if (state) {
					if ([addressString length] > 0) {
						[addressString appendString:(city ? @" " : @"\n")];
					}
					[addressString appendString:state];
				}
				
				// Zip
				if (zip) {
					if ([addressString length] > 0) {
						[addressString appendString:(state || city ? @" " : @"\n")];
					}
					[addressString appendString:zip];
				}
				
				// Country
				if (country) {
					if ([addressString length] > 0) {
						[addressString appendString:@"\n"];
					}
					[addressString appendString:country];
				}
				
				[value release];
				value = addressString;
			}
			
			// Get url
			NSString *urlString = nil;
			switch (i) {
					// Phone number
				case 0: {
					NSString *cleanedValue = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
					cleanedValue = [cleanedValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
					cleanedValue = [cleanedValue stringByReplacingOccurrencesOfString:@"(" withString:@""];
					cleanedValue = [cleanedValue stringByReplacingOccurrencesOfString:@")" withString:@""];
					urlString = [NSString stringWithFormat:@"tel://%@", value];
					break;
				}
					
					// Email
				case 1: {
					urlString = [NSString stringWithFormat:@"mailto:%@", value];
					break;
				}
					
					// URL
				case 2: {
					urlString = value;
					break;
				}
					
					// Address
				case 3: {
					// This functionality is in SSToolkit's NSString category, but I wanted to remove and external
					// dependencies, so it's implemention is copied here.
					NSString *urlEncodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value,
																									 NULL, CFSTR("!*'();:@&=+$,/?%#[]"),
																									 kCFStringEncodingUTF8);
					urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", urlEncodedString];
					[urlEncodedString release];
					break;
				}
			}
			
			// Add dictionary to cell data
			NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
										label, @"label",
										value, @"value",
										[NSURL URLWithString:urlString], @"url",
										[NSNumber numberWithInteger:property], @"property",
										nil];
			[value release];
			[_cellData setObject:dictionary forKey:indexPath];
			[dictionary release];
		}
		
		CFRelease(valuesRef);
	}
	
	// Note
	NSString *note = (NSString *)ABRecordCopyValue(_displayedPerson, kABPersonNoteProperty);
	if (note) {
		_numberOfSections++;
		[_rowCounts addObject:[NSNumber numberWithInteger:1]];
		
		NSDictionary *noteDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
										@"notes", @"label",
										note, @"value",
										[NSNumber numberWithInteger:kABPersonNoteProperty], @"property",
										nil];
		[_cellData setObject:noteDictionary forKey:[NSIndexPath indexPathForRow:0 inSection:_numberOfSections - 1]];
		[noteDictionary release];
	}
	[note release];
	
	// Reload table
	if (_numberOfSections < 1) {
		_numberOfSections = 1;
	}
	[self.tableView reloadData];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _numberOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([_rowCounts count] == 0) {
		return 0;
	}
	return [[_rowCounts objectAtIndex:section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *valueCellIdentifier = @"valueCellIdentifier";
	static NSString *addressValueCellIdentifier = @"addressValueCellIdentifier";
	
	NSDictionary *cellDictionary = [_cellData objectForKey:indexPath];
	UITableViewCell *cell = nil;
	
	if ([[cellDictionary objectForKey:@"property"] integerValue] == kABPersonAddressProperty) {
		cell = [tableView dequeueReusableCellWithIdentifier:addressValueCellIdentifier];
		if (!cell) {
			cell = [[[SSPersonAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:addressValueCellIdentifier] autorelease];
		}
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:valueCellIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:valueCellIdentifier] autorelease];
		}
	}
	
	cell.textLabel.text = [cellDictionary objectForKey:@"label"];
	cell.detailTextLabel.text = [cellDictionary objectForKey:@"value"];
	cell.selectionStyle = [[UIApplication sharedApplication] canOpenURL:[cellDictionary objectForKey:@"url"]] ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
	
	return cell;
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *cellDictionary = [_cellData objectForKey:indexPath];
	if ([[cellDictionary objectForKey:@"property"] integerValue] == kABPersonAddressProperty) {
		return [SSPersonAddressTableViewCell heightForDetailText:[cellDictionary objectForKey:@"value"] tableWidth:self.tableView.frame.size.width];
	}
	return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *cellDictionary = [_cellData objectForKey:indexPath];
	[[UIApplication sharedApplication] openURL:[cellDictionary objectForKey:@"url"]];
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag != kSSPersonViewControllerDeleteActionSheetTag) {
		return;
	}
	
	// Delete person
	ABAddressBookRemoveRecord(self.addressBook, self.displayedPerson, nil);
	ABAddressBookSave(self.addressBook, nil);
	[self.navigationController popViewControllerAnimated:YES];	
}

@end
