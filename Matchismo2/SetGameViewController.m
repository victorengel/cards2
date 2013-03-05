//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Victor Engel on 2/7/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetGame.h"
#import "SetCardCollectionViewCell.h"

//@interface SetGameViewController()
//@property (strong, nonatomic) SetGame *game;
//@end

@implementation SetGameViewController

-(Deck *)createDeck //abstract in CardGameViewController, but we implement it here.
{
   return [[SetCardDeck alloc] init];
}
- (NSUInteger) startingCardCount //abstract in CardGameViewController, but we implement it here.
{
   return 24;
}
-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card //abstract in CardGameViewController, but we implement it here.
{
   if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
      SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
      if ([card isKindOfClass:[SetCard class]]) {
         SetCard *setCard = (SetCard *)card;
         /*setCardView.rank = setCard.rank;
         setCardView.suit = setCard.suit;*/
         setCardView.color = setCard.color;
         setCardView.symbol = setCard.symbol;
         setCardView.shading = setCard.shading;
         setCardView.number = setCard.number;
         setCardView.faceUp = setCard.isFaceUp;
         setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
      }
   }
}


//@interface SetGameViewController ()
/*
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
//@property (nonatomic,strong) Deck* theDeck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) SetGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@end

@implementation SetGameViewController
//▲ ● ■
-(SetGame *)game
{
   if (!_game) _game = [[SetGame alloc] initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[SetCardDeck alloc] init]];
   return _game;
}

-(void)setFlipCount:(int)flipCount
{
   _flipCount = flipCount;
   self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

*/
/*No change needed so omit.
-(void)setCardButtons:(NSArray *)cardButtons
{
   _cardButtons = cardButtons;
}
 */
/*
-(NSAttributedString *)displayValue:(SetCard *)card
{
   //This method translates a set cards properties into an attributed string used to display the card.
   //The format of contents matches the contents method of the SetCard class, which is described here again for convenience.
   //There are 4 digits, with values from 0..2. The digits represent the following attributes:
   //number:  0=@"one",     1=@"two",      2=@"three"
   //symbol:  0=@"diamond", 1=@"squiggle", 2=@"oval"
   //shading: 0=@"solid",   1=@"striped",  2=@"open"
   //color:   0=@"red",     1=@"green",    2=@"purple"
   //Symbol first
   NSArray *displaySymbols = [NSArray arrayWithObjects:@"▲",@"●",@"■", nil];
   NSString *symbol = displaySymbols[[[SetCard validSymbols] indexOfObjectIdenticalTo:card.symbol]];
   //Number next
   NSString *displayString = @"";
   for (int i=0; i<=[[SetCard validNumbers] indexOfObjectIdenticalTo:card.number]; i++) {
      displayString = [displayString stringByAppendingString:symbol];
   }*/
   /*Attribute constants available
    NSString *const NSFontAttributeName;
    NSString *const NSParagraphStyleAttributeName;
    NSString *const NSForegroundColorAttributeName;
    NSString *const NSBackgroundColorAttributeName;
    NSString *const NSLigatureAttributeName;
    NSString *const NSKernAttributeName;
    NSString *const NSStrikethroughStyleAttributeName;
    NSString *const NSUnderlineStyleAttributeName;
    NSString *const NSStrokeColorAttributeName;
    NSString *const NSStrokeWidthAttributeName;
    NSString *const NSShadowAttributeName;
    NSString *const NSVerticalGlyphFormAttributeName;
    */
/*
   NSDictionary *attributeList = [[NSDictionary alloc] init];
   //Color
   UIColor *fontColor = [UIColor greenColor];
   fontColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
   if ([card.color isEqualToString: @"purple"]) fontColor = [UIColor purpleColor];
   if ([card.color isEqualToString: @"red"]) fontColor = [UIColor redColor];
   NSInteger stringLength=[displayString length];
   NSMutableAttributedString *displayValue = [[NSMutableAttributedString alloc] initWithString:displayString attributes:attributeList];
   [displayValue addAttribute:NSStrokeColorAttributeName value:fontColor range:NSMakeRange(0, stringLength)];
   [displayValue addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-3.0] range:NSMakeRange(0, stringLength)];
   //[displayValue addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-3.0]];
   //Shading
   UIColor *fillColor = [UIColor whiteColor];
   if ([card.shading isEqualToString: @"solid"]) fillColor = fontColor;
   if ([card.shading isEqualToString: @"striped"]) {
      fillColor = [fontColor colorWithAlphaComponent:0.35];
   }
   [displayValue addAttribute:NSForegroundColorAttributeName value:fillColor range:NSMakeRange(0, stringLength)];
   return [displayValue copy];
}
-(void)updateUI
{
   for (UIButton *cardButton in self.cardButtons) {
      SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
      NSLog(@"updateUI card %@",card.contents);
      [cardButton setTitle:card.contents forState:UIControlStateSelected];
      [cardButton setAttributedTitle:[self displayValue:card] forState:UIControlStateNormal];
      [cardButton setAttributedTitle:[self displayValue:card] forState:UIControlStateSelected|UIControlStateDisabled];
      [cardButton setBackgroundImage:[UIImage imageNamed:@"greycard.png"] forState:UIControlStateSelected];
      cardButton.selected = card.isFaceUp;
      cardButton.enabled = !card.isUnplayable;
      cardButton.alpha = card.isUnplayable ? 0.1 : 1.0;
      self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
   }
   //self.flipResultLabel.text = self.game.flipResult;
   self.flipResultLabel.attributedText = [self attributedResult:self.game.flipResult];
}
-(NSAttributedString *)attributedResult: (NSString *)result
{
   //Parse through result by spaces converting 4-digit numbers to attributed strings.
   NSMutableAttributedString *returnString = [[NSMutableAttributedString alloc] init];
   NSAttributedString *space = [[NSAttributedString alloc]initWithString:@" "];
   NSArray *wordList = [result componentsSeparatedByString:@" "];
   for (NSString *word in wordList) {
      NSAttributedString *attrWord = [self attributedWord:word];
      if ([returnString length]) [returnString appendAttributedString:space];
      [returnString appendAttributedString:attrWord];
   }
   return [returnString copy];
}
-(NSAttributedString *)attributedWord: (NSString *)word
{
   NSLog(@"Decoding %@",word);
   if ([word length] == 4) {
      SetCard *card = [[SetCard alloc] init];
      int i=0;
      BOOL invalid = NO;
      NSString * cardAtt = [word substringWithRange:NSMakeRange(i, 1)];
      NSLog(@"Decoding digit %@",cardAtt);
      //number
      if ([@".012" rangeOfString:cardAtt].location) card.number = [[SetCard validNumbers] objectAtIndex:[cardAtt intValue]]; else invalid = YES;
      NSLog(@"Resulting card number: %@",card.number);
      //symbol
      i=1; cardAtt = [word substringWithRange:NSMakeRange(i, 1)];
      NSLog(@"Decoding digit %@",cardAtt);
      if ([@".012" rangeOfString:cardAtt].location) card.symbol = [[SetCard validSymbols] objectAtIndex:[cardAtt intValue]]; else invalid = YES;
      NSLog(@"Resulting card symbol: %@",card.symbol);
      //shading
      i=2; cardAtt = [word substringWithRange:NSMakeRange(i, 1)];
      NSLog(@"Decoding digit %@",cardAtt);
      if ([@".012" rangeOfString:cardAtt].location) card.shading = [[SetCard validShadings] objectAtIndex:[cardAtt intValue]]; else invalid = YES;
      NSLog(@"Resulting card shading: %@",card.shading);
      //color
      i=3; cardAtt = [word substringWithRange:NSMakeRange(i, 1)];
      NSLog(@"Decoding digit %@",cardAtt);
      if ([@".012" rangeOfString:cardAtt].location) card.color = [[SetCard validColors] objectAtIndex:[cardAtt intValue]]; else invalid = YES;
      NSLog(@"Resulting card color: %@",card.color);
      if (invalid) return [[NSAttributedString alloc] initWithString:word]; else return [self displayValue:card];
   } else {
      return [[NSAttributedString alloc] initWithString:word];
   }
}
- (IBAction)flipCard:(UIButton *)sender {
   //[self disableSegmentedControl];
   [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] gameMode:self.game.gameMode];
   self.flipCount++;
   //sender.selected = !sender.selected; now handled by self.game
   [self updateUI];
}
- (IBAction)deal:(UIButton *)sender {
   //User has touched the deal button. Clean up and deal a new deck of cards.
   self.game = nil;
   self.flipCount = 0;
   [self updateUI];
}
-(void)viewDidLoad
{
   [self updateUI];
}
 */
@end
