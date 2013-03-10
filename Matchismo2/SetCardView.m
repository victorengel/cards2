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
   
   [self drawPips];
}
-(void)viewDidLoad
{
   [self drawPips];
}

-(void)drawPips
{
   //Hard code number and shading for testing purposes.
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
   //just a change to test bitbucket
   UIColor *color = [SetCard colorAsUIColor:self.color];
   CGFloat bezMinY = 288.0;CGFloat bezMaxY = 456.0;CGFloat bezHeight = bezMaxY - bezMinY;
   CGFloat bezMinX = 240.0;CGFloat bezMaxX = 528.0;CGFloat bezWidth = bezMaxX - bezMinX;
   CGFloat marginSize = self.bounds.size.height / 20.0;
   CGFloat ratio;// = self.bounds.size.width / 780.0;
   ratio = (self.bounds.size.height - marginSize*2.0)/6.44/bezHeight; // Calculate ratio so bezier shape is 1/6.44 height of the view.
   CGFloat normalizedBezHeight = bezHeight * ratio;
   CGFloat normalizedBezWidth = bezWidth * ratio;
   CGFloat halfShape = normalizedBezWidth / 2.0;
   CGFloat halfBounds = self.bounds.size.width/2.0 - marginSize;
   CGFloat shapeMargin = halfBounds - halfShape;
   CGFloat xOffset = marginSize + shapeMargin - bezMinX * ratio;
   CGFloat freeSpace = self.bounds.size.height;                            //Total free space (including pips)
   freeSpace -= 2.0 * marginSize;                                          //Free space not counting margins.
   CGFloat spaceBetweenPips, startingYOffset, yOffset;
   int numberOfPips = [SetCard numberAsNumber:self.number] + 1;
   freeSpace -= (numberOfPips) * normalizedBezHeight;                      //Free space not including shapes.
   spaceBetweenPips = freeSpace / (numberOfPips + 1.0);                    //Total number of spaces is one more than number of pips
   startingYOffset = marginSize + spaceBetweenPips - bezMinY*ratio;      //Subtract bezMinY*ratio because beziers are not zero based.
   yOffset = startingYOffset;
   for (int i=1; i<=numberOfPips; i++) {
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
      /*
       If you need to remove the clipping region to perform subsequent drawing operations, you must save the current graphics state (using the CGContextSaveGState function) before calling this method. When you no longer need the clipping region, you can then restore the previous drawing properties and clipping region using the CGContextRestoreGState function.
       */
      if ([self.shading isEqualToString:@"striped"]) {
         CGContextRef savedContext = UIGraphicsGetCurrentContext();
         CGContextSaveGState(savedContext);
         [thePath addClip];
         //Now draw some vertical lines
         CGFloat lineWidth = self.bounds.size.width / (20*4.0); // 25% of the fill is line, the rest is space
         CGFloat lineSpacing = self.bounds.size.width / 20.0;
         UIBezierPath *theFillPath = [UIBezierPath bezierPath];
         CGFloat yStart = 0.0;
         CGFloat yStop = self.bounds.size.height;
         for (int lineNumber = 0; lineNumber<20; lineNumber++) {
            CGFloat xPosition = lineNumber * lineSpacing;
            [theFillPath moveToPoint:CGPointMake(xPosition, yStart)];
            [theFillPath addLineToPoint:CGPointMake(xPosition, yStop)];
         }
         theFillPath.lineWidth = lineWidth;
         [theFillPath stroke];
         CGContextRestoreGState(savedContext);
      } else {
         [thePath fill];
      }
      yOffset += normalizedBezHeight;
      yOffset += spaceBetweenPips;
      thePath = nil;
   }
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
