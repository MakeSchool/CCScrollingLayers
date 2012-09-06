//
//  FreeScrollingLayer.h
//  FreeScrolling
//
//  Copyright 2011 Tiny Tim Games.
//  Copyright 2012 MakeGamesWithUs Inc.
//  Modified by Brian Chu for makegameswith.us
//
//  Portions created by Sangwoo Im. and Jerrod Putnam
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


#import "cocos2d.h"
#import "CCGestureRecognizer.h"


@class FreeScrollingLayer;


// An enumeration to specify the permitted direction of scrolling.
typedef enum
{
    FreeScrollingLayerDirectionHorizontal,
    FreeScrollingLayerDirectionVertical,
    FreeScrollingLayerDirectionBoth,
	
} FreeScrollingLayerDirection;


// Constants for good default values for the scroll layer deceleration rate.
extern const float FreeScrollingLayerDecelerationRateNormal;		// This is the default.
extern const float FreeScrollingLayerDecelerationRateFast;




// A protocol that delegates can conform to to respond to scroll layer events.
@protocol FreeScrollingLayerDelegate <NSObject>

@optional

#pragma mark - Responding to scrolling and dragging

// Called when the scroll layer is being scrolled by the user.
- (void)scrollLayerDidScroll:(FreeScrollingLayer *)layer;

// Called when the scroll layer is about to begin scrolling by user input.
- (void)scrollLayerWillBeginDragging:(FreeScrollingLayer *)layer;

// Called when the scroll layer has been released by the user, but before a calculation has been made for whether or not the layer will need to decelerate.
// TODO: - (void)scrollLayerWillEndDragging:(CCScrollingLayer *)layer withVelocity:(float)velocity targetContentOffset:(CGPoint)offset;

// Called when the scroll layer has been released by the user.
- (void)scrollLayerDidEndDragging:(FreeScrollingLayer *)layer willDecelerate:(BOOL)decelerate;

// Called when the scroll layer begins decelerating after user input.
- (void)scrollLayerWillBeginDecelerating:(FreeScrollingLayer *)layer;

// Called when the scroll layer has ended decelerating after user input.
- (void)scrollLayerDidEndDecelerating:(FreeScrollingLayer *)layer;

// Called to query whether or not the scroll layer should scroll to the top, generally after the user has touched the top of the screen.
// TODO: - (BOOL)scrollLayerShouldScrollToTop:(CCScrollingLayer *)layer;

// Called when the scroll layer scrolls to the top, generally after the user has touched the top of the screen.
// TODO: - (void)scrollLayerDidScrollToTop:(CCScrollingLayer *)layer;


#pragma mark - Managing zooming

// Called when the scroll layer is about to begin zooming by user input.
- (void)scrollLayerWillBeginZooming:(FreeScrollingLayer *)layer;

// Called when the scroll layer has been released by the user.
- (void)scrollLayerDidEndZooming:(FreeScrollingLayer *)layer atScale:(float)scale;

// Called when the scroll layer is being zoomed by the user.
- (void)scrollLayerDidZoom:(FreeScrollingLayer *)layer;


#pragma mark - Responding to scrolling animations

// Called when setContentOffset:animated: with YES passed to the animated parameter has finished.
- (void)scrollLayerDidEndScrollingAnimation:(FreeScrollingLayer *)layer;


@end


#pragma mark -


// The main scroll layer interface.
@interface FreeScrollingLayer : CCLayer

#pragma mark - Creating a scroll layer

// Returns a new scroll layer object.
+ (id)scrollLayerWithViewSize:(CGSize)size;

// Initializes a previously allocated scroll layer object.
- (id)initWithViewSize:(CGSize)size;


#pragma mark - Managing the display of content

// Set the content offset.
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;

// The offset of the content, which provides the scrolling effect of the layer. Note that left-bottom point is the origin.
@property (nonatomic, assign) CGPoint contentOffset;

// Determines the size of the visible area. Use contentSize to set the actual size of the content that will be scrolled.
@property (nonatomic, assign) CGSize viewSize;

// TODO: @property (nonatomic, assign) UIEdgeInset contentInset;

// Determines if children are clipped to the viewable region of this scroll layer. YES by default.
@property (nonatomic, assign) BOOL clipToBounds;


#pragma mark - Managing scrolling

// Determines whether or not scrolling is enabled. If NO, all touch events are ignored.
@property (nonatomic, assign) BOOL scrollEnabled;

// TODO: @property (nonatomic, assign) BOOL directionalLockEnabled
// TODO: @property (nonatomic, assign) BOOL scrollsToTop

// Scrolls the layer so that the rectangle specified is visible (if possible).
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)aniamted;

// TODO: @property (nonatomic, assign) BOOL pagingEnabled

// Determines whether the scroll layer bounces when it reaches the edge of its content.
@property (nonatomic, assign) BOOL bounces;

// Determines whether bouncing always occurs when horizontal scrolling reaches the end of the content, even if the horizontal size of the content is smaller than the view.
@property (nonatomic, assign) BOOL alwaysBounceHorizontal;

// Determines whether bouncing always occurs when vertical scrolling reaches the end of the content, even if the vertical size of the content is smaller than the view.
@property (nonatomic, assign) BOOL alwaysBounceVertical;

// The rate of scroll deceleration after the user lifts their finger. CCScrollingLayerDecelerationRateNormal is the default.
@property (nonatomic, assign) float decelerationRate;

// If YES, the view is being panned.
@property (nonatomic, readonly) BOOL dragging;

//If YES, view has been double tapped.
@property (nonatomic, readonly) BOOL doubleTapped;

// If YES, the scroll layer is decelerating after scrolling.
@property (nonatomic, assign, readonly) BOOL decelerating;

// The direction the scroll layer is allowed to scroll. CCScrollViewDirectionBoth by default.
@property (nonatomic, assign) FreeScrollingLayerDirection direction;


#pragma mark - Managing the scroll indicator

// TODO: All of this.


#pragma mark - Zooming and panning

// The pan gesture recognizer for this scroll view.
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

// The tap gesture recognizer for this scroll view.
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

// The pinch gesture recognizer for this scroll view.
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinchGestureRecognizer;



// TODO: - (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

//Pinch zooming enabled
@property (nonatomic) bool pinchZoomEnabled;

// The zoom scale of the content.
@property (nonatomic, assign) float zoomScale;

// Set the zoom scale of the content
- (void)setZoomScale:(float)zoom animated:(BOOL)animated;

// Determines the maximum zoom factor of the scroll view. If minimumZoom and maximumZoom are equal, then zooming will be disabled.
@property (nonatomic, assign) float maximumZoom;

// Determines the minimum zoom factor of the scroll view. If minimumZoom and maximumZoom are equal, then zooming will be disabled.
@property (nonatomic, assign) float minimumZoom;

// If YES, the view is bouncing after being zoomed.
@property (nonatomic, assign, readonly) BOOL zoomBouncing;

// If YES, the view is being zoomed.
@property (nonatomic, readonly) BOOL zooming;

// Determines whether the scroll layer bounces during zooming when it reaches its minimum or maximum bounds.
@property (nonatomic, assign) BOOL bouncesZoom;

//How much (in absolute terms) to zoom in with each double tap; default is 0.4
@property (nonatomic) float doubleTapZoomDistance;
@property (nonatomic) bool doubleTapEnabled;

#pragma mark - Managing the delegate

// The delegate of the scroll layer object.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id<FreeScrollingLayerDelegate> delegate;
#else
@property (nonatomic, assign) id<FreeScrollingLayerDelegate> delegate;
#endif


@end
