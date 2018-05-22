//
//  CIDetectorUtil.h
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import <CoreImage/CoreImage.h>
#import <CoreImage/CIDetector.h>

@interface CIDetectorUtil : CIFilter
+(CIVector *) findFaceCenter:(CIImage *)image;
+(CIImage *) buildFaceMask:(CIImage *)image;
@end
