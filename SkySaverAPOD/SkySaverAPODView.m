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
static NSDictionary* APODdata;

int zoom_fraq;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        zoom_fraq = 0;
        mainRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // request HTTP info
        // Create NSURLSession object
        NSURLSession *session = [NSURLSession sharedSession];

        // Create a NSURL object.
        NSURL* url = [NSURL URLWithString:@"https://api.nasa.gov/planetary/apod?api_key=v7ZYRL3q51GauWq1JYwg3ytoNDwm3ELnOGe7H6H8&date=2020-07-24"];

        // Create NSURLSessionDataTask task object by url and session object.
        NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
            APODdata = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"HDURL: %@", APODdata[@"hdurl"]);


        }];

        // Begin task.
        [task resume];
        
        while (APODdata == nil){
            // do not leave initialization until data is fetched
        }
        

        
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
    NSLog(@"already in drawRect");
    NSLog(@"isOpaque: %hhd", [self isOpaque]);
    // ----------- background -----------
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);
    
    
    
    
    // ----------- picture -----------
    double zoom_level = 1 + (((double)zoom_fraq)/100);
    NSLog(@"ZOOM LEVEL: %f ", zoom_level);
    NSString* hdurl = [NSString stringWithFormat:@"%@", APODdata[@"hdurl"]];
    NSLog(hdurl);
    NSImage* pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:hdurl]];
    
    NSSize s = [pic size];
    NSRect picRect = CGRectMake(0, 0, zoom_level*rect.size.width, zoom_level*rect.size.height);
    
    if (!pic.isValid){
        NSLog(@"image not created\n");
    }
    

    
    
    // ----------- text -----------

        
    NSSize textSize = NSMakeSize(rect.size.width/3, rect.size.height/4);
    NSRect textRect = {
        {rect.size.width-textSize.width, rect.size.height-textSize.height},
        {textSize.width, textSize.height}
    };
    
    
    NSString* desc = [NSString stringWithFormat:@"%@", APODdata[@"explanation"]];
    NSFont* font = [NSFont fontWithName:@"Helvetica" size:0.03*rect.size.height];
    NSDictionary* attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [NSColor lightGrayColor]
    };

    
    // ----------- drawing -----------
    [super drawRect:picRect];
    [super drawRect:textRect];
    [pic drawInRect:picRect];
    [[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.6] setFill];
    NSRectFillUsingOperation(textRect, NSCompositingOperationSourceOver );
    [desc drawInRect:textRect withAttributes:attributes];

    
}

- (void)animateOneFrame
{
    //NSLog(@"Kris log-----");
    zoom_fraq = (zoom_fraq + 1)%50;
    [self setNeedsDisplay:YES];
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
