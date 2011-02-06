//
//  PVDemoViewController.h
//  SSCatalog
//
//  Created by Sam Soffes on 9/8/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@interface PVDemoViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate> {

}

- (void)pickPerson:(id)sender;

@end
