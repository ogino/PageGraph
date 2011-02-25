//
//  GraphScrollView.h
//  PageGraph
//
//  Created by 荻野 雅 on 11/02/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphScrollView : UIView<UIScrollViewDelegate> {
@private
	NSArray* graphViews_;
	UIScrollView* backGroundView_;
	UIScrollView* currentView_;
	UIScrollView* nextView_;
	UIScrollView* previousView_;
	NSInteger currentIndex_;
}

@property (nonatomic, retain) NSArray* graphViews;
@property (nonatomic, retain) UIScrollView* backGroundView;
@property (nonatomic, retain) UIScrollView* currentView;
@property (nonatomic, retain) UIScrollView* nextView;
@property (nonatomic, retain) UIScrollView* previousView;
@property (nonatomic, assign) NSInteger currentIndex;

- (id)initWithFrame:(CGRect)frame graphViews:(NSArray*)graphViews;
- (void)adjustViews;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
