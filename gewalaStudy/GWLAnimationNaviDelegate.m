//
//  GWLAnimationNaviDelegate.m
//  gewalaStudy
//
//  Created by 陈程 on 16/5/4.
//  Copyright © 2016年 陈程. All rights reserved.
//

#import "GWLAnimationNaviDelegate.h"
#import "GWLAnimator.h"
#import <UIKit/UIKit.h>

@interface GWLAnimationNaviDelegate()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@end

@implementation GWLAnimationNaviDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        //push的动画
        return (id)[GWLAnimator new];
    }else{
        return nil;
    }
    
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    return self.interactionController;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panGeature = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
    [self.navigationController.view addGestureRecognizer:panGeature];
}

- (void)panned:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController.topViewController performSegueWithIdentifier:@"PushSegue" sender:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGPoint transition = [panGesture translationInView:self.navigationController.view];
            CGFloat completionProgress = transition.x / CGRectGetWidth(self.navigationController.view.bounds);
            [self.interactionController updateInteractiveTransition:completionProgress];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if ([panGesture velocityInView:self.navigationController.view].x > 0) {
                NSLog(@"----=====%f",[panGesture velocityInView:self.navigationController.view].x);
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
            
            break;
        }
        default:
            [self.interactionController cancelInteractiveTransition];
            self.interactionController = nil;
            break;
    }
}


@end
