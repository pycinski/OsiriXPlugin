//
//  bart4Controller.m
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-12-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bart4Controller.h"


@implementation bart4Controller

-(id) initWithOwner :(bart4Filter*) own AndViewerController :(ViewerController*) vc
{

    owner = own;
    viewerController = vc;
    self = [super initWithWindowNibName:@"bart4Window"];
    [[self window] makeKeyAndOrderFront: self];
    //[[self window] setLevel:NSFloatingWindowLevel];
    //NOTE: z niewiadomych przyczyn, jesli najpierw beda funkcje setStringValue, a dopiero potem makeKeyAndOrderFront, 
    //to nie wyswietlaja sie poprawnie te wartosci
    [lowerThresholdField setStringValue: @"110"];
    [upperThresholdField setStringValue: @"160"];
    
    [ [NSNotificationCenter defaultCenter]   
     addObserver: self
        selector: @selector(mouseDown:)
            name: @"mouseDown"
          object: nil];
    
    
    return self;
}


-(IBAction) executeFilter: (id)sender
{
    int lower =[lowerThresholdField intValue];
    int upper =[upperThresholdField intValue];
    int xPos = [xPosition intValue];
    int yPos = [yPosition intValue];
    int zPos = [viewerController imageIndex];
    //int zPos = [[[owner viewerControllersList] objectAtIndex:0] imageIndex];
    [owner executeFilter:lower :upper :xPos :yPos: zPos];
    //[self close];
    
}

-(IBAction) resetView:(id)sender
{
    [owner resetImage];
}

- (void) mouseDown:(NSNotification*) notification
{
                                  //czyli viewerController
    if ([notification object] == viewerController ) {
        int x = [[[notification userInfo] objectForKey:@"X"] intValue];
        int y = [[[notification userInfo] objectForKey:@"Y"] intValue];
        [xPosition setIntValue: x];
        [yPosition setIntValue: y];

    }
    [[self window] makeKeyAndOrderFront: self];
    [[self window] orderFront:nil];
        
}

@end
