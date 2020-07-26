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

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
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
    // background
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);
    
    // picture
    //if (APODdata){
    //    NSImage* pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:@"https://apod.nasa.gov/apod/image/2007/DSC7590-Leutenegger1200c.jpg"]];
    
    NSString* hdurl = [NSString stringWithFormat:@"%@", APODdata[@"hdurl"]];
    NSLog(hdurl);
    NSImage* pic = [[NSImage alloc] initByReferencingURL:[NSURL URLWithString:hdurl]];
    
    NSSize s = [pic size];
    NSRect picRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [super drawRect:picRect];
    
    if (!pic.isValid){
        NSLog(@"image not created\n");
    }
    
//    [pic drawInRect:picRect];
    //    } else {
    //        NSLog(@"Not loaded yet....");
    //    }
    //
    // text
    NSString* desc = [NSString stringWithFormat:@"%@", APODdata[@"explanation"]];
    

    NSSize textSize = NSMakeSize(rect.size.width/3, rect.size.height/4);
    NSRect textRect = {{rect.size.width-textSize.width,
        rect.size.height-textSize.height}, {textSize.width, textSize.height}};
//        //CGRectMake(rect.size.width-textSize.width,
//                                     rect.size.height-textSize.height,
//                                     textSize.width, textSize.height);
    
    [super drawRect:textRect];
    [pic drawInRect:picRect];
    [[NSColor colorWithSRGBRed:0.3 green:1 blue:0.3 alpha:0.1] setFill];
    //NSRectFill(textRect);

    NSRectFillUsingOperation(textRect, NSCompositingOperationSourceOver );//NSCompositingOperationSourceOver);
    
//    NSFont* font = [NSFont fontWithName:@"Helvetica" size:0.03*rect.size.height];
//    NSDictionary* attributes = @{ NSFontAttributeName: font,
//                                  NSForegroundColorAttributeName: [NSColor lightGrayColor]
//    };
//    [desc drawInRect:textRect withAttributes:attributes];
    
}

- (void)animateOneFrame
{
    //NSLog(@"Kris log-----");
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
