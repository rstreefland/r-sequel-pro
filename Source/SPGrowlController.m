//
//  $Id$
//
//  SPGrowlController.m
//  sequel-pro
//
//  Created by Stuart Connolly (stuconnolly.com) on Nov 28, 2008
//  Copyright (c) 2008 Stuart Connolly. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//  More info at <http://code.google.com/p/sequel-pro/>

#import "SPGrowlController.h"
#import "SPConstants.h"

#include <mach/mach_time.h>

static SPGrowlController *sharedGrowlController = nil;

@implementation SPGrowlController

/**
 * Returns the shared Growl controller.
 */
+ (SPGrowlController *)sharedGrowlController
{
    @synchronized(self) {
        if (sharedGrowlController == nil) {
            [[self alloc] init];
        }
    }
    
    return sharedGrowlController;
}

+ (id)allocWithZone:(NSZone *)zone
{    
    @synchronized(self) {
        if (sharedGrowlController == nil) {
            sharedGrowlController = [super allocWithZone:zone];
            
            return sharedGrowlController;
        }
    }
    
    return nil; // On subsequent allocation attempts return nil
}

- (id)init
{
    if ((self = [super init])) {
        [GrowlApplicationBridge setGrowlDelegate:self];
		timingNotificationName = nil;
		timingNotificationStart = 0;
    }
    
    return self;
}

/**
 * The following base protocol methods are implemented to ensure the singleton status of this class.
 */

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (id)autorelease { return self; }

- (void)release
{
	if (timingNotificationName) [timingNotificationName release];
}

/**
 * Posts a Growl notification using the supplied details and default values.
 * Calls the notification after a tiny delay to allow isKeyWindow to have updated
 * after tasks.
 */
- (void)notifyWithTitle:(NSString *)title description:(NSString *)description window:(NSWindow *)window notificationName:(NSString *)name
{
	NSMutableDictionary *notificationDictionary = [NSMutableDictionary dictionary];
	[notificationDictionary setObject:title forKey:@"title"];
	[notificationDictionary setObject:description forKey:@"description"];
	[notificationDictionary setObject:window forKey:@"window"];
	[notificationDictionary setObject:name forKey:@"name"];
	[notificationDictionary setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:[window windowNumber]] forKey:@"notificationWindow"] forKey:@"clickContext"];

	[self performSelector:@selector(notifyWithObject:) withObject:notificationDictionary afterDelay:0.1];
}

/**
 * Posts a Growl notification, using a NSDictionary to contain all arguments.
 * Allows calling either with an NSThread or afterDelay as it only accepts a
 * single argument.
 */
- (void)notifyWithObject:(NSDictionary *)notificationDictionary
{
	[self notifyWithTitle:[notificationDictionary objectForKey:@"title"]
			  description:[notificationDictionary objectForKey:@"description"]
				   window:[notificationDictionary objectForKey:@"window"]
		 notificationName:[notificationDictionary objectForKey:@"name"]
				 iconData:nil
				 priority:0
				 isSticky:NO
			 clickContext:[notificationDictionary objectForKey:@"clickContext"]];
}

/**
 * Posts a Growl notification using the supplied details and effectively ignoring the default values.
 */
- (void)notifyWithTitle:(NSString *)title description:(NSString *)description window:(NSWindow *)window notificationName:(NSString *)name iconData:(NSData *)data priority:(int)priority isSticky:(BOOL)sticky clickContext:(id)clickContext
{
	BOOL postNotification = YES;

	// Don't post the notification if the notification window is key and order front
	// as that suggests the user is already viewing the notification result.
	if ([window isKeyWindow]) postNotification = NO;

	// If a timing notification name exists, check to see if it matches the notification name;
	// if it does, and the time exceeds the threshold, display the notification even for
	// frontmost windows to provide feedback for long-running tasks.
	if (timingNotificationName && [timingNotificationName isEqualToString:name]) {
		if ([self milliTime] > (SP_LONGRUNNING_NOTIFICATION_TIME * 1000) + timingNotificationStart) {
			postNotification = YES;
		}
		[timingNotificationName release], timingNotificationName = nil;
	}

    // Post notification only if preference is set and visibility has been confirmed
	if (postNotification && [[NSUserDefaults standardUserDefaults] boolForKey:SPGrowlEnabled]) {
		[GrowlApplicationBridge notifyWithTitle:title
									description:description
							   notificationName:name
									   iconData:data
									   priority:priority
									   isSticky:sticky
								   clickContext:clickContext];
	}
}

/**
 * React to a click on the notification.
 */
- (void) growlNotificationWasClicked:(NSDictionary *)clickContext
{
	if (clickContext && [clickContext objectForKey:@"notificationWindow"]) {
		NSWindow *targetWindow = [NSApp windowWithWindowNumber:[[clickContext objectForKey:@"notificationWindow"] integerValue]];
		if (targetWindow) {
			[NSApp activateIgnoringOtherApps:YES];
			[targetWindow makeKeyAndOrderFront:self];
		}
	}
}

/**
 * Start the notification timer for a specific notification name.  Only one notification
 * timer can run at once, and tracks the time between this start and the notification
 * being posted; if the notification is posted after the header-defined boundary, the
 * notification will then be shown even if the app is frontmost.
 */
- (void) setVisibilityForNotificationName:(NSString *)name
{
	if (timingNotificationName) [timingNotificationName release], timingNotificationName = nil;
	timingNotificationName = [[NSString alloc] initWithString:name];
	timingNotificationStart = [self milliTime];
}

/**
 * Get a monotonically increasing time, in milliseconds.
 */
- (double) milliTime
{
	uint64_t currentTime_t = mach_absolute_time();
	Nanoseconds elapsedTime = AbsoluteToNanoseconds(*(AbsoluteTime *)&(currentTime_t));

	return (((double)UnsignedWideToUInt64(elapsedTime)) * 1e-6);
}

@end
