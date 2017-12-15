//
//  ViewController.m
//  CAReplicatorLayerDemo
//
//  Created by zhangxing on 2017/12/14.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewForLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addCircleLayer];
    [self addWave];
    [self addTriangle];
    [self addGrid];
    [self addLine];
    [self addRound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircleLayer {
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, 80, 80);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    shape.fillColor = [UIColor redColor].CGColor;
    shape.opacity = 0.0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[[self alphaAnimation], [self scaleAnimation]];
    animationGroup.duration = 4.0;
    animationGroup.autoreverses = NO;//动画完成后是否回到执行动画之前的状态
    animationGroup.repeatCount = HUGE;
    [shape addAnimation:animationGroup forKey:@"animationGroup"];

    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(0, 0, 80, 80);
    replicator.instanceDelay = 0.5;//复制延时
    replicator.instanceCount = 8;//复制次数,默认为1,不复制
    [replicator addSublayer:shape];
    
    [_viewForLayer.layer addSublayer:replicator];
}

- (CABasicAnimation *)alphaAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.0);
    return animation;
}

- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)];
    return animation;
}

- (void)addWave {
    CGFloat gap = 5.0;
    CGFloat radius = (80-2*gap)/3;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, (80-radius)/2, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.fillColor = [UIColor redColor].CGColor;
    [shape addAnimation:[self waveScaleAnimation] forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(100, 0, 80, 80);
    replicator.instanceDelay = 0.2;
    replicator.instanceCount = 3;
    replicator.instanceTransform = CATransform3DMakeTranslation(gap*2+radius, 0, 0);
    [replicator addSublayer:shape];
    
    [_viewForLayer.layer addSublayer:replicator];
}

- (CABasicAnimation *)waveScaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)];
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    animation.duration = 0.6;
    return animation;
}

- (void)addTriangle {
    CGFloat radius = 80/4;
    CGFloat transX = 80-radius;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor redColor].CGColor;
    shape.lineWidth = 1;
    [shape addAnimation:[self rotationAnimation:transX] forKey:@"rotateAnimation"];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(220, 20, radius, radius);
    replicator.instanceDelay = 0.0;
    replicator.instanceCount = 3;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, transX, 0, 0);
    transform = CATransform3DRotate(transform, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicator.instanceTransform = transform;
    [replicator addSublayer:shape];
    [_viewForLayer.layer addSublayer:replicator];
}

- (CABasicAnimation *)rotationAnimation:(CGFloat)transX {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
    animation.fromValue = [NSValue valueWithCATransform3D:fromValue];
    CATransform3D toValue = CATransform3DTranslate(CATransform3DIdentity, transX, 0.0, 0.0);
    toValue = CATransform3DRotate(toValue, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    animation.toValue = [NSValue valueWithCATransform3D:toValue];
    animation.autoreverses = NO;
    animation.repeatCount = HUGE;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.8;
    return animation;
}

- (void)addGrid {
    int column = 3;
    CGFloat gap = 5.0;
    CGFloat radius = (80-gap*(column-1))/column;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.fillColor = [UIColor redColor].CGColor;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[[self waveScaleAnimation], [self alphaAnimation]];
    animation.duration = 1.0;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    [shape addAnimation:animation forKey:@"groupAnimation"];
    
    CAReplicatorLayer *replicatorX = [CAReplicatorLayer layer];
    replicatorX.frame = CGRectMake(0, 0, 80, 80);
    replicatorX.instanceDelay = 0.3;
    replicatorX.instanceCount = column;
    replicatorX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, radius+gap, 0, 0);
    [replicatorX addSublayer:shape];
    
    CAReplicatorLayer *replicatorY = [CAReplicatorLayer layer];
    replicatorY.frame = CGRectMake(0, 100, 80, 80);
    replicatorY.instanceDelay = 0.3;
    replicatorY.instanceCount = column;
    replicatorY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, radius+gap, 0);
    [replicatorY addSublayer:replicatorX];
    [_viewForLayer.layer addSublayer:replicatorY];
}

- (void)addLine {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 10, 80);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.anchorPoint = CGPointMake(0.5, 1);
    [layer addAnimation:[self scaleYAnimation] forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(100, 140, 80, 80);
    replicator.instanceCount = 6;
    replicator.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    replicator.instanceDelay = 0.2;
    replicator.instanceGreenOffset = -0.3;
    [replicator addSublayer:layer];
    [_viewForLayer.layer addSublayer:replicator];
}

- (CABasicAnimation *)scaleYAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.toValue = @0.1;
    animation.duration = 0.4;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    return animation;
}

- (void)addRound {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 12, 12);
    layer.cornerRadius = 6;
    layer.masksToBounds = YES;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = HUGE;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [layer addAnimation:animation forKey:nil];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(10, 220, 50, 50);
    replicator.preservesDepth = YES;
    replicator.instanceColor = [UIColor whiteColor].CGColor;
    replicator.instanceRedOffset = 0.1;
    replicator.instanceGreenOffset = 0.1;
    replicator.instanceBlueOffset = 0.1;
    replicator.instanceAlphaOffset = 0.1;
    replicator.instanceCount = 9;
    replicator.instanceDelay = 1.0/9;
    replicator.instanceTransform = CATransform3DMakeRotation((2*M_PI)/9, 0, 0, 1);
    [replicator addSublayer:layer];
    [_viewForLayer.layer addSublayer:replicator];
}

@end
