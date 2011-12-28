//
//  bart4Controller.h
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-12-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "bart4Filter.h"

@interface bart4Controller : NSWindowController {
@private
    IBOutlet NSWindow    * bart4WindowObject;
    IBOutlet NSTextField * lowerThresholdField;
    IBOutlet NSTextField * upperThresholdField;
    IBOutlet NSTextField * xPosition;
    IBOutlet NSTextField * yPosition;
    bart4Filter*   owner;
    ViewerController* viewerController;
}

- (id) initWithOwner: (bart4Filter*) own 
          AndViewerController: (ViewerController* ) vc;


-(IBAction) executeFilter: (id)sender;
-(IBAction) resetView: (id) sender;
- (void) mouseDown:(NSNotification*) notification;

@end
