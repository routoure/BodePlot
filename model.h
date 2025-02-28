/*
   Project: filtrage

   Copyright (C) 2025 Free Software Foundation

   Author: routoure,,,

   Created: 2025-02-24 21:47:00 +0100 by routoure

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

#ifndef _MODEL_H_
#define _MODEL_H_

#import <Foundation/Foundation.h>

@interface ModelFiltre : NSObject
{
  NSMutableArray *frequences;
  NSMutableArray *gains;
  NSMutableArray *phases;
  BOOL logFrequencyScale;
  BOOL magDB;
  BOOL fixedYscale;
  float gain;
  float f0;
  float Q;
  int   type;
  int   order;
  float maxGain;
  float minGain;
  float maxPhase;
  float minPhase;
  float plotMaxGain;
  float plotMinGain; 
  float plotMaxPhase; 
  float plotMinPhase; 
  
}

- (void) setLinFrequencyScale;
- (void) setLogFrequencyScale;
- (BOOL) getFrequencyScale;

- (void) setMag;
- (void) setDB;
- (BOOL) getMagDB;

- (void) setFixedScale; 
- (void) setAutoScale;  
- (BOOL) getFixedScale; 

- (void) setGain:(float) unGain;
- (void) setf0: (float) unf0;
- (void) setQ: (float) unQ;
- (void) setType: (int) unType;
- (void) setOrder: (int) unOrder;



- (void) calculBode;

- (NSMutableArray *) getFrequences;
- (NSMutableArray *) getGains;
- (NSMutableArray *) getPhases; 
-(float) getMaxGain;
-(float) getMinGain;
-(float) getMaxPhase;
-(float) getMinPhase;

- (void) setMinPlotGain:(float) minValue; 
- (void) setMaxPlotGain:(float) maxValue; 
- (void) setMinPlotPhase:(float) minValue; 
- (void) setMaxPlotPhase:(float) maxValue; 
-(float) getPlotMaxGain;  
-(float) getPlotMinGain;  
-(float) getPlotMaxPhase; 
-(float) getPlotMinPhase; 
@end

#endif // _MODEL_H_

