//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Victor Engel on 1/31/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
//@property (nonatomic,strong) Deck* theDeck;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
   Card *card = [self.game cardAtIndex:indexPath.item];
   [self updateCell:cell usingCard:card];
   return cell;
}

-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card
{
   //abstract
}
-(CardMatchingGame *)game
{
   if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                         usingDeck:[self createDeck]];
   return _game;
}

- (Deck *)createDeck {return nil;} //abstract 50:15

-(void)setFlipCount:(int)flipCount
{
   _flipCount = flipCount;
   self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

-(void)updateUI
{
   for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
      NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
      Card *card = [self.game cardAtIndex:indexPath.item];
      [self updateCell:cell usingCard:card];
   }
}

-(void)disableSegmentedControl
{
   for (UISegmentedControl *view in self.view.subviews) {
      if ([view isKindOfClass:[UISegmentedControl class]]) {
         view.userInteractionEnabled = NO;
      }
   }
   self.scoreLabel.text = [NSString stringWithFormat:@"Score %d,", self.game.score];
}

-(void)enableSegmentedControl
{
   for (UISegmentedControl *view in self.view.subviews) {
      if ([view isKindOfClass:[UISegmentedControl class]]) {
         view.userInteractionEnabled = YES;
      }
   }
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
   CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
   NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
   if (indexPath)
   {
      [self.game flipCardAtIndex:indexPath.item gameMode:self.game.gameMode];
      self.flipCount++;
      //sender.selected = !sender.selected; now handled by self.game
      [self updateUI];
      self.scoreLabel.text = [NSString stringWithFormat:@"Score %d",self.game.score];
      self.flipResultLabel.text = self.game.flipResult;
   }
}
- (IBAction)deal:(UIButton *)sender {
   //User has touched the deal button. Clean up and deal a new deck of cards.
   self.game = nil;
   self.flipCount = 0;
   [self updateUI];
   [self enableSegmentedControl];
}
- (IBAction)matchModeSwitch:(UISegmentedControl *)sender {
   if (sender.selectedSegmentIndex == 0) {
      self.game.gameMode = 2;
   } else {
      self.game.gameMode = 3;
   }
}

@end
