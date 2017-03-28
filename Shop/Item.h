//
//  Item.h
//  Shop
//
//  Created by Kirill Ushkov on 3/27/17.
//  Copyright © 2017 Kirill Ushkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSNumber *cost ;
@property (nonatomic, assign) NSNumber *availableNumber;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, assign) BOOL hasDiscount;
@property (nonatomic, assign) NSDate *dateOfManufacture;
@property (nonatomic, strong) NSString *imageName;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)itemDescription;

+ (Item*)defaultItem;

@end
