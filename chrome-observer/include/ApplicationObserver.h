//
//  ApplicationObserver.h
//  chromeobserver
//
//  Created by Raul Guerrero on 10/07/23.
//

#ifndef ApplicationObserver_h
#define ApplicationObserver_h

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

typedef void (*ReceivedURLCallback)(const char* title, const char* url);

@interface ApplicationObserver : NSObject {
    ReceivedURLCallback callback;
}

@property (nonatomic, strong) NSNotificationCenter* notificationCenter;
@property (nonatomic) AXObserverRef windowObserver;
@property (nonatomic) AXUIElementRef chromeElement;
@property (nonatomic, strong) NSString* capturedURL;
@property (nonatomic, strong) NSString* capturedTitle;

- (void)applicationDidActivate:(NSNotification *)notification;
- (void)findToolbarInGroup:(AXUIElementRef)element;
- (void)findTextFieldInToolbar:(AXUIElementRef)element;
- (void)setCallback:(ReceivedURLCallback)newCallback;
- (instancetype)init;
- (void)stop;

@end

#endif /* ApplicationObserver_h */
