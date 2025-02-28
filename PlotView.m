/*
   Project: filtrage

   Copyright (C) 2025 Free Software Foundation

   Author: routoure,,,

   Created: 2025-02-24 17:48:29 +0100 by routoure

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "PlotView.h"
#import "model.h"

@implementation PlotView

-(id) initWithFrame:(NSRect) rect {
  if ((self=[super initWithFrame:rect])!=nil) {
   // NSLog(@"Initialisation %f %f",rect.size.width, rect.size.height);
   [self setNeedsDisplay:YES];
   
   }
  return self;
}

// -------------------------------------------------------------

- (void)drawRect:(NSRect)dirtyRect {
    //NSLog(@"On dessine");
    [super drawRect:dirtyRect];

    NSGraphicsContext *context = [NSGraphicsContext currentContext];

    // Définition du fond blanc
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    // Taille de la vue
    NSRect bounds = [self bounds];
    CGFloat width_view = bounds.size.width;
    CGFloat height_view = bounds.size.height;
    
    // ------------------------------ Dessin des axes --------------------
    CGFloat borderX=20;
    CGFloat borderY=20;
    
    CGFloat width_plot= width_view-2*borderX;
    CGFloat height_plot= height_view/2-2*borderY;
    
    CGFloat cornerX_left= borderX;
    CGFloat cornerX_right= width_view-borderX;
    
    CGFloat cornerY_low_phase=borderY;
    CGFloat cornerY_high_phase= height_plot+borderY;
    
    CGFloat cornerY_low_gain= borderY+height_view/2;
    CGFloat cornerY_high_gain= height_view-borderY;
    
    // Définition de la couleur des axes
    [[NSColor blackColor] setStroke];

    
    NSBezierPath *boitePath1 = [NSBezierPath bezierPath];
    [boitePath1 moveToPoint:NSMakePoint(cornerX_left, cornerY_low_phase)];
    [boitePath1 lineToPoint:NSMakePoint(cornerX_right, cornerY_low_phase)];
    [boitePath1 lineToPoint:NSMakePoint(cornerX_right, cornerY_high_phase)];
    [boitePath1 lineToPoint:NSMakePoint(cornerX_left, cornerY_high_phase)];
    [boitePath1 lineToPoint:NSMakePoint(cornerX_left, cornerY_low_phase)];
    [boitePath1 stroke];
    
    NSBezierPath *boitePath2 = [NSBezierPath bezierPath];
    [boitePath2 moveToPoint:NSMakePoint(cornerX_left, cornerY_low_gain)];
    [boitePath2 lineToPoint:NSMakePoint(cornerX_right, cornerY_low_gain)];
    [boitePath2 lineToPoint:NSMakePoint(cornerX_right, cornerY_high_gain)];
    [boitePath2 lineToPoint:NSMakePoint(cornerX_left, cornerY_high_gain)];
    [boitePath2 lineToPoint:NSMakePoint(cornerX_left, cornerY_low_gain)];
    [boitePath2 stroke];
    
    
    float gainPlotMin=[plotModel getPlotMinGain];
    float gainPlotMax=[plotModel getPlotMaxGain];
    float phasePlotMin=[plotModel getPlotMinPhase];
    float phasePlotMax=[plotModel getPlotMaxPhase];    
    

    // Manipulation sur les valeurs max.
    // Minimum 1 entre max et min et arrondi 
    gainPlotMin=floor(10*gainPlotMin-0.5)/10;
    gainPlotMax=floor(10*gainPlotMax+0.5)/10;
    phasePlotMin= floor(10*phasePlotMin-0.5)/10;
    phasePlotMax=floor(10*phasePlotMax+0.5)/10;
    

    // ---------------valeur sur les axes Y
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //[paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setAlignment:NSTextAlignmentRight];


    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSFont systemFontOfSize:8], NSFontAttributeName,
       [NSColor blackColor], NSForegroundColorAttributeName,
       paragraphStyle, NSParagraphStyleAttributeName,
       nil];

    //NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //   [NSFont systemFontOfSize:8], NSFontAttributeName,
    //   [NSColor blackColor], NSForegroundColorAttributeName, nil];
    
    NSString *text=[NSString stringWithFormat:@"%.1f",gainPlotMin];
    [text drawAtPoint:NSMakePoint(0,cornerY_low_gain)withAttributes:attributes];
    text=[NSString stringWithFormat:@"%.1f",gainPlotMax];
    [text drawAtPoint:NSMakePoint(0,cornerY_high_gain)withAttributes:attributes];
    text=[NSString stringWithFormat:@"%.1f",phasePlotMin];
    [text drawAtPoint:NSMakePoint(0,cornerY_low_phase)withAttributes:attributes];
    text=[NSString stringWithFormat:@"%.1f",phasePlotMax];
    [text drawAtPoint:NSMakePoint(0,cornerY_high_phase)withAttributes:attributes];    


    
    // ---- Plot of the x axis  ------
    
    NSBezierPath *axeXPath1 = [NSBezierPath bezierPath];    
    NSBezierPath *axeXPath2 = [NSBezierPath bezierPath];    
    [[NSColor grayColor] setStroke];
    float coordAxeX;
    int i;
    if ([plotModel getFrequencyScale])
      for (i=0;i<6;i++)  {
        // Une ligne par decade
        coordAxeX=cornerX_left+i * (width_plot)/5 ;
        [ axeXPath1 moveToPoint:NSMakePoint(coordAxeX, cornerY_low_gain)];
        [ axeXPath1 lineToPoint:NSMakePoint(coordAxeX, cornerY_high_gain)];
        
        [ axeXPath2 moveToPoint:NSMakePoint(coordAxeX, cornerY_low_phase)];
        [ axeXPath2 lineToPoint:NSMakePoint(coordAxeX, cornerY_high_phase)];
        text=[NSString stringWithFormat:@"%.0f",pow(10,i)];
        [text drawAtPoint:NSMakePoint(coordAxeX,cornerY_low_phase-10) withAttributes:attributes];
      }
    else 
      for (i=1;i<10;i++)  {
        // Une ligne par decade
        coordAxeX=cornerX_left+i * (width_plot)/10 ;
        [ axeXPath1 moveToPoint:NSMakePoint(coordAxeX, cornerY_low_gain)];
        [ axeXPath1 lineToPoint:NSMakePoint(coordAxeX, cornerY_high_gain)];
        
        [ axeXPath2 moveToPoint:NSMakePoint(coordAxeX, cornerY_low_phase)];
        [ axeXPath2 lineToPoint:NSMakePoint(coordAxeX, cornerY_high_phase)];
        text=[NSString stringWithFormat:@"%d",i*10000];
        [text drawAtPoint:NSMakePoint(coordAxeX,cornerY_low_phase-10)withAttributes:attributes];
      } 
    [axeXPath1 stroke];
    [axeXPath2 stroke];
   
    // ---- Plot of the y axis  ------
    // Il serait interessant d'avoir 20dB/decade...
    
    NSBezierPath *axeYPath1 = [NSBezierPath bezierPath];    
    NSBezierPath *axeYPath2 = [NSBezierPath bezierPath];    
    [[NSColor grayColor] setStroke];
    float coordAxeY;  
    for (i=1;i<10;i++)  {
        
        
        coordAxeY= cornerY_low_phase+(i/10.0)* (height_plot) ;
        [ axeYPath2 moveToPoint:NSMakePoint(cornerX_left,  coordAxeY)];
        [ axeYPath2 lineToPoint:NSMakePoint(cornerX_right,  coordAxeY)];
    }     
    [axeYPath2 stroke];
    
    for (i=1;i<10;i++)  {        
        coordAxeY= cornerY_low_gain+(i/10.0) * (height_plot) ;
        [ axeYPath1 moveToPoint:NSMakePoint(cornerX_left,  coordAxeY)];
        [ axeXPath1 lineToPoint:NSMakePoint(cornerX_right,  coordAxeY)];
        
        
    }

    [axeYPath1 stroke];

    
    
    
    // -------------------------------- dessin des données ----------
    
    [[NSColor blackColor] setStroke];
   
    
    NSBezierPath *gainPath = [NSBezierPath bezierPath];    
    NSBezierPath *phasePath = [NSBezierPath bezierPath];
    
    [gainPath setLineWidth:3];
    [phasePath setLineWidth:3];
    NSMutableArray *frequences=[plotModel getFrequences];
    NSMutableArray *gains=[plotModel getGains];
    NSMutableArray *phases=[plotModel getPhases];
    
    [[NSColor redColor] setStroke];
    
    float coordFrequency;
    float coordGain;
    float coordPhase;
    
    for (i=0;i<[frequences count];i++){
         // ------------------------coordonnées Y
         float tmp =  [[gains objectAtIndex:i] floatValue];
         coordGain =cornerY_low_gain+(tmp-gainPlotMin)* (height_plot)/ (gainPlotMax -gainPlotMin) ;
         if (coordGain-cornerY_low_gain>height_plot) coordGain=cornerY_high_gain;
         if (coordGain-cornerY_low_gain<0) coordGain=cornerY_low_gain;  
         
         tmp =  [[phases objectAtIndex:i] floatValue];
         coordPhase = cornerY_low_phase+(tmp -phasePlotMin) * (height_plot)/ ( phasePlotMax-phasePlotMin) ;
         if (coordPhase-cornerY_low_phase>height_plot) coordPhase=cornerY_high_phase;
         if (coordPhase-cornerY_low_phase<0) coordPhase=cornerY_low_phase; 
         
         /// ------   coordonnes X  
         tmp =  [[frequences objectAtIndex:i] floatValue];
          if ([plotModel getFrequencyScale]) 
          coordFrequency = cornerX_left+log10(tmp) * (width_plot)/5 ;
          else  coordFrequency = cornerX_left+tmp* (width_plot)/ ( 100000) ;
         
         
         if (i==0) {
           [gainPath moveToPoint:NSMakePoint(coordFrequency, coordGain)];
           [phasePath moveToPoint:NSMakePoint(coordFrequency, coordPhase)];
         }           
         [gainPath lineToPoint:NSMakePoint(coordFrequency, coordGain)];
         [phasePath lineToPoint:NSMakePoint(coordFrequency, coordPhase)]; 
 
    }
    
    [gainPath stroke];
    [phasePath stroke];
    

    [context flushGraphics];
}


-(void) setData:(ModelFiltre *) unModele{
  plotModel=unModele;
}


@end
