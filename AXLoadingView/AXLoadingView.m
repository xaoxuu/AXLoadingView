//
//  AXLoadingView.m
//  AXLoadingView
//
//  Created by xaoxuu on 2019/1/2.
//  Copyright © 2019 xaoxuu. All rights reserved.
//

#import "AXLoadingView.h"


#define kArcsCount 20.0f
static CGFloat kMDMaxStrokeLength = 0.75f;
static CGFloat kMDMinStrokeLength = 0.05f;
static CGFloat animationDuration = 0.75f;
static CGFloat rotateAnimationDuration = 2.0f;
static CGFloat anArc = 1.0f / kArcsCount;

static inline CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CAMediaTimingFunction *tfEaseInEaseOut(){
    static CAMediaTimingFunction *tf;
    if (!tf) {
        tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return tf;
}
static inline CAMediaTimingFunction *tfPrimary(){
    static CAMediaTimingFunction *tf;
    if (!tf) {
        tf = [CAMediaTimingFunction functionWithControlPoints:0.3f:0.3f:0.9f:0.5f];
    }
    return tf;
}
static inline CAMediaTimingFunction *tfEaseOut(){
    static CAMediaTimingFunction *tf;
    if (!tf) {
        tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    return tf;
}
static inline CAMediaTimingFunction *tfLinear(){
    static CAMediaTimingFunction *tf;
    if (!tf) {
        tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    return tf;
}

static inline CAAnimationGroup *primaryIndeterminateAnimation() {
    static CAAnimationGroup *animationGroups = nil;
    if (!animationGroups) {
        CABasicAnimation *headInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        headInAnimation.duration = 0.8f;
        headInAnimation.fromValue = @(0.0f);
        headInAnimation.toValue = @(1.0f);
        headInAnimation.timingFunction = tfEaseOut();
        
        CABasicAnimation *tailInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        tailInAnimation.duration = 1.2f;
        tailInAnimation.fromValue = @(-0.1f);
        tailInAnimation.toValue = @(1.0f);
        tailInAnimation.timingFunction = tfPrimary();
        
        CABasicAnimation *headOutAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        headOutAnimation.beginTime = 0.8f;
        headOutAnimation.duration = 0.4f;
        headOutAnimation.fromValue = @(1.0f);
        headOutAnimation.toValue = @(1.0f);
        headOutAnimation.timingFunction = tfLinear();
        
        animationGroups = [CAAnimationGroup animation];
        [animationGroups setAnimations:@[headInAnimation, tailInAnimation, headOutAnimation]];
        [animationGroups setRepeatCount:INFINITY];
        animationGroups.duration = 1.8f;
        animationGroups.removedOnCompletion = false;
        animationGroups.fillMode = kCAFillModeForwards;
    }
    
    return animationGroups;
}

static CAAnimationGroup *secondaryIndeterminateAnimation() {
    static CAAnimationGroup *animationGroups = nil;
    if (!animationGroups) {
        CABasicAnimation *headInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        headInAnimation.beginTime = 1.0f;
        headInAnimation.duration = 0.6f;
        headInAnimation.fromValue = @(0.0f);
        headInAnimation.toValue = @(1.0f);
        headInAnimation.timingFunction = tfEaseOut();
        
        CABasicAnimation *tailInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        tailInAnimation.beginTime = 1.2f;
        tailInAnimation.duration = 0.6f;
        tailInAnimation.fromValue = @(-0.f);
        tailInAnimation.toValue = @(1.2f);
        tailInAnimation.timingFunction = tfLinear();
        
        CABasicAnimation *headOutAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        headOutAnimation.beginTime = 1.6f;
        headOutAnimation.duration = .2f;
        headOutAnimation.fromValue = @(1.f);
        headOutAnimation.toValue = @(1.f);
        headOutAnimation.timingFunction = tfLinear();
        
        animationGroups = [CAAnimationGroup animation];
        [animationGroups setAnimations:@[headInAnimation, tailInAnimation, headOutAnimation]];
        [animationGroups setRepeatCount:INFINITY];
        animationGroups.duration = 1.8f;
        animationGroups.removedOnCompletion = false;
        animationGroups.fillMode = kCAFillModeForwards;
    }
    
    return animationGroups;
}

static inline NSArray *createStrokeAnimation(float beginValue, float beginTime, float aCircle){
    
    CABasicAnimation *headAnimation =
    [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    headAnimation.duration = animationDuration;
    headAnimation.beginTime = beginTime;
    headAnimation.fromValue = @(beginValue);
    headAnimation.toValue = @(beginValue + aCircle * (kMDMaxStrokeLength + kMDMinStrokeLength));
    headAnimation.timingFunction = tfEaseInEaseOut();
    
    CABasicAnimation *tailAnimation =
    [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    tailAnimation.duration = animationDuration;
    tailAnimation.beginTime = beginTime;
    tailAnimation.fromValue = @(beginValue - aCircle * kMDMinStrokeLength);
    tailAnimation.toValue = @(beginValue);
    tailAnimation.timingFunction = tfEaseInEaseOut();
    
    CABasicAnimation *endHeadAnimation =
    [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endHeadAnimation.duration = animationDuration;
    endHeadAnimation.beginTime = beginTime + animationDuration;
    endHeadAnimation.fromValue = @(beginValue + aCircle * (kMDMaxStrokeLength + kMDMinStrokeLength));
    endHeadAnimation.toValue = @(beginValue + aCircle * (kMDMaxStrokeLength + kMDMinStrokeLength));
    endHeadAnimation.timingFunction = tfEaseInEaseOut();
    
    CABasicAnimation *endTailAnimation =
    [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endTailAnimation.duration = animationDuration;
    endTailAnimation.beginTime = beginTime + animationDuration;
    endTailAnimation.fromValue = @(beginValue);
    endTailAnimation.toValue = @(beginValue + aCircle * kMDMaxStrokeLength);
    endTailAnimation.timingFunction = tfEaseInEaseOut();
    return @[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation];
}


static inline CAAnimationGroup *circleIndeterminateAnimation() {
    static CAAnimationGroup *animationGroups = nil;
    if (!animationGroups) {
        NSMutableArray *animations = [NSMutableArray array];
        // stroke
        float startValue = 0;
        float startTime = 0;
        do {
            [animations addObjectsFromArray:createStrokeAnimation(startValue, startTime, anArc)];
            startValue += anArc * (kMDMaxStrokeLength + kMDMinStrokeLength);
            startTime += animationDuration * 2;
        } while (fmodf(floorf(startValue * 1000), 1000) != 0);
        
        animationGroups = [CAAnimationGroup animation];
        animationGroups.duration = startTime;
        [animationGroups setAnimations:animations];
        [animationGroups setRepeatCount:INFINITY];
        animationGroups.removedOnCompletion = false;
        animationGroups.fillMode = kCAFillModeForwards;
        
    }
    
    return animationGroups;
}

@implementation AXLoadingView{
    CGFloat _cirleDiameter;
    BOOL _isAnimating;
    CALayer *_drawingLayer;
    CAShapeLayer *_progressLayer;
    CAShapeLayer *_secondaryProgressLayer;
    CAShapeLayer *_trackLayer;
}

- (instancetype)init {
    if (self = [super init]){
        [self initLayer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        [self initLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(AXLoadingViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self initLayer];
    }
    return self;
}

- (void)initLayer {
    
    _progressColor = [UIColor colorWithWhite:0.5 alpha:1];
    _trackColor = [UIColor colorWithWhite:0.9 alpha:1];
    _trackWidth = 4;
    _drawingLayer = [CALayer layer];
    
    [self updateFrame];
    
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.strokeColor = self.trackColor.CGColor;
    _trackLayer.fillColor = nil;
    _trackLayer.lineWidth = self.trackWidth;
    _trackLayer.strokeStart = 0.f;
    _trackLayer.strokeEnd = 1.f;
    _trackLayer.lineCap = kCALineCapRound;
    _trackLayer.frame = _drawingLayer.bounds;
    [_drawingLayer addSublayer:_trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = self.progressColor.CGColor;
    _progressLayer.fillColor = nil;
    _progressLayer.lineWidth = self.trackWidth;
    _progressLayer.strokeStart = 0.f;
    _progressLayer.strokeEnd = 1.f;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.frame = _drawingLayer.bounds;
    [_drawingLayer addSublayer:_progressLayer];
    
    if (self.style == AXLoadingViewStyleLinear) {
        _secondaryProgressLayer = [CAShapeLayer layer];
        _secondaryProgressLayer.strokeColor = self.progressColor.CGColor;
        _secondaryProgressLayer.fillColor = nil;
        _secondaryProgressLayer.lineWidth = self.trackWidth;
        _secondaryProgressLayer.strokeStart = 0.f;
        _secondaryProgressLayer.strokeEnd = 0.f;
        _secondaryProgressLayer.lineCap = kCALineCapRound;
        [_drawingLayer addSublayer:_secondaryProgressLayer];
    }
    
    [self updateContents];
    
    [self.layer addSublayer:_drawingLayer];
    [self.layer addObserver:self forKeyPath:@"bounds" options:9 context:nil];
    
    // 初始化
    self.progress = -1;
    
}

#pragma mark - setters

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _progressLayer.strokeColor = progressColor.CGColor;
    _secondaryProgressLayer.strokeColor = progressColor.CGColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setTrackWidth:(CGFloat)trackWidth {
    _trackWidth = trackWidth;
    [self sublayers:^(CAShapeLayer *layer) {
        layer.lineWidth = trackWidth;
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (progress >= 0) {
        if (self.style == AXLoadingViewStyleLinear) {
            _progressLayer.strokeEnd = progress;
        } else {
            _progressLayer.strokeEnd = anArc * self.progress;
            _progressLayer.transform = CATransform3DMakeRotation(3 * M_PI_2, 0, 0, 1);
        }
    } else {
        _progressLayer.strokeEnd = 0;
    }
    if (progress >= 0 && _isAnimating) {
        [self stopAnimating];
    } else if (progress < 0 && !_isAnimating) {
        [self startAnimating];
    }
    
}

#pragma mark - private methods

- (void)dealloc {
    [self.layer removeObserver:self forKeyPath:@"bounds"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self updateFrame];
    [self updateContents];
}

- (void)startAnimating {
    if (_isAnimating || self.progress >= 0)
        return;
    
    if (self.style == AXLoadingViewStyleLinear) {
        [_progressLayer addAnimation:primaryIndeterminateAnimation() forKey:@"primaryAnimation"];
        [_secondaryProgressLayer addAnimation:secondaryIndeterminateAnimation() forKey:@"secondaryAnimation"];
    } else {
        CABasicAnimation *rotateAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.duration = rotateAnimationDuration;
        rotateAnimation.fromValue = @(0.f);
        rotateAnimation.toValue = @(2 * M_PI);
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.removedOnCompletion = false;
        rotateAnimation.fillMode = kCAFillModeForwards;
        [_drawingLayer addAnimation:rotateAnimation forKey:@"circleIndeterminateAnimation"];
        [_progressLayer addAnimation:circleIndeterminateAnimation() forKey:@"circleIndeterminateAnimation"];
    }
    _isAnimating = true;
}

- (void)stopAnimating {
    if (!_isAnimating)
        return;
    [_progressLayer removeAllAnimations];
    if (self.style == AXLoadingViewStyleLinear) {
        [_secondaryProgressLayer removeAllAnimations];
    } else {
        [_drawingLayer removeAllAnimations];
    }
    _isAnimating = false;
}

- (void)sublayers:(void (^)(CAShapeLayer *layer))layer{
    if (layer) {
        layer(_trackLayer);
        layer(_progressLayer);
        layer(_secondaryProgressLayer);
    }
}

- (void)updateFrame {
    if (self.style == AXLoadingViewStyleLinear) {
        _drawingLayer.frame = CGRectMake(0, CGRectCenter(self.layer.bounds).y - self.trackWidth / 2, self.layer.bounds.size.width, self.trackWidth);
        _trackLayer.frame = _drawingLayer.bounds;
        _progressLayer.frame = _drawingLayer.bounds;
        _secondaryProgressLayer.frame = _drawingLayer.bounds;
    } else {
        _cirleDiameter = MIN(self.layer.bounds.size.width, self.layer.bounds.size.height);
        if (_cirleDiameter <= 0) {
            _cirleDiameter = 32;
        }
        CGPoint center = CGRectCenter(self.layer.bounds);
        _drawingLayer.frame = CGRectMake(center.x - _cirleDiameter / 2, center.y - _cirleDiameter / 2, _cirleDiameter, _cirleDiameter);
        _trackLayer.frame = _drawingLayer.bounds;
        _progressLayer.frame = _drawingLayer.bounds;
    }
}

- (void)updateContents {
    if (self.style == AXLoadingViewStyleLinear) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, CGRectGetMidY(_drawingLayer.bounds))];
        [linePath addLineToPoint:CGPointMake(_drawingLayer.bounds.size.width, CGRectGetMidY(_drawingLayer.bounds))];
        _progressLayer.path = linePath.CGPath;
        _secondaryProgressLayer.path = linePath.CGPath;
        _trackLayer.path = linePath.CGPath;
        
    } else {
        CGFloat radius = MIN(CGRectGetWidth(_drawingLayer.bounds) / 2, CGRectGetHeight(_drawingLayer.bounds) / 2) - _progressLayer.lineWidth / 2;
        CGFloat startAngle = (CGFloat)(0);
        CGFloat endAngle = (CGFloat)((kArcsCount * 2 + 1.5f) * M_PI);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGRectCenter(_drawingLayer.bounds)
                                                            radius:radius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        _progressLayer.path = path.CGPath;
        _trackLayer.path = path.CGPath;
    }
}


@end
