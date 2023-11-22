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

@implementation UnlockerAlertController
-(BOOL)_canShowWhileLocked {
  return YES;
}
@end

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

  if([[NSClassFromString(@"SBLockStateAggregator") sharedInstance] lockState] > 2) { // 0 is unlocked and 1 is unlocked but on lockscreen 
    UnlockerAlertController* alert = [UnlockerAlertController alertControllerWithTitle:@"Unlocker Error"
                                  message:@"Please unlock your device first."
                                  preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];

    // Get the view controller of springboard
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = [keyWindow rootViewController];

    [rootViewController presentViewController:alert animated:YES completion:nil];    
  } else {
    [self toggle];
  }
}

@end
