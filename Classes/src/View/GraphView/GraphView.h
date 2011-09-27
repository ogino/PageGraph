//
//  GraphView.h
//  CoreGraph
//
//  Created by 荻野 雅 on 11/02/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot-CocoaTouch.h>
#import "GraphScale.h"


@interface GraphView : UIView<CPTPlotDataSource> {
@private
	CPTXYGraph* graph_;
	NSArray* plots_;
	CGFloat minXAxis_;
	CGFloat minYAxis_;
	CGFloat maxXAxis_;
	CGFloat maxYAxis_;
}

@property (nonatomic, retain) CPTXYGraph* graph;
@property (nonatomic, retain) NSArray* plots;
@property (nonatomic, assign) CGFloat minXAxis;
@property (nonatomic, assign) CGFloat minYAxis;
@property (nonatomic, assign) CGFloat maxXAxis;
@property (nonatomic, assign) CGFloat maxYAxis;

- (id)initWithFrame:(CGRect)frame scale:(GraphScale*)scale;
- (id)initWithFrame:(CGRect)frame plots:(NSArray*)plots scale:(GraphScale*)scale;

@end
