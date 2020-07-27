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
static NSMutableParagraphStyle* paragraphStyle;
static NSRect picRect;
static NSUInteger desc_length;
static double font_fraction = 0.04;
static double img_height_by_width_ratio;
static NSSize img_size;

// for animation
static int zoom_fraq;
static int string_start;
static int update_zoom_by = 1;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/60.0];
        
        zoom_fraq = 0;
        string_start = 0;
        mainRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentRight;
        paragraphStyle.headIndent = 10;
        
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
        img_size = [pic size];
        img_height_by_width_ratio = img_size.height/img_size.width;
        
        desc = [NSString stringWithFormat:@"%@", APODdata[@"explanation"]];
        //desc = @"hello world, hello world";
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
    
    if (img_height_by_width_ratio  > 1) { // height is bigger
        picRect = CGRectMake(0, 0, rect.size.height/img_height_by_width_ratio, rect.size.height);
    } else { // width is bigger
        picRect = CGRectMake(0, 0, rect.size.width, rect.size.width*img_height_by_width_ratio);
    }

    double portion_to_display = 1 - (zoom_fraq/1000.0);
    NSRect picPortionRect = { {0,0},
        {img_size.width*portion_to_display, img_size.height*portion_to_display}
    };

    // ----------- text -----------

    NSSize textSize = NSMakeSize(rect.size.width, (font_fraction + 0.01)*rect.size.height);
    NSRect textRect = {
        {rect.size.width-textSize.width, rect.size.height-textSize.height},
        {textSize.width, textSize.height}
    };
    
    double character_width = font_fraction*rect.size.height*0.6; // estimate
    NSUInteger num_horz_chars = rect.size.width/character_width;
    BOOL needs_padding = NO;
    NSRange string_range = NSMakeRange(string_start, num_horz_chars);
    if (desc_length < num_horz_chars){
        string_range = NSMakeRange(0, desc_length);
    } else if ((string_start + num_horz_chars) > desc_length){ // end of desc
        // do not exceed the length of desc
        string_range = NSMakeRange(string_start, desc_length - string_start);
        needs_padding = YES;
    } else if (string_start < num_horz_chars) { // start of desc
        string_range = NSMakeRange(0, string_start);
    }
    NSString* string_to_display = [desc substringWithRange:string_range];

    if (needs_padding) {
        string_to_display = [string_to_display stringByPaddingToLength:num_horz_chars withString:@" - " startingAtIndex:0];
    }

    font = [NSFont fontWithName:@"Monaco" size:font_fraction*rect.size.height];

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
    
    string_start = (string_start + 1) % desc_length;
    
    
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
