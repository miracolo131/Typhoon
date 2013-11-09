////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonCollaboratingAssemblyProxy.h"
#import <objc/runtime.h>
#import "TyphoonDefinition.h"

@implementation TyphoonCollaboratingAssemblyProxy

+ (id)proxy
{
    static dispatch_once_t onceToken;
    static TyphoonCollaboratingAssemblyProxy* instance;

    dispatch_once(&onceToken, ^
    {
        instance = [[self alloc] init];
    });
    return instance;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([super resolveInstanceMethod:sel] == NO)
    {
        IMP imp = [self proxyDefinitionForSelector:sel];
        class_addMethod(self, sel, imp, "@@:");
    }
    return YES;
}

+ (IMP)proxyDefinitionForSelector:(SEL)selector
{
    return imp_implementationWithBlock((__bridge id) objc_unretainedPointer((TyphoonDefinition*) ^(id me)
    {
        NSString* key = NSStringFromSelector(selector);
        TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:[TyphoonCollaboratingAssemblyProxy class] key:key];
        return definition;
    }));
}


@end