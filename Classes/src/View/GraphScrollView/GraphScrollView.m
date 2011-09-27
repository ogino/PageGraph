//
//  GraphScrollView.m
//  PageGraph
//
//  Created by 荻野 雅 on 11/02/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphScrollView.h"
#import "GraphView.h"
#import "GraphScale.h"


@interface GraphScrollView (PrivateDelegateHandling)
- (void)createBackGroundViews:(CGRect)frame;
- (UIScrollView*)createScrollView:(CGRect)frame;
- (NSArray*)createPlots:(NSInteger)minX maxX:(NSInteger)maxX;
- (void)createChildViews:(CGRect)frame;
- (CGRect)createChildFrame:(CGRect)frame;
- (void)createScollViews:(CGRect)frame;
- (void)graphAtIndex:(NSInteger)index toScrollView:(UIScrollView*)scrollView;
- (void)showPreviousGraph;
- (void)showNextGraph;
@end


@implementation GraphScrollView

@synthesize backGroundView = backGroundView_;
@synthesize currentView = currentView_;
@synthesize nextView = nextView_;
@synthesize previousView = previousView_;
@synthesize currentIndex = currentIndex_;


#pragma mark -
#pragma mark Private Methods

- (void)createBackGroundView:(CGRect)frame {
	self.backGroundView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
	self.backGroundView.pagingEnabled = YES;
	self.backGroundView.showsHorizontalScrollIndicator = NO;
	self.backGroundView.showsVerticalScrollIndicator = NO;
	self.backGroundView.scrollsToTop = NO;
	self.backGroundView.delegate = self;
}

- (UIScrollView*)createScrollView:(CGRect)frame {
	UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
	UIViewAutoresizingFlexibleBottomMargin;
	scrollView.pagingEnabled = YES;
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	return scrollView;
}

#define degreeToRadian(x) (M_PI * (x) / 180.0)

- (NSArray*)createPlots:(NSInteger)minX maxX:(NSInteger)maxX {
	NSMutableArray *contents = [NSMutableArray arrayWithCapacity:(maxX - minX)];
	for (NSInteger i = minX; i < maxX; i++) {
		id x = [NSNumber numberWithDouble:i];
		id y = [NSNumber numberWithDouble:sin(degreeToRadian(i % 360))];
		[contents addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	return contents;
}

- (void)createChildViews:(CGRect)frame {
	self.previousView = [self createScrollView:frame];
	frame.origin.x += frame.size.width;
	self.currentView = [self createScrollView:frame];
	frame.origin.x += frame.size.width;
	self.nextView = [self createScrollView:frame];
}

- (CGRect)createChildFrame:(CGRect)frame {
	CGRect viewFrame = CGRectZero;
	viewFrame.size = frame.size;
	viewFrame.origin.x -= frame.size.width;
	return viewFrame;
}

- (void)createScollViews:(CGRect)frame {
	CGRect rect = [self createChildFrame:frame];
	[self createChildViews:rect];
	[self createBackGroundView:frame];
	[self graphAtIndex:self.currentIndex - 1 toScrollView:self.previousView];
	[self graphAtIndex:self.currentIndex toScrollView:self.currentView];
	[self graphAtIndex:self.currentIndex + 1 toScrollView:self.nextView];
	[self.backGroundView addSubview:self.previousView];
	[self.backGroundView addSubview:self.currentView];
	[self.backGroundView addSubview:self.nextView];
	[self adjustViews];
	[self scrollToIndex:self.currentIndex animated:NO];
}

#define EACH_XLENGTH 360
#define MAX_PAGES 100

- (void)graphAtIndex:(NSInteger)index toScrollView:(UIScrollView*)scrollView {
	if (scrollView && scrollView.subviews && scrollView.subviews.count > 0) {
		UIView* subView = (UIView*)[scrollView.subviews objectAtIndex:0];
		if (subView) {
			[subView removeFromSuperview];
			subView = nil;
		}
	}
	if (index < 0 || index > MAX_PAGES - 1) {
		scrollView.delegate = nil;
		return;
	}
	NSInteger xMin = EACH_XLENGTH * index;
	NSInteger xMax = xMin + EACH_XLENGTH;
	GraphScale* scale = [[[GraphScale alloc] initWithScale:xMin minYAxis:-1 maxXAxis:xMax maxYAxis:1] autorelease];
	GraphView* graphView = [[[GraphView alloc] initWithFrame:CGRectZero plots:[self createPlots:xMin maxX:xMax] scale:scale] autorelease];
	if (scrollView)
        graphView.frame = scrollView.bounds;
	[scrollView addSubview:graphView];
}

- (void)showPreviousGraph {
	UIScrollView* tmpView = self.currentView;
	
	self.currentView = self.previousView;
	self.previousView = self.nextView;
	self.nextView = tmpView;
	
	CGRect frame = self.currentView.frame;
	frame.origin.x -= frame.size.width;
	self.previousView.frame = frame;
	[self graphAtIndex:self.currentIndex - 1 toScrollView:self.previousView];
}

- (void)showNextGraph {
	UIScrollView* tmpView = self.currentView;
	
	self.currentView = self.nextView;
	self.nextView = self.previousView;
	self.previousView = tmpView;
	
	CGRect frame = self.currentView.frame;
	frame.origin.x += frame.size.width;
	self.nextView.frame = frame;
	[self graphAtIndex:self.currentIndex + 1 toScrollView:self.nextView];
}


#pragma mark -
#pragma mark Public Methods

- (void)adjustViews {
	CGSize contentSize = CGSizeMake(self.currentView.frame.size.width * MAX_PAGES, self.currentView.frame.size.height);
	self.backGroundView.contentSize = contentSize;
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
	CGPoint contentOffset = CGPointMake(index * self.backGroundView.frame.size.width, 0);
	[self.backGroundView setContentOffset:contentOffset animated:animated];	
}


#pragma mark -
#pragma mark Inherit Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self createScollViews:aDecoder.accessibilityFrame];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {    
    if (self = [super initWithFrame:frame]) {
        // Initialization code.
		[self createScollViews:frame];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.backGroundView = nil;
	self.currentView = nil;
	self.nextView = nil;
	self.previousView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat position = scrollView.contentOffset.x / scrollView.bounds.size.width;
	CGFloat delta = position - (CGFloat)self.currentIndex;
	
	if (fabs(delta) >= 1.0f) {	
		if (delta > 0) {
			// the current page moved to right
			++self.currentIndex; // no check (no over case)
			[self showNextGraph];
			
		} else {
			// the current page moved to left
			--self.currentIndex; // no check (no over case)
			[self showPreviousGraph];
		}
		
	}
	
}


@end
