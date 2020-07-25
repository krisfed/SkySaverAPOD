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

    NSSize s = [pic size];
    NSRect picRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [super drawRect:picRect];

    if (!pic.isValid){
        NSLog(@"image not created\n");
    }

    [pic drawInRect:picRect];
    
    // text
    NSString* desc = @"The multi-mirror, 17 meter-diameter MAGIC telescopes reflect this starry night sky from the Roque de los Muchachos European Northern Observatory on the Canary Island of La Palma. MAGIC stands for Major Atmospheric Gamma Imaging Cherenkov and the telescopes can see the brief flashes of optical light produced in particle air showers as high-energy gamma rays impact the Earth's upper atmosphere. On July 20, two of the three telescopes in view were looking for gamma rays from the center of our Milky Way galaxy. In reflection they show the bright stars of Sagittarius and Scorpius near the galactic center to the southeast. Beyond the segmented-mirror arrays, above the northwest horizon and below the Big Dipper is Comet NEOWISE. NEOWISE stands for Near Earth Object Wide-field Infrared Survey Explorer. That's the Earth-orbiting satellite used to discover the comet designated C/2020 F3, but you knew that. ";
    
 //       NSString* desc = @"The multi-mirror, 17 meter-diameter MAGIC telescopes";
    
//    NSRect textRect = CGRectMake(s.width, rect.size.height, rect.size.width-s.width, rect.size.height);
    NSSize textSize = NSMakeSize(500, 500);
        NSRect textRect = CGRectMake(rect.size.width-textSize.width,
                                     rect.size.height-textSize.height,
                                     textSize.width, textSize.height);
    [super drawRect:textRect];
    
    NSFont* font = [NSFont fontWithName:@"Helvetica" size:14.0];
    NSDictionary* attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [NSColor lightGrayColor],
                                  NSBackgroundColorAttributeName: [NSColor darkGrayColor]
    };
    [desc drawInRect:textRect withAttributes:attributes];
    
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
