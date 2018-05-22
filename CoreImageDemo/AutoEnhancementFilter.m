//
//  AutoEnhancementFilter.m
//  CIMicroPaint
//
//  Created by loctv on 5/18/18.
//

#import "AutoEnhancementFilter.h"
#import <CoreImage/CoreImage.h>

@implementation AutoEnhancementFilter
+(CIImage *)autoEnhance: (CIImage *)image {
//    NSDictionary *options = @{ CIDetectorImageOrientation :
//                                   [[image properties] valueForKey:kCGImagePropertyOrientation] };
    
    NSMutableDictionary *options = [AutoEnhancementFilter filterDict];
    NSArray *adjustments = [image autoAdjustmentFiltersWithOptions:options];
    for (CIFilter *filter in adjustments) {
        [filter setValue:image forKey:kCIInputImageKey];
        image = filter.outputImage;
    }
    return image;
}

+ (NSMutableDictionary *)filterDict {
    NSMutableDictionary *filtersByCategory = [NSMutableDictionary dictionary];
    
    NSMutableArray *filterNames = [NSMutableArray array];
    [filterNames addObjectsFromArray:
     [CIFilter filterNamesInCategory:kCICategoryGeometryAdjustment]];
    [filterNames addObjectsFromArray:
     [CIFilter filterNamesInCategory:kCICategoryDistortionEffect]];
    filtersByCategory[@"Distortion"] = [AutoEnhancementFilter buildFilterDictionary: filterNames];
    
    [filterNames removeAllObjects];
    [filterNames addObjectsFromArray:
     [CIFilter filterNamesInCategory:kCICategorySharpen]];
    [filterNames addObjectsFromArray:
     [CIFilter filterNamesInCategory:kCICategoryBlur]];
    filtersByCategory[@"Focus"] = [AutoEnhancementFilter buildFilterDictionary: filterNames];
    return filtersByCategory;
}

+ (NSMutableDictionary *)buildFilterDictionary:(NSArray *)filterClassNames  // 1
{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    for (NSString *className in filterClassNames) {                         // 2
        CIFilter *filter = [CIFilter filterWithName:className];             // 3
        
        if (filter) {
            filters[className] = [filter attributes];                       // 4
        } else {
            NSLog(@"could not create '%@' filter", className);
        }
    }
    return filters;
}

@end
