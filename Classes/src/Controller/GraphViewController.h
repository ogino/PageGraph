//
//  GraphViewController.h
//  CoreGraph
//
//  Created by 荻野 雅 on 11/01/31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphScrollView.h"


@interface GraphViewController : UIViewController<UIScrollViewDelegate> {
@private
	GraphScrollView* graphScrollView_;
}

@property (nonatomic, retain) GraphScrollView* graphScrollView;

@end
