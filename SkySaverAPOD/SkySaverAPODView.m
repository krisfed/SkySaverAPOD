//
//  SkySaverAPODView.m
//  SkySaverAPOD
//
//  Created by Kristina Fedorenko on 7/25/20.
//  Copyright © 2020 Kristina Fedorenko. All rights reserved.
//

#import "SkySaverAPODView.h"

@implementation SkySaverAPODView


static NSRect mainRect;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        mainRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    // background
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);
    
    // picture
    NSImage* pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:@"https://apod.nasa.gov/apod/image/2007/DSC7590-Leutenegger1200c.jpg"]];

    NSRect picRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [super drawRect:picRect];

    
    
    if (!pic.isValid){
        NSLog(@"image not created\n");
    }

    [pic drawInRect:picRect];
}

- (void)animateOneFrame
{
    
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
