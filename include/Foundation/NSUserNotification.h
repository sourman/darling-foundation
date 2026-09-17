/*
 This file is part of Darling.

 Copyright (C) 2019 Lubos Dolezel

 Darling is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Darling is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Darling.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSDate.h>

@class NSUserNotification;
@class NSUserNotificationAction;
@class NSUserNotificationCenter;
@class NSTimeZone;
@class NSDateComponents;
@class NSAttributedString;

typedef NS_ENUM(NSInteger, NSUserNotificationActivationType) {
	NSUserNotificationActivationTypeNone = 0,
	NSUserNotificationActivationTypeContentsClicked = 1,
	NSUserNotificationActivationTypeActionButtonClicked = 2,
	NSUserNotificationActivationTypeReplied = 3,
	NSUserNotificationActivationTypeAdditionalActionClicked = 4,
};

@interface NSUserNotification : NSObject <NSCopying> {
	NSString *_title;
	NSString *_subtitle;
	NSString *_informativeText;
	NSString *_actionButtonTitle;
	NSString *_otherButtonTitle;
	NSString *_identifier;
	NSString *_soundName;
	NSString *_responsePlaceholder;
	NSDictionary *_userInfo;
	NSDate *_deliveryDate;
	NSDate *_actualDeliveryDate;
	id _contentImage;
	NSArray *_additionalActions;
	BOOL _hasActionButton;
	BOOL _hasReplyButton;
	BOOL _presented;
	BOOL _remote;
	NSUserNotificationActivationType _activationType;
}

@property (copy) NSString *title;
@property (copy) NSString *subtitle;
@property (copy) NSString *informativeText;
@property (copy) NSString *actionButtonTitle;
@property (copy) NSString *otherButtonTitle;
@property (copy) NSString *identifier;
@property (copy) NSString *soundName;
@property (copy) NSString *responsePlaceholder;
@property (copy) NSDictionary *userInfo;
@property (copy) NSDate *deliveryDate;
@property (readonly, copy) NSDate *actualDeliveryDate;
@property (retain) id contentImage;
@property (copy) NSArray *additionalActions;
@property BOOL hasActionButton;
@property BOOL hasReplyButton;
@property (readonly, getter=isPresented) BOOL presented;
@property (readonly, getter=isRemote) BOOL remote;
@property (readonly) NSUserNotificationActivationType activationType;

@end

@interface NSUserNotificationAction : NSObject <NSCopying> {
	NSString *_identifier;
	NSString *_title;
}

+ (instancetype)actionWithIdentifier:(NSString *)identifier title:(NSString *)title;
@property (readonly, copy) NSString *identifier;
@property (readonly, copy) NSString *title;

@end

@protocol NSUserNotificationCenterDelegate <NSObject>
@optional
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification;
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification;
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification;
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDismissAlert:(NSUserNotification *)notification;
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didRemoveDeliveredNotifications:(NSArray *)notifications;
- (void)userNotificationCenter:(NSUserNotificationCenter *)center openSettingsForNotification:(NSUserNotification *)notification;
@end

@interface NSUserNotificationCenter : NSObject {
	id<NSUserNotificationCenterDelegate> _delegate;
	NSMutableArray *_deliveredNotifications;
	NSMutableArray *_scheduledNotifications;
}

@property (class, readonly, strong) NSUserNotificationCenter *defaultUserNotificationCenter;
@property (assign) id<NSUserNotificationCenterDelegate> delegate;
@property (readonly, copy) NSArray *deliveredNotifications;
@property (copy) NSArray *scheduledNotifications;

- (void)deliverNotification:(NSUserNotification *)notification;
- (void)removeDeliveredNotification:(NSUserNotification *)notification;
- (void)removeAllDeliveredNotifications;
- (void)removeDeliveredNotificationsWithIdentifiers:(NSArray *)identifiers;
- (void)scheduleNotification:(NSUserNotification *)notification;
- (void)removeScheduledNotification:(NSUserNotification *)notification;

@end

FOUNDATION_EXPORT NSString * const NSUserNotificationDefaultSoundName;
