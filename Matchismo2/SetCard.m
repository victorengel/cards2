//
//  SetCard.m
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validNumbers
{
   static NSArray *validNumbers = nil;
   if (!validNumbers) validNumbers = @[@"one",@"two",@"three"];
   return validNumbers;
}
+ (NSArray *)validSymbols
{
   static NSArray *validSymbols = nil;
   if (!validSymbols) validSymbols = @[@"diamond",@"squiggle",@"oval"];
   return validSymbols;
}
+ (NSArray *)validShadings
{
   static NSArray *validShadings = nil;
   if (!validShadings) validShadings = @[@"solid",@"striped",@"open"];
   return validShadings;
}
+ (NSArray *)validColors
{
   static NSArray *validColors = nil;
   if (!validColors) validColors = @[@"red",@"green",@"purple"];
   return validColors;
}
-(BOOL)isSet:(NSArray *)items
{
   BOOL isASet = NO;
   NSMutableSet *itemTypes = [[NSMutableSet alloc]init];
   int arraySize = [items count];
   if (arraySize) {
      for (int index=0; index<arraySize; index++) {
         NSString *thisItem = items[index];
         [itemTypes addObject:thisItem];
      }
   }
   if ([itemTypes count] == 1) isASet = YES;
   if ([itemTypes count] == [items count]) isASet = YES;
   return isASet;
}
-(int)match:(NSArray *)otherCards
{
   int score=0; // Return nonzero if there is a set.
                // Check if there is a set of number
   NSMutableArray *allItems = [[NSMutableArray alloc] init];
   [allItems addObject:self.number];
   for (SetCard *item in otherCards) {
      [allItems addObject:item.number];
   }
   if ([self isSet:allItems]) score += 1;
                // Check if there is a set of symbol
   allItems = [[NSMutableArray alloc] init];
   [allItems addObject:self.symbol];
   for (SetCard *item in otherCards) {
      [allItems addObject:item.symbol];
   }
   if ([self isSet:allItems]) score += 1;
                // Check if there is a set of shading
   allItems = [[NSMutableArray alloc] init];
   [allItems addObject:self.shading];
   for (SetCard *item in otherCards) {
      [allItems addObject:item.shading];
   }
   if ([self isSet:allItems]) score += 1;
                // Check if there is a set of color
   allItems = [[NSMutableArray alloc] init];
   [allItems addObject:self.color];
   for (SetCard *item in otherCards) {
      [allItems addObject:item.color];
   }
   if ([self isSet:allItems]) score += 1;
   return score;
}
-(NSString *)contents
{
   return [NSString stringWithFormat:@"%d%d%d%d",
           [[SetCard validNumbers] indexOfObjectIdenticalTo:self.number],
           [[SetCard validSymbols] indexOfObjectIdenticalTo:self.symbol],
           [[SetCard validShadings] indexOfObjectIdenticalTo:self.shading],
           [[SetCard validColors] indexOfObjectIdenticalTo:self.color]];
}
-(NSString *)description
{
   return [NSString stringWithFormat:@"%@ %@ %@ %@",
           self.number,
           self.symbol,
           self.shading,
           self.color];
}
+ (NSUInteger)numberAsNumber: (NSString *)number
{
   return [[SetCard validNumbers] indexOfObjectIdenticalTo:number];
}
+ (NSUInteger)symbolAsNumber: (NSString *)symbol
{
   return [[SetCard validSymbols] indexOfObjectIdenticalTo:symbol];
}
+ (NSUInteger)shadingAsNumber: (NSString *)shading
{
   return [[SetCard validShadings] indexOfObjectIdenticalTo:shading];
}
+ (NSUInteger)colorAsNumber: (NSString *)color
{
   return [[SetCard validColors] indexOfObjectIdenticalTo:color];
}
+ (UIColor *)colorAsUIColor: (NSString *)color
{
   UIColor *returnColor = [[UIColor alloc] init];
   if ([color isEqualToString:@"red"]) {
      returnColor = [UIColor redColor];
   }
   if ([color isEqualToString:@"purple"]) {
      returnColor = [UIColor purpleColor];
   }
   if ([color isEqualToString:@"green"]) {
      //returnColor = [UIColor greenColor];
      returnColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
   }
   return returnColor;
}
@end
