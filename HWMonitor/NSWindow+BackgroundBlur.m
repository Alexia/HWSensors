//
//  NSWindow+BackgroundGaussianBlur.m
//  HWMonitor
//
//  Created by Kozlek on 15.03.14.
//  Copyright (c) 2014 Guilherme Rambo, kozlek. All rights reserved.
//

// Original article: http://stackoverflow.com/questions/19575642/how-to-use-cifilter-on-nswindow-in-osx-10-9-mavericks

#import "NSWindow+BackgroundBlur.h"
#import <objc/runtime.h>

typedef void *          CGSConnection;

extern CGSConnection    CGSDefaultConnectionForThread();
extern OSStatus         CGSSetWindowBackgroundBlurRadius(CGSConnection connection, NSInteger windowNumber, int radius);

@implementation NSWindow (BackgroundBlur)

- (NSInteger)backgroundBlurRadius
{
    return [objc_getAssociatedObject(self, @selector(backgroundBlurRadius)) integerValue];
}

- (void)setBackgroundBlurRadius:(NSInteger)radius
{
    NSInteger oldRadius = [objc_getAssociatedObject(self, @selector(backgroundBlurRadius)) integerValue];
    objc_setAssociatedObject(self, @selector(backgroundBlurRadius), [NSNumber numberWithInteger:radius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (oldRadius != radius && self.isVisible) {
        CGSConnection connection = CGSDefaultConnectionForThread();
        CGSSetWindowBackgroundBlurRadius(connection, self.windowNumber, (int)radius);
    }
}

@end
