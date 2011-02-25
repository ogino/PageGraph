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
- (UIScrollView*)createScrollView:(CGRect)frame graphView:(GraphView*)graphView;
- (void)createBackGroundViews:(CGRect)frame;
- (CGRect)createChildFrame:(CGRect)frame;
- (void)createScollViews:(CGRect)frame;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)graphAtIndex:(NSInteger)index toScrollView:(UIScrollView*)scrollView;
- (void)showPreviousGraph;
- (void)showNextGraph;
@end


@implementation GraphScrollView

@synthesize graphViews = graphViews_;
@synthesize backGroundView = backGroundView_;
@synthesize currentView = currentView_;
@synthesize nextView = nextView_;
@synthesize previousView = previousView_;
@synthesize currentIndex = currentIndex_;


#pragma mark -
#pragma mark Private Methods

- (UIScrollView*)createScrollView:(CGRect)frame graphView:(GraphView*)graphView {
	UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
	UIViewAutoresizingFlexibleBottomMargin;
	scrollView.pagingEnabled = YES;
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	if (graphView) {
		graphView.frame = scrollView.bounds;
		[scrollView addSubview:graphView];
	}
	return scrollView;
}

- (void)createBackGroundView:(CGRect)frame {
	self.backGroundView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
	self.backGroundView.pagingEnabled = YES;
	self.backGroundView.showsHorizontalScrollIndicator = NO;
	self.backGroundView.showsVerticalScrollIndicator = NO;
	self.backGroundView.scrollsToTop = NO;
	self.backGroundView.delegate = self;
}

- (void)createChildViews:(CGRect)frame {
	self.previousView = [self createScrollView:frame graphView:nil];
	frame.origin.x += frame.size.width;
	self.currentView = [self createScrollView:frame graphView:(GraphView*)[self.graphViews objectAtIndex:0]];
	frame.origin.x += frame.size.width;
	self.nextView = [self createScrollView:frame graphView:(GraphView*)[self.graphViews objectAtIndex:1]];
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
	[self.backGroundView addSubview:self.previousView];
	[self.backGroundView addSubview:self.currentView];
	[self.backGroundView addSubview:self.nextView];
	[self adjustViews];
	[self scrollToIndex:self.currentIndex animated:NO];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
	CGPoint contentOffset = CGPointMake(index * self.backGroundView.frame.size.width, 0);
	[self.backGroundView setContentOffset:contentOffset animated:animated];	
}

- (void)graphAtIndex:(NSInteger)index toScrollView:(UIScrollView*)scrollView {
	if (scrollView && scrollView.subviews && scrollView.subviews.count > 0) {
		UIView* subView = (UIView*)[scrollView.subviews objectAtIndex:0];
		if (subView) [subView removeFromSuperview];
	}
	if (index < 0 || self.graphViews.count <= index) {
		scrollView.delegate = nil;
		return;
	}
	GraphView* graphView = (GraphView*)[self.graphViews objectAtIndex:index];
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
	CGSize contentSize = CGSizeMake(self.currentView.frame.size.width*self.graphViews.count, self.currentView.frame.size.height);
	self.backGroundView.contentSize = contentSize;
}

- (id)initWithFrame:(CGRect)frame graphViews:(NSArray*)graphViews {    
    if (self = [super initWithFrame:frame]) {
        // Initialization code.
		self.graphViews = graphViews;
		[self createScollViews:frame];
    }
    return self;
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
	self.graphViews = nil;
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
