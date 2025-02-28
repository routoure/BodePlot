/* 
   Project: filtrage

   Author: routoure,,,

   Created: 2025-02-24 17:14:32 +0100 by routoure
   
   Application Controller
*/

#import "AppController.h"
#import "model.h"


@implementation AppController

+ (void) initialize
{
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

  /*
   * Register your app's defaults here by adding objects to the
   * dictionary, eg
   *
   * [defaults setObject:anObject forKey:keyForThatObject];
   *
   */
  
  [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  
}

- (id) init
{
  if ((self = [super init]))
    {
      monFiltre=[ModelFiltre alloc];
      
     
      
    }
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

- (void) awakeFromNib
{
// initialisation des popup


 [orderButton removeAllItems];
 [orderButton  addItemWithTitle:@"Ordre1"];
 [orderButton  addItemWithTitle:@"Ordre2"];
 [orderButton selectItemWithTitle:@"Ordre1"];

 [typeButton removeAllItems];
 
 [typeButton  addItemWithTitle:@"Passe-bas G0/(1+jw/w0)"];
 [typeButton  addItemWithTitle:@"Passe-haut G0xjw/w0/(1+jw/w0)"];
 [typeButton  addItemWithTitle:@"Dérivateur jw/w0"];
 [typeButton  addItemWithTitle:@"Intégrateur w0/jw"];
 [typeButton  addItemWithTitle:@"Amplificateur/attenuateur G0"];
 [typeButton  addItemWithTitle:@"Amplificateur/attenuateur inverseur -G0"];
 [typeButton  addItemWithTitle:@"Exercice 7.4"];
 [typeButton selectItemWithTitle:@"Passe-bas G0/(1+jw/w0)"];
   
 
 // Initilisation des slider
 [qualityFactorSlider setIntValue:30]; 
 [qualityFactorValue setFloatValue:1.0];
 [frequencyValue setFloatValue: 100.0];
 [frequencySlider setIntValue:20];
 [gainSlider setIntValue:30]; 
 [gainValue setFloatValue:1.0];
 // Il manque le gain
  
 [monFiltre setType:0];
 [monFiltre setOrder:1];
 [monFiltre setGain:1];
 [monFiltre setf0:100];
 [monFiltre setQ:1.0];
   
 [monFiltre calculBode];
 [minGain setFloatValue:[monFiltre getMinGain]];
 [maxGain setFloatValue:[monFiltre getMaxGain]]; 
 [minPhase setFloatValue:[monFiltre getMinPhase]];
 [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
 
 [theView setData:monFiltre];
 
 
 
 
 [theView setNeedsDisplay:YES];
 //[thePhaseView    setNeedsDisplay:YES]; 
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotif
{
// Uncomment if your application is Renaissance-based
//  [NSBundle loadGSMarkupNamed: @"Main" owner: self];




 
}

- (BOOL) applicationShouldTerminate: (id)sender
{
  return YES;
}

- (void) applicationWillTerminate: (NSNotification *)aNotif
{
}

- (BOOL) application: (NSApplication *)application
	    openFile: (NSString *)fileName
{
  return NO;
}

- (void) showPrefPanel: (id)sender
{
}


-(IBAction) typeButtonChanged:(id) sender {
  NSLog(@"%d",[sender indexOfSelectedItem]);
  [monFiltre setType:[sender indexOfSelectedItem]];
  [monFiltre calculBode];
  if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }

  [theView setNeedsDisplay:YES];

  
}
-(IBAction) orderButtonChanged:(id) sender{
  [monFiltre setOrder:[sender indexOfSelectedItem]+1];
  [monFiltre setType:0];
  
  [typeButton removeAllItems];
  if ([sender indexOfSelectedItem]==0) {
 [typeButton  addItemWithTitle:@"Passe-bas G0/(1+jw/w0)"];
 [typeButton  addItemWithTitle:@"Passe-haut G0xjw/w0/(1+jw/w0)"];
 [typeButton  addItemWithTitle:@"Dérivateur jw/w0"];
 [typeButton  addItemWithTitle:@"Intégrateur w0/jw"];
 [typeButton  addItemWithTitle:@"Amplificateur/attenuateur G0"];
 [typeButton  addItemWithTitle:@"Amplificateur/attenuateur inverseur -G0"];
 [typeButton  addItemWithTitle:@"Exercice 7.4"];
 [typeButton selectItemWithTitle:@"Passe-bas G0/(1+jw/w0)"];
   
 }
  if ([sender indexOfSelectedItem]==1) {
   [typeButton  addItemWithTitle:@"Passe-bas"];
   [typeButton  addItemWithTitle:@"Passe-haut"];
   [typeButton  addItemWithTitle:@"Passe-Bande"];
   [typeButton  addItemWithTitle:@"Coupe-Bande"];
   [typeButton selectItemWithTitle:@"Passe-bas"];
 }
 
  [monFiltre calculBode];
  [theView setNeedsDisplay:YES];
  if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
 
}

-(IBAction) frequencyChanged:(id) sender{
  int index=[sender intValue];
  float frequenceCoupure=1*pow(10,index/10.0);
 [frequencyValue setFloatValue:frequenceCoupure];
 [monFiltre setf0:frequenceCoupure];
  
  [monFiltre calculBode];
  [theView setNeedsDisplay:YES];
  if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
}
  
-(IBAction) qualityFactorChanged:(id) sender {
  int index=[sender intValue];
  float qualityFactor=0.01*pow(10,index/10.0);
  [qualityFactorValue setFloatValue:qualityFactor];
  [monFiltre setQ:qualityFactor];
  [monFiltre calculBode];
  [theView setNeedsDisplay:YES];
  if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
}

-(IBAction) gainChanged:(id) sender {
  int index=[sender intValue];
  float gain=0.01*pow(10,index/10.0);
  [gainValue setFloatValue:gain];
  [monFiltre setGain:gain];
  [monFiltre calculBode];
  [theView setNeedsDisplay:YES];
  if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
}
  
-(IBAction) fixedScaleChanged:(id)sender {
 
  if ([sender state]==1) [monFiltre setFixedScale];
    else  [monFiltre setAutoScale];
   //[monFiltre calculBode];
   //[theView setNeedsDisplay:YES];
   //[thePhaseView    setNeedsDisplay:YES];
  [monFiltre calculBode];
  [theView setNeedsDisplay:YES];
  if ([ monFiltre getFixedScale]==NO) {
   [minGain setFloatValue:[monFiltre getMinGain]];
   [maxGain setFloatValue:[monFiltre getMaxGain]]; 
   [minPhase setFloatValue:[monFiltre getMinPhase]];
   [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
 }

-(IBAction) magdbChanged:(id) sender{
  if ([sender state]==1) [monFiltre setDB];
    else [monFiltre setMag];
   [monFiltre calculBode];
   [theView setNeedsDisplay:YES];
   if ([ monFiltre getFixedScale]==NO) {
   [minGain setFloatValue:[monFiltre getMinGain]];
   [maxGain setFloatValue:[monFiltre getMaxGain]]; 
   [minPhase setFloatValue:[monFiltre getMinPhase]];
   [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
   //[thePhaseView    setNeedsDisplay:YES];
}


-(IBAction) logScaleChanged:(id) sender{
   if ([sender state]==1) [monFiltre setLogFrequencyScale];
    else [monFiltre setLinFrequencyScale];
   [monFiltre calculBode];
   [theView setNeedsDisplay:YES];
   if ([ monFiltre getFixedScale]==NO) {
  [minGain setFloatValue:[monFiltre getMinGain]];
  [maxGain setFloatValue:[monFiltre getMaxGain]]; 
  [minPhase setFloatValue:[monFiltre getMinPhase]];
  [maxPhase setFloatValue:[monFiltre getMaxPhase]]; 
  }
   //[thePhaseView    setNeedsDisplay:YES];
}


-(IBAction) showValueClicked:(id) sender {
NSLog(@"Ouverture du panel");
if (!monDataViewController) 
    monDataViewController=[[NSWindowController alloc]init];
[monDataViewController showWidow:sender];

}
@end
