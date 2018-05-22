//
//  CIColorCube.m
//  CIMicroPaint
//
//  Created by loctv on 5/17/18.
//

#import "CIColorCube.h"

// r,g,b values are from 0 to 1 // h = [0,360], s = [0,1], v = [0,1]
//  if s == 0, then h = -1 (undefined)

void rgbToHSV( float r, float g, float b, float *h, float *s, float *v ) {
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        // r = g = b = 0
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h=2+(b-r)/delta;
    else
        *h=4+(r-g)/delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

@implementation CIColorCube

+ (CIImage *)invertColorImage:(CIImage *)myInputImage
                             : (int)size
                             : (float)minHueAngle
                             : (float)maxHueAngle {
    // Allocate memory
//    const unsigned int size = 64;
    float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
    float rgb[3], hsv[3], *c = cubeData;
    
    // Populate cube with a simple gradient going from 0 to 1
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                // Convert RGB to HSV
                // You can find publicly available rgbToHSV functions on the Internet
                rgbToHSV(rgb[0], rgb[1], rgb[2], &hsv[0], &hsv[1], &hsv[2]);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    // Create memory with the cube data
//    NSData *data = [NSData dataWithBytesNoCopy:cubeData
//                                        length:cubeDataSize
//                                  freeWhenDone:YES];
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:size * size * size * sizeof (float) * 4
                                  freeWhenDone:YES];
    
    CIColorCube *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    // Set data for cube
    [colorCube setValue:data forKey:@"inputCubeData"];
    
    [colorCube setValue:myInputImage forKey:kCIInputImageKey];
    CIImage *result = [colorCube valueForKey:kCIOutputImageKey];
    return result;
}
@end
