#import <ControlCenterUIKit/CCUIToggleModule.h>
#import <Foundation/Foundation.h>

@interface SBLockScreenManager : NSObject {
}
+ (instancetype)sharedInstance;

-(BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
-(void)setUIUnlocking:(BOOL)arg1 ;
-(BOOL)isUILocked;
-(void) lockScreenViewControllerRequestsUnlock;
@end
@interface SBSLockScreenService : NSObject {
}

-(void)requestPasscodeUnlockUIWithOptions:(id)options withCompletion:(id)completion;
@end

@interface UnlockerCC : CCUIToggleModule
{
}

@end
