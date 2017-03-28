//
//  Item.m
//  Shop
//
//  Created by Kirill Ushkov on 3/27/17.
//  Copyright © 2017 Kirill Ushkov. All rights reserved.
//

#import "Item.h"

#define PRICE(cost, percent) cost * percent/100.0f

@implementation Item
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if( self = [super init] )
    {
        _title = dictionary[@"title"];
        _cost = dictionary[@"cost"];
        _availableNumber = dictionary[@"availableNumber"];
        _manufacturer = dictionary[@"manufacture"];
        _hasDiscount = [dictionary[@"hasDiscount"] boolValue];
        _dateOfManufacture = dictionary[@"DateOfManufacture"];
        _imageName = dictionary[@"imageName"];
    }
    
    return self;
}

- (NSDateFormatter*)dateFormatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    return df;
}


- (NSString *)itemDescription {
    return [NSString stringWithFormat:@"Title - %@, cost - %@, available number - %@, manufacturer - %@, has discount -  %s, Date of manufacture - %@, DISCOUNT - %.2f",
            _title,
            _cost,
            _availableNumber,
            _manufacturer,
            (_hasDiscount == 1 ? "yes" : "no"),
            @"1993",
            PRICE([_cost intValue], 30)];
}

+ (Item*)defaultItem {
    Item *item = [Item new];
    item.title = @"Test";
    item.cost = [NSNumber numberWithInt:12];
    item.availableNumber = [NSNumber numberWithInt:5];
    item.manufacturer = @"China";
    item.hasDiscount = YES;
    item.dateOfManufacture = [NSDate date];
    item.imageName = nil;
    
    return item;
}

@end
