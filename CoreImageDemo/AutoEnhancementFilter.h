//
//  AutoEnhancementFilter.h
//  CIMicroPaint
//
//  Created by loctv on 5/18/18.
//

#import <Cocoa/Cocoa.h>

@interface AutoEnhancementFilter : NSApplication
+(CIImage *)autoEnhance: (CIImage *)image;
@end
