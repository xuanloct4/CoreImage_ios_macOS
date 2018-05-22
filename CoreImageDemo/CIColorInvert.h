//
//  CIColorInvert.h
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import <CoreImage/CoreImage.h>

@interface CIColorInvert : CIFilter {
    CIImage *inputImage;
}
@property (retain, nonatomic) CIImage *inputImage;

- (CIImage *) outputImage;
+ (CIImage *) invertColorImage: (CIImage *)image;
@end
