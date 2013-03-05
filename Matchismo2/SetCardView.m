//
//  SetCardView.m
//  Matchismo
//
//  Created by Victor Engel on 2/28/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"
#import "SquiggleView.h"

@implementation SetCardView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
   [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
   
   [[UIColor whiteColor] setFill];
   UIRectFill(self.bounds);
   
   [[UIColor blackColor] setStroke];
   [roundedRect stroke];
   
   if (self.faceUp) {
      [self drawPips];
      //[self drawCorners];
   } else {
      //For set card set alpha to very low or something.
      //[self drawPips];
      //[self drawCorners];
      //self.alpha = 0.1;
   }
   
}
-(void)viewDidLoad
{
   [self drawPips];
}
#define PIP_FONT_SCALE_FACTOR 0.20

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

-(void)drawPips
{
   CGFloat ratio = self.bounds.size.width / 500.0;
   NSLog(@"Self.bounds.size.height: %f",self.bounds.size.height);
   NSLog(@"ratio: %f",ratio);
   //UIBezierPath *thePath = [[UIBezierPath alloc] init];
   UIBezierPath *thePath = [UIBezierPath bezierPath];
   [thePath moveToPoint:CGPointMake(ratio*72.0,ratio*216.0)];
   NSLog(@"Start at %f,%f",ratio*72.0,ratio*216.0);
   NSLog(@"Go to %f,%f",ratio*372.0,ratio*120.0);
   NSLog(@"Control pt1: %f,%f",ratio*24.0,ratio*24.0);
   NSLog(@"Control pt2: %f,%f",ratio*300.0,ratio*228.0);
   [thePath addCurveToPoint:CGPointMake(ratio*372.0,ratio*120.0) controlPoint1:CGPointMake(ratio*24.0,ratio*24.0) controlPoint2:CGPointMake(ratio*300.0,ratio*228.0)];
   //That's one side of the shape. Now let's do the other side, which uses the same endpoints
   //but uses control points rotated 180 degrees about the center between the endpoints.
   //No moveToPoint needed, because we're already there.
   [thePath addCurveToPoint:CGPointMake(ratio*72.0,ratio*216.0) controlPoint1:CGPointMake(ratio*420.0,ratio*312.0) controlPoint2:CGPointMake(ratio*144.0,ratio*108.0)];
   [[UIColor blackColor] setStroke];
   [[UIColor whiteColor] setFill];
   //   CGContextRef aRef = UIGraphicsGetCurrentContext();
   //   CGContextSaveGState(aRef);
   //   CGContextTranslateCTM(aRef, 50, 50);
   thePath.lineWidth = 1.0;
   [thePath stroke];
   
   //   CGContextRestoreGState(aRef);
   /*
   UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 50)];
   [[UIColor blackColor] setStroke];
   [[UIColor redColor] setFill];
   CGContextRef aRef = UIGraphicsGetCurrentContext();
   CGContextSaveGState(aRef);
   CGContextTranslateCTM(aRef, 50, 50);
   aPath.lineWidth = 5;
   [aPath fill];
   [aPath stroke];
   CGContextRestoreGState(aRef);
*/
/*   CGRect symbolFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height/3.0);
   NSLog(@"drawPips - working on %@ %@",self.symbol,self.number);
   if ([self.symbol isEqualToString:@"squiggle"]) {
      NSUInteger numberOfSymbols = [SetCard numberAsNumber:self.number];
      if (numberOfSymbols != NSNotFound) {
         for (int i=0; i<=[SetCard numberAsNumber:self.number]; i++) {
            SquiggleView *squiggleView = [[SquiggleView alloc] initWithFrame:symbolFrame];
            [self addSubview:squiggleView];
            squiggleView.center = self.center;
         }
      }
   }
*/
   /*if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
      [self drawPipsWithHorizontalOffset:0
                          verticalOffset:0
                      mirroredVertically:NO];
   }
   if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
      [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                          verticalOffset:0
                      mirroredVertically:NO];
   }
   if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
      [self drawPipsWithHorizontalOffset:0
                          verticalOffset:PIP_VOFFSET2_PERCENTAGE
                      mirroredVertically:(self.rank != 7)];
   }
   if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
      [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                          verticalOffset:PIP_VOFFSET3_PERCENTAGE
                      mirroredVertically:YES];
   }
   if ((self.rank == 9) || (self.rank == 10)) {
      [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                          verticalOffset:PIP_VOFFSET1_PERCENTAGE
                      mirroredVertically:YES];
   }*/
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown
{
   /*if (upsideDown) [self pushContextAndRotateUpsideDown];
   CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
   UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
   NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName : pipFont}];
   CGSize pipSize = attributedSuit.size;
   CGPoint pipOrigin = CGPointMake(
                                   middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                   middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                   );
   [attributedSuit drawAtPoint:pipOrigin];
   if (hoffset) {
      pipOrigin.x += hoffset*2.0*self.bounds.size.width;
      [attributedSuit drawAtPoint:pipOrigin];
   }
   
   if (upsideDown) [self popContext];*/
}


-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically
{
   [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
   if (mirroredVertically) {
      [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
   }
}

-(void)drawCorners
{
   NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
   paragraphStyle.alignment = NSTextAlignmentCenter;
   
   UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * 0.20];
   
   NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@\n%@%@", self.number, self.symbol, self.shading, self.color] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont}];
   
   CGRect textBounds;
   textBounds.origin = CGPointMake(2.0, 2.0);
   textBounds.size = cornerText.size;
   [cornerText drawInRect:textBounds];
   
   [self pushContextAndRotateUpsideDown];
   [cornerText drawInRect:textBounds];
   [self popContext];
}

-(void)pushContextAndRotateUpsideDown
{
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSaveGState(context);
   CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
   CGContextRotateCTM(context, M_PI);
}

-(void)popContext
{
   CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(void)setNumber:(NSString *)number
{
   _number = number;
   [self setNeedsDisplay];
}
-(void)setShape:(NSString *)symbol
{
   _symbol = symbol;
   [self setNeedsDisplay];
}
-(void)setColor:(NSString *)color
{
   _color = color;
   [self setNeedsDisplay];
}
-(void)setShading:(NSString *)shading
{
   _shading = shading;
   [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp
{
   _faceUp = faceUp;
   [self setNeedsDisplay];
}
/*-(void)viewDidLoad
{
   if ([self.symbol isEqualToString:@"squiggle"]) {
      NSUInteger numberOfSymbols = [SetCard numberAsNumber:self.number];
      if (numberOfSymbols != NSNotFound) {
         for (int i=0; [SetCard numberAsNumber:self.number]; i++) {
            SetCardView *setCardView = [[SetCardView alloc] init];
            [self addSubview:setCardView];
         }
      }
   }
}*/
# pragma mark _ Initialization
-(void)setUp
{
   // inititalization that can't wait until viewDidLoad
}
-(void)awakeFromNib
{
   [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   [self setUp];
   return self;
}


@end
