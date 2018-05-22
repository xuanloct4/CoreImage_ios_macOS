//
//  CIColorCube.h
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import <CoreImage/CoreImage.h>

@interface CIColorCube : CIFilter
+ (CIImage *)invertColorImage:(CIImage *)myInputImage
                             : (int)cubeDataSize
                             : (float)minHueAngle
                             : (float)maxHueAngle;
@end
