//
//  CIColorInvert.m
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import "CIColorInvert.h"

@implementation CIColorInvert
@synthesize inputImage;
- (CIImage *) outputImage
{
    return [CIColorInvert invertColorImage:self.inputImage];
}

+ (CIImage *) invertColorImage: (CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"
                            withInputParameters: @{
                                                   kCIInputImageKey: image,
                                                   @"inputRVector": [CIVector vectorWithX:-1 Y:0 Z:0],
                                                   @"inputGVector": [CIVector vectorWithX:0 Y:-1 Z:0],
                                                   @"inputBVector": [CIVector vectorWithX:0 Y:0 Z:-1],
                                                   @"inputBiasVector": [CIVector vectorWithX:1 Y:1 Z:1],
                                                   }];
    return filter.outputImage;
}


@end
