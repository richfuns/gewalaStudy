//
//  GWLAnimator.m
//  gewalaStudy
//
//  Created by 陈程 on 16/5/4.
//  Copyright © 2016年 陈程. All rights reserved.
//

#import "GWLAnimator.h"
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ToViewController.h"

@interface GWLAnimator()<UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) id transitionContext;

@end

@implementation GWLAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    ViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    ToViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    
    toViewController.view.alpha = 0;
    fromViewController.imageView.layer.shadowOffset = CGSizeMake(5, 5);
    fromViewController.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    fromViewController.imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    fromViewController.imageView.layer.shadowRadius = 4;//阴影半径，默认3
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.imageView.frame = CGRectMake(toViewController.imageView.frame.origin.x, toViewController.imageView.frame.origin.y, toViewController.imageView.frame.size.width, toViewController.imageView.frame.size.height);
    } completion:^(BOOL finished) {
        toViewController.view.alpha = 1;
        fromViewController.imageView.layer.shadowOffset = CGSizeMake(0, 0);
        fromViewController.imageView.layer.shadowOpacity = 0;//阴影透明度，默认0
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:fromViewController.imageView.frame];
        CGPoint extremePoint = CGPointMake(toViewController.imageView.center.x - 0, toViewController.imageView.center.y - CGRectGetHeight(toViewController.view.bounds));
        
        float radius = sqrtf(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y);
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(toViewController.view.frame, -radius, -radius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = finalPath.CGPath;
        toViewController.view.layer.mask = maskLayer;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
        animation.duration = [self transitionDuration:transitionContext];
        animation.delegate = self;
        [maskLayer addAnimation:animation forKey:@"path"];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}


@end
