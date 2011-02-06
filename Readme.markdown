# SSPersonViewController

Clone of Apple's ABPerson view controller in AddressBookUI.framework to allow for better customization.

## Installing

1. Copy all of the classes and images to your project (except the contents of the *Demo* folder of course)
2. Add `AddressBook.framework` and `AddressBookUI.framework` to your target

## Usage

Simply initialize the view controller with the person and address book.

    SSPersonViewController *personViewController = [[SSPersonViewController alloc] initWithPerson:person addressBook:addressBook];
    [self.navigationController pushViewController:personViewController animated:YES];
    [personViewController release];

See the demo project for further examples.
