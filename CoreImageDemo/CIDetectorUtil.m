//
//  CIDetectorUtil.m
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import "CIDetectorUtil.h"

@implementation CIDetectorUtil
+(CIVector *) findFaceCenter:(CIImage *)image {
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                context:nil
                                                options:nil];
//    CIContext *context = [CIContext context];                    // 1
//    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:context
//                                              options:opts];                    // 3
//
//    opts = @{ CIDetectorImageOrientation :
//                  [[image properties] valueForKey:kCGImagePropertyOrientation] }; // 4
//    NSArray *features = [detector featuresInImage:image options:opts];        // 5
    
    NSArray *features = [detector featuresInImage:image options:nil];
    for (CIFaceFeature *f in features) {
        NSLog(@"%@", NSStringFromRect(f.bounds));
        
        if (f.hasLeftEyePosition) {
            NSLog(@"Left eye %g %g", f.leftEyePosition.x, f.leftEyePosition.y);
        }
        if (f.hasRightEyePosition) {
            NSLog(@"Right eye %g %g", f.rightEyePosition.x, f.rightEyePosition.y);
        }
        if (f.hasMouthPosition) {
            NSLog(@"Mouth %g %g", f.mouthPosition.x, f.mouthPosition.y);
        }
    }

    CIFeature *face = features[0];
    CGFloat xCenter = face.bounds.origin.x + face.bounds.size.width/2.0;
    CGFloat yCenter = face.bounds.origin.y + face.bounds.size.height/2.0;
    CIVector *center = [CIVector vectorWithX:xCenter Y:yCenter];
    return center;
}

+(CIImage *) buildFaceMask:(CIImage *)image {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:nil];
    NSArray *faceArray = [detector featuresInImage:image options:nil];
    
    // Create a green circle to cover the rects that are returned.
    
    CIImage *maskImage = nil;
    
    for (CIFeature *f in faceArray) {
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
        CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5;
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" withInputParameters:@{
                                                                                                      @"inputRadius0": @(radius),
                                                                                                      @"inputRadius1": @(radius + 1.0f),
                                                                                                      @"inputColor0": [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                                                                                      @"inputColor1": [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                                                                                      kCIInputCenterKey: [CIVector vectorWithX:centerX Y:centerY],
                                                                                                      }];
        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
        if (nil == maskImage)
            maskImage = circleImage;
        else
            maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" withInputParameters:@{
                                                                                                   kCIInputImageKey: circleImage,
                                                                                                   kCIInputBackgroundImageKey: maskImage,
                                                                                                   }] valueForKey:kCIOutputImageKey];
    }
    return maskImage;
}


@end
