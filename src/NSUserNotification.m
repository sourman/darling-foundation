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

#import <Foundation/NSUserNotification.h>
#import <Foundation/NSMutableArray.h>

NSString * const NSUserNotificationDefaultSoundName = @"NSUserNotificationDefaultSoundName";

@implementation NSUserNotification

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize informativeText = _informativeText;
@synthesize actionButtonTitle = _actionButtonTitle;
@synthesize otherButtonTitle = _otherButtonTitle;
@synthesize identifier = _identifier;
@synthesize soundName = _soundName;
@synthesize responsePlaceholder = _responsePlaceholder;
@synthesize userInfo = _userInfo;
@synthesize deliveryDate = _deliveryDate;
@synthesize actualDeliveryDate = _actualDeliveryDate;
@synthesize contentImage = _contentImage;
@synthesize additionalActions = _additionalActions;
@synthesize hasActionButton = _hasActionButton;
@synthesize hasReplyButton = _hasReplyButton;
@synthesize presented = _presented;
@synthesize remote = _remote;
@synthesize activationType = _activationType;

- (id)init
{
	self = [super init];
	if (self) {
		_hasActionButton = YES;
	}
	return self;
}

- (void)dealloc
{
	[_title release];
	[_subtitle release];
	[_informativeText release];
	[_actionButtonTitle release];
	[_otherButtonTitle release];
	[_identifier release];
	[_soundName release];
	[_responsePlaceholder release];
	[_userInfo release];
	[_deliveryDate release];
	[_actualDeliveryDate release];
	[_contentImage release];
	[_additionalActions release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	NSUserNotification *copy = [[[self class] allocWithZone:zone] init];
	copy.title = _title;
	copy.subtitle = _subtitle;
	copy.informativeText = _informativeText;
	copy.actionButtonTitle = _actionButtonTitle;
	copy.otherButtonTitle = _otherButtonTitle;
	copy.identifier = _identifier;
	copy.soundName = _soundName;
	copy.responsePlaceholder = _responsePlaceholder;
	copy.userInfo = _userInfo;
	copy.deliveryDate = _deliveryDate;
	copy.contentImage = _contentImage;
	copy.additionalActions = _additionalActions;
	copy.hasActionButton = _hasActionButton;
	copy.hasReplyButton = _hasReplyButton;
	return copy;
}

@end

@implementation NSUserNotificationAction

@synthesize identifier = _identifier;
@synthesize title = _title;

+ (instancetype)actionWithIdentifier:(NSString *)identifier title:(NSString *)title
{
	NSUserNotificationAction *action = [[self alloc] init];
	action->_identifier = [identifier copy];
	action->_title = [title copy];
	return [action autorelease];
}

- (void)dealloc
{
	[_identifier release];
	[_title release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[[self class] actionWithIdentifier:_identifier title:_title] retain];
}

@end

@implementation NSUserNotificationCenter

static NSUserNotificationCenter *_defaultUserNotificationCenter = nil;

@synthesize delegate = _delegate;

- (id)init
{
	self = [super init];
	if (self) {
		_deliveredNotifications = [[NSMutableArray alloc] init];
		_scheduledNotifications = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_deliveredNotifications release];
	[_scheduledNotifications release];
	[super dealloc];
}

+ (NSUserNotificationCenter *)defaultUserNotificationCenter
{
	if (_defaultUserNotificationCenter == nil) {
		_defaultUserNotificationCenter = [[NSUserNotificationCenter alloc] init];
	}
	return _defaultUserNotificationCenter;
}

- (NSArray *)deliveredNotifications
{
	// Owned ivar, not an autoreleased copy — Chrome can call this off-thread
	// without an NSAutoreleasePool.
	return _deliveredNotifications;
}

- (NSArray *)scheduledNotifications
{
	return _scheduledNotifications;
}

- (void)setScheduledNotifications:(NSArray *)notifications
{
	[_scheduledNotifications removeAllObjects];
	if (notifications != nil) {
		[_scheduledNotifications addObjectsFromArray:notifications];
	}
}

static void _removeMatchingIdentifier(NSMutableArray *list, NSString *identifier)
{
	if (identifier == nil) {
		return;
	}
	NSInteger i;
	for (i = (NSInteger)[list count] - 1; i >= 0; i--) {
		NSUserNotification *existing = [list objectAtIndex:(NSUInteger)i];
		if ([[existing identifier] isEqualToString:identifier]) {
			[list removeObjectAtIndex:(NSUInteger)i];
		}
	}
}

- (void)deliverNotification:(NSUserNotification *)notification
{
	if (notification == nil) {
		return;
	}
	_removeMatchingIdentifier(_deliveredNotifications, [notification identifier]);
	[_deliveredNotifications addObject:notification];
	if ([_delegate respondsToSelector:@selector(userNotificationCenter:didDeliverNotification:)]) {
		[_delegate userNotificationCenter:self didDeliverNotification:notification];
	}
}

- (void)removeDeliveredNotification:(NSUserNotification *)notification
{
	if (notification == nil) {
		return;
	}
	[_deliveredNotifications removeObject:notification];
	_removeMatchingIdentifier(_deliveredNotifications, [notification identifier]);
}

- (void)removeAllDeliveredNotifications
{
	[_deliveredNotifications removeAllObjects];
}

- (void)removeDeliveredNotificationsWithIdentifiers:(NSArray *)identifiers
{
	if ([identifiers count] == 0) {
		return;
	}
	NSInteger i;
	for (i = (NSInteger)[_deliveredNotifications count] - 1; i >= 0; i--) {
		NSUserNotification *note = [_deliveredNotifications objectAtIndex:(NSUInteger)i];
		NSString *ident = [note identifier];
		if (ident != nil && [identifiers containsObject:ident]) {
			[_deliveredNotifications removeObjectAtIndex:(NSUInteger)i];
		}
	}
}

- (void)scheduleNotification:(NSUserNotification *)notification
{
	if (notification == nil) {
		return;
	}
	_removeMatchingIdentifier(_scheduledNotifications, [notification identifier]);
	[_scheduledNotifications addObject:notification];
}

- (void)removeScheduledNotification:(NSUserNotification *)notification
{
	if (notification == nil) {
		return;
	}
	[_scheduledNotifications removeObject:notification];
	_removeMatchingIdentifier(_scheduledNotifications, [notification identifier]);
}

@end
