#NJImgurServices for iOS

This static library allows you to integrate some Imgur services into your iOS application.

#Features

- Upload images anonymously.
- Login users using an Imgur account.
- Upload images to user's account (requires login).
- Sessions are automatically resumed and refreshed across app launches.
- Tokens are securely saved into system's keychain.
- Background uploading support.

#Requirements

iOS 6.0 or later is required.
Unknown behaviour in iOS 5 or earlier.

#Installation into your project

1. Download this repository as a ZIP (or clone it).
2. Copy the folder called "NJImgurServices Library" into your project.
3. Inside your target's Build Settings, add "-ObjC" flag to "Other Linker Flags".
4. Add Security.framework link.

#Sample Application

SampleApp folder contains a very simple sample application in case you need it.

#Usage

##Prerequisites

You'll need a **clientId** and **clientSecret** tokens. You can obtain those [here](https://api.imgur.com/oauth2/addclient). 

Make sure to use *OAuth 2 authrorization with a callback URL*. You can use whatever you want as a callback (i.e. http://ijustmadeupthis.com/)

##Uploading an image

#####1. Import NJIController.h

```objective-c
#import "NJIController.h"
```

#####2. Setup your clientId and clientSecret.

```objective-c
[[NJIController instance] setClientId:@"YOUR_CLIENT_ID" clientSecret:@"YOUR_CLIENT_SECRET"];
```

#####3. Create an NJIUpload object.

```objective-c
NJIUpload *upload = [[NJIUpload alloc] initWithImage:[UIImage imageNamed:@"imageToUpload.png"]];
```

#####4. Start uploading

```objective-c
[[NJIController instance] uploadImage:upload withDelegate:self]
```

#####5. Add NJIUploadDelegate protocol to your interface

```objective-c
@interface MyClass : NSObject <NJIUploadDelegate>
```

#####6. Add delegate methods

```objective-c
- (void)failedToUploadImage:(NJIUpload *)image withError:(NJIResponseStatus)error
{
    NSLog(@"Failed to upload");
}

- (void)finishedUploadingImage:(NJIUpload *)image withResult:(NJIUploadImageResponse *)uploadResponse
{
    NSLog(@"Uploaded image link: %@", uploadResponse.link);
}
```

##Uploading an image to a user's account

A user must be logged in with an Imgur account before your can start uploading images to his/her account.

#####1. Import NJIController.h

```objective-c
#import "NJIController.h"
```

#####2. Setup your clientId and clientSecret.

```objective-c
[[NJIController instance] setClientId:@"YOUR_CLIENT_ID" clientSecret:@"YOUR_CLIENT_SECRET"];
```

#####3. Setup your callback URL

This is the callback URL you entered when registering your application. You can check this in your Imgur account settings.

```objective-c
[[NJIController instance] setOAuthCallbackURL:@"http://ijustmadeupthis.com/"];
```

#####4. Present the login interface

Login interface will be presented modally from a provided parent UIViewController.

```objective-c
- (void)actionLogin:(id)sender
{
    if ([[NJIController instance] loginWithParentViewController:self andDelegate:self])
    {
        NSLog(@"Login appeared");
    }
    else
    {
        NSLog(@"Login failed");
    }
}
```

#####5. Add NJILoginDelegate to your interface

```objective-c
@interface MyViewController : UIViewController <NJIUploadDelegate>
```

#####6. Add delegate methods

```objective-c
- (void)successfullyLoggedInUser:(NJILoggedUser*)loggedUser
{
    NSLog([NSString stringWithFormat:@"Logged user: %@", loggedUser.username]);
}

- (void)loginCancelled
{
    NSLog(@"loginCancelled");
}

```

##Checking if a user is logged in

Sessions persist across app launches. You can check if a user is logged in as follows:

```objective-c
NJILoggedUser* loggedUser = [[NJIController instance] loggedUser];
    
if (loggedUser)
{
    NSLog([NSString stringWithFormat:@"Logged user: %@", loggedUser.username]);
}
else
{
    NSLog(@"No user is logged in");
}
```

##Logging out a user

You can logout a user simply by doing:

```objective-c
[[NJIController instance] logout];
```

##Listening to logout notifications

A user may be automatically logged out if we detect that the session has expired and we are unable to get a new session. This may happen if the user unauthorize your application. It's a strange case though you should control it.

```objective-c
[[NJIController instance] addObserverToLogoutNotification:self selector:@selector(logoutNotification)];
```

You must unregister yourself as an observer if you're going to be deallocated. You can still add the dealloc method in ARC projects, just make sure you don't call super.

```objective-c
- (void)dealloc
{
    [[NJIController instance] removeObserverToLogoutNotification:self];
}
```

##Checking credits

You can check remaining credits after uploading an image as follows:

```objective-c
- (void)finishedUploadingImage:(NJIUpload *)image withResult:(NJIUploadImageResponse *)uploadResponse
{
    NSLog(@"Remaining user credits: %@", uploadResponse.credits.userRemaining);
}

```

Read more about credits [here](http://api.imgur.com/#limits).

##Adding background uploading support

You can continue uploading images after the application is sent to the background by simply adding the following into your application delegate:

```objective-c
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NJIController instance] continueUnfinishedUploadsInBackground];
}
```

This will give you extra minutes to finish the uploads. Background tasking is limited by iOS, I think you have around 10 minutes before your app completely stops executing code.

#License

Everything here is licensed under [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0.html).