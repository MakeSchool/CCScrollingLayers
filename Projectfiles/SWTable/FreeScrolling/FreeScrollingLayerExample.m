//
//  CCKitScrollTest.m
//  ScrollingList
//
//  Created by BrianC on 8/29/12.
//
//

#import "FreeScrollingLayerExample.h"

@implementation FreeScrollingLayerExample

/*
 Notes:
 It is advisable to subclass the FreeScrollingLayer class, 
 instead of instantiating it alone (for example, having a "Battlefield" class inherit it).
 The FreeScrollingLayer class makes use of ccTouchBegan and the pinch, pan, and double tap gestures.
 A FreeScrollingLayerDelegate protocol is also defined  
 */

-(id) init
{
	self = [super init];
    CGSize screenSize = [CCDirector sharedDirector].screenSize;
    
    //viewing window size = how much of the layer is visible at any one moment
    FreeScrollingLayer *layer = [FreeScrollingLayer scrollLayerWithViewSize:screenSize];
    
     //sets container size - how large is the layer, both on-screen and off-screen
    [layer setContentSize:CGSizeMake(2000, 2000)];

    //sets the position of the viewing window (position of the visible portion)
    [layer setContentOffset:ccp(0, 0)]; //default = (0,0)
    
    //sets whether the parts of the layer outside the viewing window are invisible or visible
    //(either way touches are only registered on the viewing window
    layer.clipToBounds=true; //default = true
    
    layer.scrollEnabled=true; //default = true
    layer.pinchZoomEnabled=true; //default = true
    layer.doubleTapEnabled=true; //default = true
    
    //sets zooming "bounce" - able to zoom slightly past maxZoom, but then it snaps back
    layer.bouncesZoom=false; //default = false
    
    //sets the min/max level of zoom
    layer.minimumZoom=0.5f; //default = 1
    layer.maximumZoom=2.0f; //default = 1
    
    //sets the amount of zoom for each double tap
    layer.doubleTapZoomDistance = 0.4f; //default = 0.4f
    
    //set the directions in which you can scroll:
    [layer setDirection:FreeScrollingLayerDirectionBoth];

    CCSprite* testSprite = [CCSprite spriteWithFile:@"block.png"];
    testSprite.position = ccp(0,0);
    testSprite.anchorPoint=ccp(0,0);
    [layer addChild:testSprite];
    
    for (int i=0; i<10; i++)
    {
        CCSprite* testSprite = [CCSprite spriteWithFile:@"block.png"];
        testSprite.position = ccp(100*i, screenSize.height/2.0);
        [layer addChild:testSprite];
    }
    
    testSprite = [CCSprite spriteWithFile:@"block.png"];
    testSprite.position = ccp(500,500);
    testSprite.anchorPoint=ccp(0,0);
    [layer addChild:testSprite];
    
    [self addChild:layer];
    
	return self;
}

@end
