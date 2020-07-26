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
static NSString* hdurl;
static NSImage* pic;

static NSString* desc;
static NSFont* font;
static NSDictionary* attributes;
//static NSSize textSize;
static NSRect picRect;
static NSUInteger desc_length;


int zoom_fraq;
int string_start;
int update_zoom_by = 1;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/60.0];
        
        zoom_fraq = 0;
        string_start = 0;
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
        
        hdurl = [NSString stringWithFormat:@"%@", APODdata[@"hdurl"]];
        pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:hdurl]];
        if (!pic.isValid){
            NSLog(@"image not created\n");
        }
        desc = [NSString stringWithFormat:@"%@", APODdata[@"explanation"]];
        desc_length = [desc length];
        
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
    
    // ----------- background -----------
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);


    // ----------- picture -----------
    picRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    double portion_to_display = 1 - (zoom_fraq/1000.0);
    NSSize s = [pic size];
    NSRect picPortionRect = { {0,0},
        {s.width*portion_to_display, s.height*portion_to_display}
    };

    // ----------- text -----------

    NSSize textSize = NSMakeSize(rect.size.width, 0.03*rect.size.height + 5);
    NSRect textRect = {
        {rect.size.width-textSize.width, rect.size.height-textSize.height},
        {textSize.width, textSize.height}
    };

    NSString* string_to_display = [desc substringFromIndex:string_start];

    font = [NSFont fontWithName:@"Helvetica" size:0.03*rect.size.height];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.headIndent = 10;
    attributes = @{ NSFontAttributeName: font,
                    NSForegroundColorAttributeName: [NSColor lightGrayColor],
                    NSParagraphStyleAttributeName: paragraphStyle
    };


    // ----------- drawing -----------
    [super drawRect:picRect];
    [super drawRect:textRect];
    [pic drawInRect:picRect fromRect:picPortionRect operation:NSCompositingOperationCopy fraction:1];
    [[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.6] setFill];
    NSRectFillUsingOperation(textRect, NSCompositingOperationSourceOver );
    [string_to_display drawInRect:textRect withAttributes:attributes];

    
}

- (void)animateOneFrame
{
    // update values for animation:

    zoom_fraq = zoom_fraq + update_zoom_by;
    
    // reverse zooming direction
    if ((zoom_fraq == 0) || (zoom_fraq == 300)){
        update_zoom_by = -update_zoom_by;
    }
    
    
    string_start += 5;
    string_start = string_start % desc_length;
    
    
    [self setNeedsDisplayInRect:mainRect];
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
