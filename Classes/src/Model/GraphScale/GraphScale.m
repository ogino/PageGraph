//
//  GraphScale.m
//  AED
//
//  Created by 荻野 雅 on 11/02/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphScale.h"


@implementation GraphScale

@synthesize maxXAxis = maxXAxis_;
@synthesize maxYAxis = maxYAxis_;
@synthesize minXAxis = minXAxis_;
@synthesize minYAxis = minYAxis_;

- (id)initWithScale:(CGFloat)minXAxis minYAxis:(CGFloat)minYAxis maxXAxis:(CGFloat)maxXAxis maxYAxis:(CGFloat)maxYAxis {
	if (self = [super init]) {
		self.minXAxis = minXAxis;
		self.minYAxis = minYAxis;
		self.maxXAxis = maxXAxis;
		self.maxYAxis = maxYAxis;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}


@end
