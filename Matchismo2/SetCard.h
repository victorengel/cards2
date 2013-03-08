//
//  SetCard.h
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;
+ (NSUInteger)numberAsNumber: (NSString *)number;
+ (NSUInteger)symbolAsNumber: (NSString *)symbol;
+ (NSUInteger)shadingAsNumber: (NSString *)shading;
+ (NSUInteger)colorAsNumber: (NSString *)color;
+ (UIColor *)colorAsUIColor: (NSString *)color;

@end
