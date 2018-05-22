//
//  ViewController.m
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "CIColorInvert.h"
#import "CIColorCube.h"
#import "CIDetectorUtil.h"
#import "AutoEnhancementFilter.h"

@interface ViewController ()
@property (weak) IBOutlet NSImageView *filteredImage;
@property (weak) IBOutlet NSImageView *originalImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    CIImage *image = [CIImage imageWithContentsOfURL:url];
    self.originalImage.image = [self fromCIImmage:image];
    
//    [self processingImage:image];
//    [CIDetectorUtil findFaceCenter:image];
//    CIImage *img = [CIDetectorUtil buildFaceMask:image];
  CIImage *img = [AutoEnhancementFilter autoEnhance:image];
    NSImage *nsImage = [self fromCIImmage:img];
    self.filteredImage.image = nsImage;
}

-(void)processingImage:(CIImage *)image {
    CIContext *context = [[CIContext alloc] init];                                          // 1
    
    CIFilter *filter = [CIFilter filterWithName: @"CISepiaTone" withInputParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0.5], kCIInputIntensityKey, nil]];            // 2
    [filter setValue:[NSNumber numberWithDouble:0.8] forKey:kCIInputIntensityKey];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"png"];
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    CIImage *image = [CIImage imageWithContentsOfURL:url];                       // 3
    [filter setValue:image forKey:kCIInputImageKey];
    CIImage *result = filter.outputImage;                 // 4
    CGImageRef *cgImage = [context createCGImage:result fromRect:result.extent];
    
    CIImage *output = [CIImage imageWithCGImage:cgImage];
    
    NSImage *nsImage = [self fromCIImmage:[CIColorInvert invertColorImage:image]];
//    NSImage *nsImage = [self fromCIImmage:[CIColorCube invertColorImage:image :64 :0 :100]];
    self.filteredImage.image = nsImage;
}

-(NSImage *)fromCIImmage:(CIImage *)image {
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:image];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
   
}



@end
