//
//  SquiggleView.m
//  Matchismo
//
//  Created by Victor Engel on 2/28/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//
//  Draws a single squiggle.

#import "SquiggleView.h"

@implementation SquiggleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
   CGFloat ratio = self.bounds.size.width / 500.0;
   ratio = rect.size.width / 500.0;
   NSLog(@"Self.bounds.size.height: %f",self.bounds.size.height);
   NSLog(@"rect width is %f",rect.size.width);
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
   thePath.lineWidth = 1.0;
   [thePath stroke];
   [self setNeedsDisplay];
}
*/
- (void)drawRect:(CGRect)rect
{
   UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 100)];
   [[UIColor blackColor] setStroke];
   [[UIColor redColor] setFill];
   CGContextRef aRef = UIGraphicsGetCurrentContext();
   CGContextSaveGState(aRef);
   CGContextTranslateCTM(aRef, 50, 50);
   aPath.lineWidth = 5;
   [aPath fill];
   [aPath stroke];
   CGContextRestoreGState(aRef);
}
@end
