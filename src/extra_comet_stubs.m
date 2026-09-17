#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSError.h>
#import <Foundation/NSNumber.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSUserNotification.h>
#import <Foundation/NSAttributedString.h>
#import <objc/runtime.h>

NSString *NSUserActivityTypeBrowsingWeb = @"NSUserActivityTypeBrowsingWeb";
NSString *NSProcessInfoThermalStateDidChangeNotification = @"NSProcessInfoThermalStateDidChangeNotification";
const double NSURLSessionTaskPriorityHigh = 1.0;

const char comet_startup_cluster_stubs_v1[] = "comet_startup_cluster_stubs_v1";

@implementation NSUserNotification (CometStartupCluster)
static const void *kDeliveryRepeatInterval;
static const void *kDeliveryTimeZone;
static const void *kResponse;
static const void *kShowsButtons;
static const void *kIdentityImage;
static const void *kIdentityImageHasBorder;
static const void *kAlwaysShowPreviews;
static const void *kSoundNameIsRemote;

- (id)deliveryRepeatInterval
{
	return objc_getAssociatedObject(self, &kDeliveryRepeatInterval);
}
- (void)setDeliveryRepeatInterval:(id)interval
{
	objc_setAssociatedObject(self, &kDeliveryRepeatInterval, interval,
	                         OBJC_ASSOCIATION_COPY);
}
- (id)deliveryTimeZone
{
	return objc_getAssociatedObject(self, &kDeliveryTimeZone);
}
- (void)setDeliveryTimeZone:(id)zone
{
	objc_setAssociatedObject(self, &kDeliveryTimeZone, zone,
	                         OBJC_ASSOCIATION_RETAIN);
}
- (NSAttributedString *)response
{
	return objc_getAssociatedObject(self, &kResponse);
}
- (void)setResponse:(NSAttributedString *)response
{
	objc_setAssociatedObject(self, &kResponse, response,
	                         OBJC_ASSOCIATION_COPY);
}
- (BOOL)_showsButtons
{
	return [objc_getAssociatedObject(self, &kShowsButtons) boolValue];
}
- (void)set_showsButtons:(BOOL)flag
{
	objc_setAssociatedObject(self, &kShowsButtons,
	                         [NSNumber numberWithBool:flag],
	                         OBJC_ASSOCIATION_RETAIN);
}
- (id)_identityImage
{
	return objc_getAssociatedObject(self, &kIdentityImage);
}
- (void)set_identityImage:(id)image
{
	objc_setAssociatedObject(self, &kIdentityImage, image,
	                         OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)_identityImageHasBorder
{
	return [objc_getAssociatedObject(self, &kIdentityImageHasBorder) boolValue];
}
- (void)set_identityImageHasBorder:(BOOL)flag
{
	objc_setAssociatedObject(self, &kIdentityImageHasBorder,
	                         [NSNumber numberWithBool:flag],
	                         OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)_alwaysShowPreviews
{
	return [objc_getAssociatedObject(self, &kAlwaysShowPreviews) boolValue];
}
- (void)set_alwaysShowPreviews:(BOOL)flag
{
	objc_setAssociatedObject(self, &kAlwaysShowPreviews,
	                         [NSNumber numberWithBool:flag],
	                         OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)_soundNameIsRemote
{
	return [objc_getAssociatedObject(self, &kSoundNameIsRemote) boolValue];
}
- (void)set_soundNameIsRemote:(BOOL)flag
{
	objc_setAssociatedObject(self, &kSoundNameIsRemote,
	                         [NSNumber numberWithBool:flag],
	                         OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation NSUserNotificationCenter (CometStartupCluster)
- (void)removeScheduledNotificationsWithIdentifiers:(NSArray *)identifiers
{
}
- (void)_removeAllDisplayedNotifications
{
}
- (void)_removeDisplayedNotification:(NSUserNotification *)notification
{
}
@end

@implementation NSFileManager (CometStartupCluster)
- (void)getFileProviderServicesForItemAtURL:(NSURL *)url
                          completionHandler:(void (^)(NSDictionary *services, NSError *error))completionHandler
{
	if (completionHandler)
		completionHandler([NSDictionary dictionary], nil);
}
@end
