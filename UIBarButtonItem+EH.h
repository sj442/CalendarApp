//
//  UIBarButtonItem+EH.h
//  CRMStar
//
//  Created by epau on 1/9/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (EH)

+ (UIBarButtonItem *)flexSpacerItem;

+ (UIBarButtonItem *)fixedSpacerItem;

+(UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image andTitle:(NSString*)title target:(id)target action:(SEL)selector;


@end
