//
//  ABFClusterAnnotationView.m
//  ABFRealmMapViewControllerExample
//
//  Created by Adam Fish on 6/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import "ABFClusterAnnotationView.h"

#pragma mark - Constants

static CGFloat const ABFScaleFactorAlpha = 0.3;
static CGFloat const ABFScaleFactorBeta = 0.4;

#pragma mark - Private Functions

static CGPoint ABFRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static CGRect ABFCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - CGRectGetWidth(rect)/2.0,
                          center.y - CGRectGetHeight(rect)/2.0,
                          CGRectGetWidth(rect),
                          CGRectGetHeight(rect)
                          );
    return r;
}

static CGFloat ABFScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * ABFScaleFactorAlpha * powf(value, ABFScaleFactorBeta)));
}

#pragma mark - ABFClusterAnnotationView

@interface ABFClusterAnnotationView()

@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation ABFClusterAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupLabel];
        
        [self setCount:1];
    }
    return self;
}

- (void)setupLabel
{
    self.countLabel = [[UILabel alloc] initWithFrame:self.frame];
    
    self.countLabel.backgroundColor = [UIColor clearColor];
    
    self.countLabel.textColor = [UIColor whiteColor];
    
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    
    self.countLabel.shadowColor = [UIColor clearColor];
    
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    
    self.countLabel.numberOfLines = 1;
    
    self.countLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:self.countLabel];
}

#pragma mark - Setters

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    CGRect newBounds = CGRectMake(0,
                                  0,
                                  roundf(44. * ABFScaledValueForValue(count)),
                                  roundf(44. * ABFScaledValueForValue(count)));
    
    self.frame = ABFCenterRect(newBounds, self.center);
    
    CGRect newLabelBounds = CGRectMake(0,
                                       0,
                                       newBounds.size.width / 1.3,
                                       newBounds.size.height / 1.3);
    
    self.countLabel.frame = ABFCenterRect(newLabelBounds,ABFRectCenter(newBounds));
    
    self.countLabel.text = [@(count) stringValue];
    
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    [self setNeedsDisplay];
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
    
    UIColor *clusterColor = self.color ? self.color : [UIColor redColor];
    
    UIColor *innerCircleFillColor = clusterColor;
    
    CGRect circleFrame = CGRectInset(rect, 4, 4);
    
    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}

@end
