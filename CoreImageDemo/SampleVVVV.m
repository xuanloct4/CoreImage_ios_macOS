//
//  SampleVVVV.m
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import "SampleVVVV.h"
#import "Utilities.h"

@implementation SampleVVVV

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}


- (void)mouseDown:(NSEvent *)event
{
    CIContext *context = [[CIContext alloc] init];                                          // 1

    CIFilter *filter = [CIFilter filterWithName: @"CISepiaTone"];            // 2
    [filter setValue:[NSNumber numberWithDouble:0.8] forKey:kCIInputIntensityKey];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"E" ofType:@"jpg"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    CIImage *image = [CIImage imageWithContentsOfURL:url];                       // 3
    [filter setValue:image forKey:kCIInputImageKey];
    CIImage *result = filter.outputImage;                 // 4
    CGImageRef *cgImage = [context createCGImage:result fromRect:result.extent];

    CIImage *output = [CIImage imageWithCGImage:cgImage];

       [self setImage:image dirtyRect:self.frame];
    
    
    //    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:image];
    //    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    //    [nsImage addRepresentation:rep];
    //    self.image = nsImage;
    
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"E" ofType:@"jpg"];
//    self.imgURL = [NSURL fileURLWithPath:filePath];

}

- (IBAction)dsd:(id)sender {
}
@end
