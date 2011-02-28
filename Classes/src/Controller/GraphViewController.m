//
//  GraphViewController.m
//  CoreGraph
//
//  Created by 荻野 雅 on 11/01/31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "GraphScale.h"


@interface GraphViewController (PrivateDelegateHandling)

@end


@implementation GraphViewController

@synthesize graphScrollView = graphScrollView_;


#pragma mark -
#pragma mark Private Methods


#pragma mark -
#pragma mark Inherit Methods

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization.
	}
	return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.graphScrollView = [[[GraphScrollView alloc] initWithFrame:self.view.bounds] autorelease];
	[self.view addSubview:self.graphScrollView.backGroundView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Overriden to allow any orientation.
	return YES;
}

#define LANDSCAPE_FRAME CGRectMake(0, 0, 1024, 768)
#define LANDSCAPE_SCROLL_FRAME CGRectMake(0, 0, 1024, 768)
#define PORTLATE_FRAME CGRectMake(0, 0, 768, 1024)
#define PORTLATE_SCROLL_FRAME CGRectMake(0, 0, 768, 1024)

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			self.graphScrollView.backGroundView.frame = PORTLATE_SCROLL_FRAME;
			self.graphScrollView.previousView.frame = PORTLATE_FRAME;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			self.graphScrollView.backGroundView.frame = LANDSCAPE_SCROLL_FRAME;
			self.graphScrollView.previousView.bounds = LANDSCAPE_FRAME;
			break;
		default:
			return;
	}
	CGRect rect = self.graphScrollView.previousView.frame;
	rect.origin.x = (self.graphScrollView.currentIndex - 1) * rect.size.width;

	rect.origin.x += rect.size.width;
	self.graphScrollView.currentView.frame = rect;
	rect.origin.x += rect.size.width;
	self.graphScrollView.nextView.frame = rect;
	[self.graphScrollView adjustViews];
	[self.graphScrollView scrollToIndex:self.graphScrollView.currentIndex animated:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.graphScrollView = nil;
	self.view = nil;
	[super dealloc];
}

@end
