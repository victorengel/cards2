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
   /*
    +---------------------------------------+
    |                                       |>   margin
    |  +---------------------------------+  |
    |                                       |\   spaceBetweenPips
    |                                       |/   spaceBetweenPips
    |  +---------------------------------+  |
    |  |   ###########################   |  |\
    |  |   ###########################   |  | >  normalizedBezHeight
    |  |   ###########################   |  |/
    |  +---------------------------------+  |
    |                                       |\   spaceBetweenPips
    |                                       |/   spaceBetweenPips
    |  +---------------------------------+  |
    |  |   ###########################   |  |\
    |  |   ###########################   |  | >  normalizedBezHeight
    |  |   ###########################   |  |/
    |  +---------------------------------+  |
    |                                       |\   spaceBetweenPips
    |                                       |/   spaceBetweenPips
    |  +---------------------------------+  |
    |  |   ###########################   |  |\
    |  |   ###########################   |  | >  normalizedBezHeight
    |  |   ###########################   |  |/
    |  +---------------------------------+  |
    |                                       |\   spaceBetweenPips
    |                                       |/   spaceBetweenPips
    |  +---------------------------------+  |
    |                                       |>   marginSize
    +---------------------------------------+
    |--|                                         marginSize
           |------------|                        halfShape = normalized width/2
       |----------------|                        halfBounds = (bounds width)/2 - margin
       |---|                                     shapeMargin = halfBounds - halfShape
    |------|                                     xOffset = margin + shapeMargin - bezMinx * ratio
    */
   UIColor *color = [SetCard colorAsUIColor:self.color];
   NSLog(@"Card is %@",self.description);
   NSLog(@"Number is %@ %d",self.number, [SetCard numberAsNumber:self.number]);
   NSLog(@"Shading is %@",self.shading);
   NSLog(@"Symbol is %@",self.symbol);
   NSLog(@"Color is %@",self.color);
   NSLog(@"Bounds height is %f",self.bounds.size.height);
   // Bezier min y = 288, max y = 456, dif y =
   CGFloat bezMinY = 288.0;CGFloat bezMaxY = 456.0;CGFloat bezHeight = bezMaxY - bezMinY;NSLog(@"bezHeight is %f",bezHeight);
   CGFloat bezMinX = 240.0;CGFloat bezMaxX = 528.0;CGFloat bezWidth = bezMaxX - bezMinX;NSLog(@"bezWidth is %f",bezWidth);
   CGFloat marginSize = self.bounds.size.height / 20.0;
   CGFloat ratio;// = self.bounds.size.width / 780.0;
   ratio = (self.bounds.size.height - marginSize*2.0)/6.44/bezHeight; // Calculate ratio so bezier shape is 1/6.44 height of the view.
   CGFloat normalizedBezHeight = bezHeight * ratio;
   CGFloat normalizedBezWidth = bezWidth * ratio;
   CGFloat halfShape = normalizedBezWidth / 2.0;
   CGFloat halfBounds = self.bounds.size.width/2.0 - marginSize;
   CGFloat shapeMargin = halfBounds - halfShape;
   CGFloat xOffset = marginSize + shapeMargin - bezMinX * ratio;
   NSLog(@"Normalized bez height: %f",normalizedBezHeight);
   CGFloat freeSpace = self.bounds.size.height;                            //Total free space (including pips)
   freeSpace -= 2.0 * marginSize;                                          //Free space not counting margins.
   CGFloat spaceBetweenPips, startingYOffset, yOffset;
   int numberOfPips = [SetCard numberAsNumber:self.number] + 1;
   freeSpace -= (numberOfPips) * normalizedBezHeight;                      //Free space not including shapes.
   NSLog(@"Free space after subtracting pips: %f",freeSpace);
   spaceBetweenPips = freeSpace / (numberOfPips + 1.0);                    //Total number of spaces is one more than number of pips
   NSLog(@"Starting offset is %f / (%d + 1) = %f",freeSpace,numberOfPips,spaceBetweenPips);
   startingYOffset = marginSize + spaceBetweenPips - bezMinY*ratio;      //Subtract bezMinY*ratio because beziers are not zero based.
   NSLog(@"Starting offset after subtracting yMin: %f is %f",bezMinY*ratio,startingYOffset);
   yOffset = startingYOffset;
   for (int i=1; i<=numberOfPips; i++) {
      NSLog(@"yOffset for current bez: %f",yOffset);
      UIBezierPath *thePath = [UIBezierPath bezierPath];
      if ([self.symbol isEqualToString:@"squiggle"]) {
         [thePath moveToPoint:CGPointMake(    xOffset + ratio*240.0,ratio*456.0+yOffset)];  //left
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*252.0,ratio*288.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*168.0,ratio*528.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*132.0,ratio*336.0+yOffset)];  //left
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*528.0,ratio*288.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*372.0,ratio*240.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*456.0,ratio*360.0+yOffset)];  //top
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*516.0,ratio*456.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*600.0,ratio*216.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*636.0,ratio*408.0+yOffset)];  //right
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*240.0,ratio*456.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*396.0,ratio*504.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*312.0,ratio*384.0+yOffset)];  //bottom
         [thePath closePath];
      }
      if ([self.symbol isEqualToString:@"oval"]) {
         [thePath moveToPoint:CGPointMake(xOffset + ratio*480.0,ratio*276.0+yOffset)];          //move to start
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*480.0,ratio*468.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*624.0,ratio*276.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*624.0,ratio*468.0+yOffset)];      //first curve
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*288.0,ratio*468.0+yOffset)];       //first line
         [thePath addCurveToPoint:CGPointMake(xOffset + ratio*288.0,ratio*276.0+yOffset)
                    controlPoint1:CGPointMake(xOffset + ratio*144.0,ratio*468.0+yOffset)
                    controlPoint2:CGPointMake(xOffset + ratio*144.0,ratio*276.0+yOffset)];      //second curve
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*480.0,ratio*276.0+yOffset)];       //second line
         [thePath closePath];
      }
      if ([self.symbol isEqualToString:@"diamond"]) {
         [thePath moveToPoint:CGPointMake(   xOffset + ratio*384.0,ratio*468.0+yOffset)]; // top
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*588.0,ratio*372.0+yOffset)]; // right
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*384.0,ratio*276.0+yOffset)]; // bottom
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*180.0,ratio*372.0+yOffset)]; // left
         [thePath addLineToPoint:CGPointMake(xOffset + ratio*384.0,ratio*468.0+yOffset)]; // top
         [thePath closePath];
      }
      [color setStroke];
      thePath.lineWidth = 1.0;
      if ([self.shading isEqualToString:@"solid"]) {
         [color setFill];
      }
      if ([self.shading isEqualToString:@"open"]) {
         [[UIColor whiteColor] setFill];
      }
      [thePath stroke];
      [thePath fill];
      if ([self.shading isEqualToString:@"striped"]) {
         [thePath addClip];
         //Now draw some vertical lines
         CGFloat lineWidth = self.bounds.size.width / (20*4.0); // 25% of the fill is line, the rest is space
         CGFloat lineSpacing = self.bounds.size.width / 20.0;
         UIBezierPath *thePath = [UIBezierPath bezierPath];
         CGFloat yStart = 0.0;
         CGFloat yStop = self.bounds.size.height;
         for (int lineNumber = 0; lineNumber<20; lineNumber++) {
            CGFloat xPosition = lineNumber * lineSpacing;
            [thePath moveToPoint:CGPointMake(xPosition, yStart)];
            [thePath addLineToPoint:CGPointMake(xPosition, yStop)];
         }
         thePath.lineWidth = lineWidth;
         [thePath stroke];
         //[thePath fill];
      }
      yOffset += normalizedBezHeight;
      yOffset += spaceBetweenPips;
   }
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
