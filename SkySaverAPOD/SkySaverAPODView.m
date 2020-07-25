//
//  SkySaverAPODView.m
//  SkySaverAPOD
//
//  Created by Kristina Fedorenko on 7/25/20.
//  Copyright © 2020 Kristina Fedorenko. All rights reserved.
//

#import "SkySaverAPODView.h"

@implementation SkySaverAPODView

static NSRect picRect;
static NSRect mainRect;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        mainRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        
        picRect = CGRectMake(0, 0, 500, 500);

        
        
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
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);
    
//    [[NSColor blackColor] setFill];
//    NSRectFill(picRect);
    [super drawRect:picRect];
    
//    NSURL* picURL = [NSURL fileURLWithPath:@"https://apod.nasa.gov/apod/image/2007/DSC7590-Leutenegger1200c.jpg"];
//    NSString* picString = [[NSString alloc] initWithUTF8String:<#(nonnull const char *)#>;

//    NSImage* pic = [[NSImage alloc]  initWithContentsOfFile:@"https://i.pinimg.com/originals/ae/c4/53/aec453161b2f33ffc6219d8a758307a9.jpg"];
//

    NSImage* pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:@"https://apod.nasa.gov/apod/image/2007/DSC7590-Leutenegger1200c.jpg"]];
    
    // "/Users/Christik/Pictures/DSC7590-Leutenegger.jpg"]
    
    if (!pic.isValid){
        NSLog(@"image not created\n");
    }

    [pic drawInRect:picRect];
}

- (void)animateOneFrame
{
    //[self drawRect:mainRect];
    
//    NSImage* pic = [[NSImage alloc] initByReferencingFile:@"https://apod.nasa.gov/apod/image/2007/DSC7590-Leutenegger1200c.jpg"];
//    
//    if (!pic.isValid){
//        NSLog(@"image not created\n");
//    }
//    
//    [pic drawInRect:picRect];
    
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
