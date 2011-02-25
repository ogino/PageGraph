//
//  GraphView.m
//  CoreGraph
//
//  Created by 荻野 雅 on 11/02/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"


@interface GraphView (PrivateDelegateHandling)
- (void)initPadding;
- (void)createGraph;
- (void)createDrawArea:(BOOL)allowsUserInteraction;
- (CPTextStyle*)createTextStyle:(NSString*)fontName color:(CPColor*)color;
- (CPTextStyle*)createTextStyle:(NSString*)fontName color:(CPColor*)color size:(CGFloat)size;
- (NSNumberFormatter*)createXFormatter;
- (void)createXAxis:(CPXYAxisSet*)axisSet;
- (NSNumberFormatter*)createYFormatter;
- (void)createYAxis:(CPXYAxisSet*)axisSet;
- (void)createAxis;
- (CPScatterPlot*)createScorePlot;
- (CPFill*)createAreaFill;
- (CPPlotSymbol*)createPlotSymbol;
- (CABasicAnimation*)createBlinkAnimation;
- (void)createPlots;
- (void)createGraphView;
@end

@implementation GraphView

@synthesize graph = graph_;
@synthesize plots = plots_;
@synthesize minXAxis = minXAxis_;
@synthesize minYAxis = minYAxis_;
@synthesize maxXAxis = maxXAxis_;
@synthesize maxYAxis = maxYAxis_;


#pragma mark -
#pragma mark Private Methods

#define NO_PADDING 0.0

#define MIN_XAXIS self.minXAxis
#define MAX_XAXIS self.maxXAxis
#define XAXIS_LENGTH (MAX_XAXIS - MIN_XAXIS)
#define XAXIS_PADDING (XAXIS_LENGTH / 20)
#define XAXIS_DISP_LENGTH (XAXIS_LENGTH + 2*XAXIS_PADDING)

#define MIN_YAXIS self.minYAxis
#define MAX_YAXIS self.maxYAxis
#define YAXIS_LENGTH (MAX_YAXIS - MIN_YAXIS)
#define YAXIS_PADDING (YAXIS_LENGTH / 20)
#define YAXIS_DISP_LENGTH (YAXIS_LENGTH + 2*YAXIS_PADDING)

- (void)initPadding {
	self.graph.paddingLeft = NO_PADDING;
	self.graph.paddingTop = NO_PADDING;
	self.graph.paddingRight = NO_PADDING;
	self.graph.paddingBottom = NO_PADDING;
}

- (void)createGraph {
	self.graph = [[[CPXYGraph alloc] initWithFrame:CGRectZero] autorelease];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
	[self.graph applyTheme:theme];
	[self initPadding];
}

- (void)createDrawArea:(BOOL)allowsUserInteraction {
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)self.graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = allowsUserInteraction;
	// Set Display Range.
	plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(MIN_XAXIS - XAXIS_PADDING) length:CPDecimalFromFloat(XAXIS_DISP_LENGTH)];
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(MIN_YAXIS - YAXIS_PADDING) length:CPDecimalFromFloat(YAXIS_DISP_LENGTH)];
}

- (CPTextStyle*)createTextStyle:(NSString*)fontName color:(CPColor*)color {
	CPTextStyle *textStyleX = [[[CPTextStyle alloc] init] autorelease];
	[textStyleX setFontName:fontName];
	[textStyleX setColor:color];
	return textStyleX;
}

- (CPTextStyle*)createTextStyle:(NSString*)fontName color:(CPColor*)color size:(CGFloat)size {
	CPTextStyle *textStyleX = [self createTextStyle:fontName color:color];
	[textStyleX setFontSize:size];
	return textStyleX;
}

#define ZERO_DEGIT 0

- (NSNumberFormatter*)createXFormatter {
	NSNumberFormatter* xFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[xFormatter setMaximumFractionDigits:ZERO_DEGIT];
	return xFormatter;
}

#define XAXIS_INTERVAL @"30"
#define XAXIS_ORTHOGONAL @"0.0"

- (void)createXAxis:(CPXYAxisSet*)axisSet {
	CPXYAxis *xAxis = axisSet.xAxis;
	xAxis.majorIntervalLength = CPDecimalFromString(XAXIS_INTERVAL);
	xAxis.orthogonalCoordinateDecimal = CPDecimalFromString(XAXIS_ORTHOGONAL);
	xAxis.minorTicksPerInterval = 0.0f;

	[xAxis setTitle:@"degree(°)"];
	[xAxis setVisibleRange:[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(MIN_XAXIS) length:CPDecimalFromFloat(XAXIS_LENGTH)]];

	[xAxis setLabelTextStyle:[self createTextStyle:@"Georgia" color:[CPColor cyanColor]]];
	[xAxis setTitleTextStyle:[self createTextStyle:@"Georgia" color:[CPColor yellowColor] size:12.0f]];

	xAxis.labelFormatter = [self createXFormatter];
}

- (NSNumberFormatter*)createYFormatter {
	NSNumberFormatter *yFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[yFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[yFormatter setMaximumFractionDigits:3];
	return yFormatter;
}

#define YAXIS_INTERVAL @"0.2"
#define YAXIS_ORTHOGONAL @"0.0"

- (void)createYAxis:(CPXYAxisSet*)axisSet {
	CPXYAxis *yAxis = axisSet.yAxis;
	yAxis.majorIntervalLength = CPDecimalFromString(YAXIS_INTERVAL);
	yAxis.minorTicksPerInterval = 0;
	yAxis.orthogonalCoordinateDecimal = CPDecimalFromString(YAXIS_ORTHOGONAL);

	[yAxis setTitle:@"sin(x) value"];
	[yAxis setVisibleRange:[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(MIN_YAXIS) length:CPDecimalFromFloat(YAXIS_LENGTH)]];

	[yAxis setLabelTextStyle:[self createTextStyle:@"Georgia" color:[CPColor cyanColor]]];
	[yAxis setTitleTextStyle:[self createTextStyle:@"Georgia" color:[CPColor yellowColor] size:12.0f]];

	yAxis.labelFormatter = [self createYFormatter];

}

- (void)createAxis {
	CPXYAxisSet* axisSet = (CPXYAxisSet*)self.graph.axisSet;
	[self createXAxis:axisSet];
	[self createYAxis:axisSet];
}

- (CPScatterPlot*)createScorePlot {
	CPScatterPlot *scorePlot = [[[CPScatterPlot alloc] init] autorelease];
	scorePlot.identifier = @"Score Plot";
	scorePlot.dataLineStyle.miterLimit = 1.0f;
	scorePlot.dataLineStyle.lineWidth = 1.0f;
	scorePlot.dataLineStyle.lineColor = [CPColor blueColor];
	scorePlot.dataSource = self;
	return scorePlot;
}

- (CPFill*)createAreaFill {
	CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
	CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
	return [CPFill fillWithGradient:areaGradient];
}

- (CPPlotSymbol*)createPlotSymbol {
	CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPColor blackColor];
	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size = CGSizeMake(10.0, 10.0);
	return plotSymbol;
}

#define UNLIMITED_BLINK 1e100f

- (CABasicAnimation*)createBlinkAnimation {
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 0.5f;
	fadeInAnimation.repeatCount = UNLIMITED_BLINK;
	fadeInAnimation.autoreverses = YES;
	fadeInAnimation.removedOnCompletion = YES;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.5];
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	return fadeInAnimation;
}

#define ARRAY_CAPACITY XAXIS_LENGTH
#define degreeToRadian(x) (M_PI * (x) / 180.0)

- (void)createPlots {
	NSMutableArray *contents = [NSMutableArray arrayWithCapacity:ARRAY_CAPACITY];
	for (NSInteger i = MIN_XAXIS; i < MAX_XAXIS; i++) {
		id x = [NSNumber numberWithDouble:i];
		id y = [NSNumber numberWithDouble:sin(degreeToRadian(i % 360))];
		[contents addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.plots = contents;
}

- (void)createGraphView {
	[self createGraph];

	CPGraphHostingView *hostingView = [[[CPGraphHostingView alloc] initWithFrame:self.bounds] autorelease];
	hostingView.hostedGraph = self.graph;
	hostingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
	UIViewAutoresizingFlexibleBottomMargin;


	[self createDrawArea:NO];

	[self createAxis];

	CPScatterPlot *scorePlot = [self createScorePlot];
	[self.graph addPlot:scorePlot];

	scorePlot.areaFill = [self createAreaFill];
	scorePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
	scorePlot.plotSymbol = [self createPlotSymbol];

	[scorePlot addAnimation:[self createBlinkAnimation] forKey:@"animateOpacity"];

	[self addSubview:hostingView];
}


#pragma mark -
#pragma mark Public Methods

- (id)initWithFrame:(CGRect)frame scale:(GraphScale*)scale {
	if (self = [super initWithFrame:frame]) {
		self.minXAxis = scale.minXAxis;
		self.minYAxis = scale.minYAxis;
		self.maxXAxis = scale.maxXAxis;
		self.maxYAxis = scale.maxYAxis;
		[self createPlots];
		[self createGraphView];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
		UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
		UIViewAutoresizingFlexibleBottomMargin;	
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame plots:(NSArray*)plots scale:(GraphScale*)scale {
	if (self = [super initWithFrame:frame]) {
		self.plots = plots;
		self.minXAxis = scale.minXAxis;
		self.minYAxis = scale.minYAxis;
		self.maxXAxis = scale.maxXAxis;
		self.maxYAxis = scale.maxYAxis;
		[self createGraphView];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
		UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
		UIViewAutoresizingFlexibleBottomMargin;		
	}
	return self;
}


#pragma mark -
#pragma mark Inherit Methods

- (id)initWithFrame:(CGRect)frame {

	self = [super initWithFrame:frame];
	if (self) {
		self.minXAxis = -360;
		self.minYAxis = -1;
		self.maxXAxis = 360;
		self.maxYAxis = 1;
		[self createPlots];
		[self createGraphView];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
		UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|
		UIViewAutoresizingFlexibleBottomMargin;	
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
	self.graph = nil;
	self.plots = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark dataSource

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
	return [self.plots count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	NSNumber* number = nil;
	NSDictionary* coord = [self.plots objectAtIndex:index];
	if (coord != nil && [coord count] > 0 ) {
		switch (fieldEnum) {
			case CPScatterPlotFieldX:
				number = [coord objectForKey:@"x"];
				break;
			case CPScatterPlotFieldY:
				number = [coord objectForKey:@"y"];
				break;
		}
	}
	return number;
}

@end
