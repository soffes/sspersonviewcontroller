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

## History

I originally wrote this for a client. They said it would be fine if I open sourced it and put it in [SSToolkit](http://github.com/samsoffes/sstoolkit). I had it in a [topic branch](https://github.com/samsoffes/sstoolkit/tree/person) for awhile, but decided to move it to it's own repository instead of adding it to SSToolkit. I figured that most people probably won't use this, but they would have to add `AddressBook.framework` and `AddressBookUI.framework` to their project just to use SSToolkit. I also don't plan on working on this any time soon.

I did the same thing for [SSMessagesViewController](https://github.com/samsoffes/ssmessagesviewcontroller).

## Bugs

There is [one known bug](https://github.com/samsoffes/sspersonviewcontroller/issues#issue/1). The view will not refresh its data when the address book changes. Feel free to fork and improve!
