//
//  Tile.m
//  Tiles
//

#import "Tile.h"
#import "NSString+Additions.h"
#import <QuartzCore/QuartzCore.h>


@interface Tile ()
- (void)setGlossGradientProperties;
@end


@implementation Tile

@synthesize tileIndex;


- (id)init {
    self = [super init];
    if (self) {
        [self setGlossGradientProperties];
    }
    return self;
}


- (void)setGlossGradientProperties {
    static CGFloat colorComponents0[] = { 1.0, 1.0, 1.0, 0.35 };
    static CGFloat colorComponents1[] = { 1.0, 1.0, 1.0, 0.06 };
      
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color0 = CGColorCreate(colorSpace, colorComponents0);
    CGColorRef color1 = CGColorCreate(colorSpace, colorComponents1);
    NSArray *colors = [NSArray arrayWithObjects:(id)color0,
                                                (id)color1,
                                                nil];
    CGColorRelease(color0);
    CGColorRelease(color1);
    CGColorSpaceRelease(colorSpace); 
    
    self.colors = colors;
    self.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                               [NSNumber numberWithFloat:1.0],
                                               nil];
    self.startPoint = CGPointMake(0.5f, 0.0f);
    self.endPoint = CGPointMake(0.5f, 0.5f);
}


- (void)draw {
    NSString *labelText = [NSString stringWithFormat:@"%d", (int)tileIndex];

    UIFont *font = [UIFont boldSystemFontOfSize:36];
    [[UIColor whiteColor] set];    
    [labelText drawCenteredInRect:self.bounds withFont:font];
}


- (void)appearDraggable {
    self.opacity = 0.6;
    [self setValue:[NSNumber numberWithFloat:1.25] forKeyPath:@"transform.scale"];
}


- (void)appearNormal {
    self.opacity = 1.0;
    [self setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"transform.scale"];
}


- (void)startWiggling {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05],
                                            [NSNumber numberWithFloat:0.05],
                                            nil];
    anim.duration = 0.09f + ((tileIndex % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    [self addAnimation:anim forKey:@"wiggleRotation"];
    
    anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1],
                   [NSNumber numberWithFloat:1],
                   nil];
    anim.duration = 0.07f + ((tileIndex % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.additive = YES;
    [self addAnimation:anim forKey:@"wiggleTranslationY"];
}


- (void)stopWiggling {
    [self removeAnimationForKey:@"wiggleRotation"];
    [self removeAnimationForKey:@"wiggleTranslationY"];
}


@end
