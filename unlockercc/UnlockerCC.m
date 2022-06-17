#import "UnlockerCC.h"

@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString * nsDomainString = @"com.wilsonthewolf.unlocker";
static NSString * nsNotificationString = @"com.wilsonthewolf.unlocker/preferences.changed";
static BOOL enabled;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
}

@implementation UnlockerCC


- (id) init {
  self = [super init];
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

  return self;
}

//Return the icon of your module here
- (UIImage *)iconGlyph
{
	return [UIImage imageNamed:@"ModuleIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

//Return the color selection color of your module here
- (UIColor *)selectedColor
{
	return [UIColor orangeColor];
}

- (BOOL)isSelected
{
  return enabled;
}

- (void) toggle {
  enabled = !enabled;

  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:enabled] forKey:@"enabled" inDomain:nsDomainString];

  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)nsNotificationString, NULL, NULL, false);

  [super refreshState];
}
- (void)setSelected:(BOOL)selected
{
  SBLockScreenManager *manager = [NSClassFromString(@"SBLockScreenManager") sharedInstance];
  // SBSLockScreenService *service = [[NSClassFromString(@"SBSLockScreenService") alloc] init];

  // IDK how to get this to work
  // [service requestPasscodeUnlockUIWithOptions:nil withCompletion:self.test]; 

  if([manager isUILocked]) {
    // Ask the user to unlock the device. Doesn't work ¯\_(ツ)_/¯
    // UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
    //                               message:@"Please unlock your device first."
    //                               preferredStyle:UIAlertControllerStyleAlert];
 
    // UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
    //   handler:^(UIAlertAction * action) {}];
    
    // [alert addAction:defaultAction];
    
    // Force the device to unlock. Very unpleasnt.
    [manager lockScreenViewControllerRequestsUnlock];
  } else {
    [self toggle];
  }
}

@end
