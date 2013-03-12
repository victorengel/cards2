//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Victor Engel on 2/1/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(id) initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

-(void)flipCardAtIndex:(NSUInteger)index gameMode:(NSUInteger)gameMode;

-(Card *)cardAtIndex:(NSUInteger)index;
-(void)deleteCards:(NSMutableArray *)cardToDelete;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *flipResult;
@property (nonatomic) NSInteger gameMode; //2 = match 2 cards, 3 = match 3 cards

@end
