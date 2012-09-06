//
//  CCGestureRecognizer.m
//  CCExtensions
//
//  Created by Jerrod Putman on 7/29/11.
//  Copyright 2011 Tiny Tim Games. All rights reserved.
//
//  Portions created by Joe Allen, Glaivare LLC.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "CCGestureRecognizer.h"

#import <objc/runtime.h>


#if __has_feature(objc_arc) == 0
#warning This code was designed to run under ARC. Without it, you will experience lots of memory leaks.
#endif


@interface CCGestureRecognizer ()

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) CCNode *node;
#else
@property (nonatomic, assign) CCNode *node;
#endif

@end


#pragma mark -


@implementation CCGestureRecognizer
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
	__weak id<UIGestureRecognizerDelegate> delegate;
	__weak id target;
#else
	__unsafe_unretained id<UIGestureRecognizerDelegate> delegate;
	__unsafe_unretained id target;
#endif
	
	SEL callback;
}

@synthesize gestureRecognizer;
@synthesize node;


#pragma mark - Private

- (void)callback:(UIGestureRecognizer*)recognizer
{
	if(target)
		[target performSelector:callback withObject:recognizer withObject:node];
}


#pragma mark - Creating the gesture recognizer

+ (id)recognizerWithRecognizer:(UIGestureRecognizer*)recognizer target:(id)target action:(SEL)action;
{
	return [[self alloc] initWithRecognizer:recognizer target:target action:action];
}


- (id)initWithRecognizer:(UIGestureRecognizer*)recognizer target:(id)tar action:(SEL)action;
{
	if((self = [super init]))
	{
		NSAssert(recognizer != nil, @"Parameter recognizer cannot be nil!");
		  
		gestureRecognizer = recognizer;
		[gestureRecognizer addTarget:self action:@selector(callback:)];

		delegate = gestureRecognizer.delegate;
		gestureRecognizer.delegate = self;

		target = tar;
		callback = action;
	}
	
	return self;
}


#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
	NSAssert(node != nil, @"Gesture recognizer must have a node.");

	CGPoint pt = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	BOOL rslt = [node isPointInArea:pt];

	if( rslt )
	{
		CCNode* n = node;
		CCNode* parent = node.parent;
		while( n != nil && parent != nil && rslt)
		{
			BOOL nodeFound = NO;
			CCNode *child;
			CCARRAY_FOREACH(parent.children, child)
			{
				if( !nodeFound )
				{
					if( !nodeFound && n == child )
						nodeFound = YES;  // we need to keep track of until we hit our node, any past it have a higher z value
					continue;
				}

				if( [child isNodeInTreeTouched:pt] )
				{
					rslt = NO;
					break;
				}
			}

			n = parent;
			parent = n.parent;
		}    
	}

	if(rslt
	   && delegate
	   && [delegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)])
		rslt = [delegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];

	return rslt;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if(delegate
	   && [delegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)])
		return [delegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
	
	return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
	if(delegate
	   && [delegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)])
		return [delegate gestureRecognizerShouldBegin:gestureRecognizer];
	
	return YES;
}


#pragma mark - Cleanup

- (void)dealloc
{
	[[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:gestureRecognizer];
}


@end


#pragma mark -


static char CCNodeGestureRecognizerAdditionsKey;


@implementation CCNode (GestureRecognizerAdditions)

- (NSArray *)gestureRecognizers
{
	NSMutableArray *gestureRecognizers = objc_getAssociatedObject(self, &CCNodeGestureRecognizerAdditionsKey);
	return [NSArray arrayWithArray:gestureRecognizers];
}


- (void)addGestureRecognizer:(CCGestureRecognizer *)gestureRecognizer
{
	gestureRecognizer.node = self;
	
	// Since we can't add ivars to categories, we'll use Objective-C's fancy pants associated object feature
	// which allows us to retain a mutable array of gesture recognizer objects to a CCNode and make sure they
	// are deallocated when the node is deallocated. Magic!
	NSMutableArray *gestureRecognizers = objc_getAssociatedObject(self, &CCNodeGestureRecognizerAdditionsKey);
	if(gestureRecognizers == nil)
	{
		gestureRecognizers = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, &CCNodeGestureRecognizerAdditionsKey, gestureRecognizers, OBJC_ASSOCIATION_RETAIN);
	}
	[gestureRecognizers addObject:gestureRecognizer];
	
	[[[CCDirector sharedDirector] openGLView] addGestureRecognizer:gestureRecognizer.gestureRecognizer];
}


- (void)removeGestureRecognizer:(CCGestureRecognizer *)gestureRecognizer
{
	// Removal of the gesture recognizer from the mutable array created above.
	NSMutableArray *gestureRecognizers = objc_getAssociatedObject(self, &CCNodeGestureRecognizerAdditionsKey);
	[gestureRecognizers removeObject:gestureRecognizer];
	
	if(gestureRecognizer.node == self)
		[[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:gestureRecognizer.gestureRecognizer]; 

	gestureRecognizer.node = nil;
}


- (BOOL)isPointInArea:(CGPoint)pt
{
	if(visible_ == NO)
		return NO;
	
	pt = [self convertToNodeSpace:pt];

	CGRect rect;
	rect.size = self.contentSize;
	rect.origin = CGPointZero;

	if(CGRectContainsPoint(rect, pt))
		return YES;
	
	return NO;
}


- (BOOL)isNodeInTreeTouched:(CGPoint)pt
{
	if([self isPointInArea:pt])
		return YES;

	BOOL rslt = NO;
	CCNode *child;
	CCARRAY_FOREACH(children_, child)
	{
		if([child isNodeInTreeTouched:pt])
		{
			rslt = YES;
			break;
		}
	}
	
	return rslt;
}


@end

