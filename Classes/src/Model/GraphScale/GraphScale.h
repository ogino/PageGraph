//
//  GraphScale.h
//  AED
//
//  Created by 荻野 雅 on 11/02/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot-CocoaTouch.h>


@interface GraphScale : NSObject {
@private
	CGFloat maxXAxis_;
	CGFloat maxYAxis_;
	CGFloat minXAxis_;
	CGFloat minYAxis_;
}

@property (nonatomic, assign) CGFloat maxXAxis;
@property (nonatomic, assign) CGFloat maxYAxis;
@property (nonatomic, assign) CGFloat minXAxis;
@property (nonatomic, assign) CGFloat minYAxis;

- (id)initWithScale:(CGFloat)minXAxis minYAxis:(CGFloat)minYAxis maxXAxis:(CGFloat)maxXAxis maxYAxis:(CGFloat)maxYAxis;

@end
