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
                
//            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            // Print response JSON data in the console.
//            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
            
            APODdata = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"HDURL: %@", APODdata[@"hdurl"]);


        }];

        // Begin task.
        [task resume];
        
        while (APODdata == nil){
            //NSLog(@"Waiting for data...");
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
    // background
    [super drawRect:rect];
    [[NSColor greenColor] setFill];
    NSRectFill(rect);
    
    // picture
    if (APODdata){
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

    [pic drawInRect:picRect];
    } else {
        NSLog(@"Not loaded yet....");
    }
    
    // text
    NSString* desc = @"The multi-mirror, 17 meter-diameter MAGIC telescopes reflect this starry night sky from the Roque de los Muchachos European Northern Observatory on the Canary Island of La Palma. MAGIC stands for Major Atmospheric Gamma Imaging Cherenkov and the telescopes can see the brief flashes of optical light produced in particle air showers as high-energy gamma rays impact the Earth's upper atmosphere. On July 20, two of the three telescopes in view were looking for gamma rays from the center of our Milky Way galaxy. In reflection they show the bright stars of Sagittarius and Scorpius near the galactic center to the southeast. Beyond the segmented-mirror arrays, above the northwest horizon and below the Big Dipper is Comet NEOWISE. NEOWISE stands for Near Earth Object Wide-field Infrared Survey Explorer. That's the Earth-orbiting satellite used to discover the comet designated C/2020 F3, but you knew that. ";
    

    NSSize textSize = NSMakeSize(rect.size.width/3, rect.size.height/4);
    NSRect textRect = CGRectMake(rect.size.width-textSize.width,
                                     rect.size.height-textSize.height,
                                     textSize.width, textSize.height);
    [super drawRect:textRect];
    [[NSColor darkGrayColor] setFill];
    NSRectFill(textRect);
    
    NSFont* font = [NSFont fontWithName:@"Helvetica" size:0.03*rect.size.height];
    NSDictionary* attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [NSColor lightGrayColor]
    };
    [desc drawInRect:textRect withAttributes:attributes];
    
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
