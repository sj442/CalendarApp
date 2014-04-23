//
//  UIBarButtonItem+EH.m
//  CRMStar
//
//  Created by epau on 1/9/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "UIBarButtonItem+EH.h"

@implementation UIBarButtonItem (EH)

+ (UIBarButtonItem *)fixedSpacerItem
{
    UIBarButtonItem *customSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    customSpace.width = 12.0f;
    
    return customSpace;

    //return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (UIBarButtonItem *)flexSpacerItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}




+(UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image andTitle:(NSString*)title target:(id)target action:(SEL)selector
{
    UIButton *someButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [someButton setImage:image forState:UIControlStateNormal];
    CGSize size = image.size;
    CGFloat imageheight = image.size.height;
    CGRect frame = CGRectZero;
    frame.size.width = size.width;
    frame.size.height = imageheight+12;
    someButton.frame = frame;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageheight+2, someButton.frame.size.width, 10)];
    
    label.textColor = [UIColor lightGrayColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:9];
    
    label.text = title;
    
    [someButton addSubview:label];
    
    [someButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    return barButton;
}

@end
