/* 
   Project: filtrage

   Author: routoure,,,

   Created: 2025-02-24 17:14:32 +0100 by routoure
   
   Application Controller
*/
 
#ifndef _PCAPPPROJ_APPCONTROLLER_H
#define _PCAPPPROJ_APPCONTROLLER_H

#import <AppKit/AppKit.h>
#import "PlotView.h"
#import "DataViewController.h"

// Uncomment if your application is Renaissance-based
//#import <Renaissance/Renaissance.h>

@interface AppController : NSObject
{
IBOutlet NSSlider *frequencySlider;
IBOutlet NSSlider *gainSlider;
IBOutlet NSSlider *qualityFactorSlider;
IBOutlet NSTextField *frequencyValue;
IBOutlet NSTextField *qualityFactorValue;
IBOutlet NSTextField *gainValue;
IBOutlet NSPopUpButton *orderButton;
IBOutlet NSPopUpButton *typeButton;
IBOutlet PlotView *theView;
IBOutlet NSTextField *minGain;
IBOutlet NSTextField *maxGain;
IBOutlet NSTextField *minPhase;
IBOutlet NSTextField *maxPhase;
ModelFiltre *monFiltre;
DataViewController *monDataViewController;

}


-(IBAction) typeButtonChanged:(id) sender;
-(IBAction) orderButtonChanged:(id) sender;
-(IBAction) frequencyChanged:(id) sender;
-(IBAction) magdbChanged:(id) sender;
-(IBAction) qualityFactorChanged:(id) sender; 
-(IBAction) gainChanged:(id) sender; 
-(IBAction) logScaleChanged:(id) sender;
-(IBAction) fixedScaleChanged:(id)sender;
-(IBAction) showValueClicked:(id) sender;

+ (void)  initialize;

- (id) init;
- (void) dealloc;

- (void) awakeFromNib;

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif;
- (BOOL) applicationShouldTerminate: (id)sender;
- (void) applicationWillTerminate: (NSNotification *)aNotif;
- (BOOL) application: (NSApplication *)application
	    openFile: (NSString *)fileName;

- (void) showPrefPanel: (id)sender;

@end

#endif
