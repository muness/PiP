//
//  SelectionView.m
//  pip
//
//  Created by Amit Verma on 05/12/17.
//  Copyright © 2017 boggyb. All rights reserved.
//

#import "selectionView.h"

@implementation SelectionView

#pragma mark Mouse Events

#define NSColorFromRGB(rgbValue) [NSColor colorWithCalibratedRed:((float)((rgbValue & 0xFF000000) >> 16))/255.0 green:((float)((rgbValue & 0xFF0000) >> 8))/255.0 blue:((float)(rgbValue & 0xFF00))/255.0 alpha:((float)(rgbValue & 0xFF))/255.0]

- (void)mouseDown:(NSEvent *)theEvent
{
    self.startPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // create and configure shape layer
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.shadowOpacity = 0.5;

    self.shapeLayer.strokeColor = [[NSColor grayColor] CGColor];
    self.shapeLayer.fillColor = [NSColorFromRGB(0x00000044) CGColor];
    self.shapeLayer.shadowColor = [[NSColor whiteColor] CGColor];
    self.shapeLayer.lineDashPattern = @[@10, @10];
    [self.layer addSublayer:self.shapeLayer];
    
    // create animation for the layer
    
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:@0.0f];
    [dashAnimation setToValue:@15.0f];
    [dashAnimation setDuration:0.75f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [self.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // create path for the shape layer
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
    CGPathAddLineToPoint(path, NULL, self.startPoint.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGPathAddLineToPoint(path, NULL, point.x, self.startPoint.y);
    CGPathCloseSubpath(path);
    
    // set the shape layer's path
    
    self.shapeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)mouseUp:(NSEvent *)theEvent{
    self.endPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [[NSCursor arrowCursor] set];
    
    //    NSLog(@"start point %f %f, end pint %f %f", self.startPoint.x, self.startPoint.y, self.endPoint.x, self.endPoint.y);
    
    float left = self.startPoint.x < self.endPoint.x ? self.startPoint.x : self.endPoint.x;
    float top = self.startPoint.y < self.endPoint.y ? self.startPoint.y : self.endPoint.y;
    float width = fabs(-self.startPoint.x + self.endPoint.x);
    float height = fabs(-self.startPoint.y + self.endPoint.y);
    
    self.selection = NSMakeRect(left, top, width, height);
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    [self.window setMovable:YES];
    [self removeFromSuperview];
}

@end
