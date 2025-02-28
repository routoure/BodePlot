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

#import "model.h"

@implementation ModelFiltre


- (void) setLinFrequencyScale {
  logFrequencyScale=NO;
}

- (void) setLogFrequencyScale {
  logFrequencyScale=YES;
}

- (BOOL) getFrequencyScale{
  return logFrequencyScale;
}


- (void) setFixedScale {
fixedYscale =YES;
} 
- (void) setAutoScale {
fixedYscale=NO;
} 
- (BOOL) getFixedScale {
return fixedYscale;
}

-(void) setMag {
  magDB=NO;
}

-(void) setDB {
  magDB=YES;
}
- (BOOL) getMagDB {
  return magDB;
}

- (void) setGain:(float) unGain {
gain=unGain;
}
- (void) setf0: (float) unf0{
  f0=unf0;
}

- (void) setQ: (float) unQ{
  Q=unQ;
}
- (void) setType: (int) unType{
  type=unType;
}
- (void) setOrder: (int) unOrder{
  order=unOrder;
}



- (void) calculBode {
      
      if (frequences==nil) frequences=[[NSMutableArray alloc] init];
      if (gains==nil) gains=[[NSMutableArray alloc] init];
      if (phases==nil) phases=[[NSMutableArray alloc] init];
      
      // Il faudraien enlever tous les élements du tableau
      
      int i;
      [frequences removeAllObjects];
      [gains removeAllObjects];
      [phases removeAllObjects]; 
           
      for (i=0;i<50;i++)
        {
          // -------------- caclul de la frequenc
          float uneFrequence;
          if (logFrequencyScale)uneFrequence=pow(10,i/10.0);
            else uneFrequence=i*2000;
          
          int OrderType=10*order+type;
          NSLog(@"ordre :%d type:%d",order,type);
          // Ordre 1 (ordre=1)
          //type=0 passe-bas;
          //1 passe-haut
          //2 Dérivateur
          //3 intégrateur
          //4 Amplificateur/attenuateur
          //5 Amplificateur/attenuateur inverseur
          
          // Ordre 2
          // 0 passe-bas;
          // 1 passe-haut;
          // 2 passe-bande
          // 3 coupe-bande;
          
          float unGain=gain;
          float unePhase=0;
          float pi=3.14157;
          switch (OrderType) {
            case 10: //passe-bas
               unGain=gain/sqrt(1.0+pow( uneFrequence/f0, 2 ) ) ;
               unePhase= -atan(uneFrequence/f0);
              break; 
            case 11: // Passe-haut 
               unGain=gain *(uneFrequence/f0) /sqrt(1.0+pow( uneFrequence/f0, 2 ) ) ;
               unePhase=(pi/2- atan(uneFrequence/f0));   
              break; 
            case 12: //derivateur
              unGain=gain*  (uneFrequence/f0);
              unePhase= (pi/2);
              break;
            case 13: //integrateur
              unGain=gain /  (uneFrequence/f0);
              unePhase= -(pi/2);
              break;
            case 14: //Amplificateur/attenuateur
              unGain=gain;
              unePhase=0;
              break;
            case 15: //Amplificateur/attenuateur
              unGain=gain;
              unePhase=pi;
              break;
            case 16: //exercice 7.4
                 unGain=9.1e-2*sqrt(1+pow(816e-6*uneFrequence,2))/sqrt(1+pow(74.2e-6*uneFrequence,2));
                 unePhase=atan(816e-6*uneFrequence)-atan(74.2e-6*uneFrequence);
                 break;
            case 20: // passe-bas d'ordre 2
              unGain=gain/sqrt (  pow( 1- pow(uneFrequence/f0 , 2) , 2 ) + pow(uneFrequence/(Q*f0) ,2)  ) ;
              unePhase= atan( (Q*uneFrequence/f0) / (1- pow(uneFrequence/f0 , 2)    )       );  
              break;
            case 21: // passe-haut d'ordre 2
              unGain=gain* pow(uneFrequence/f0 , 2)/sqrt ( pow( 1- pow(uneFrequence/f0 , 2) , 2 )+ pow(uneFrequence/(f0*Q) ,2)  ) ;
              unePhase= atan( (Q*uneFrequence/f0) / (1- pow(uneFrequence/f0 , 2)    )       );  
              break;
            case 22: // passe-bande d'ordre 2
              unGain=(gain*uneFrequence/(f0*Q))/sqrt ( pow( 1- pow(uneFrequence/f0 , 2) , 2 )+ pow(uneFrequence/(f0*Q) ,2)  ) ;
              unePhase= 0;atan( (Q*uneFrequence/f0) / (1- pow(uneFrequence/f0 , 2)    )       );  
              break;
            case 23: // coude-bande d'ordre 2
              unGain=gain*(  1- pow(uneFrequence/f0 , 2)  ) /sqrt ( pow( 1- pow(uneFrequence/f0 , 2) , 2 )+ pow(uneFrequence/(f0*Q) ,2)  ) ;
              unePhase= 0 ; 
              break;
            
          }  
               
          
          if (magDB)unGain=20*log10(unGain);
          
            // recherche des max et des min
          if (i==0){
            maxGain=unGain;
            minGain=unGain;
            maxPhase=unePhase;
            minPhase=unePhase;
          }
          if (unGain>maxGain) maxGain=unGain;
          if (unGain<minGain) minGain=unGain;
          if (unePhase>maxPhase) maxPhase=unePhase;
          if (unePhase<minPhase) minPhase=unePhase;
                  
          
          if (fixedYscale==NO) {
            plotMinGain=minGain;
            plotMaxGain=maxGain;
            plotMinPhase=minPhase;
            plotMaxPhase=maxPhase;
          }
            
          [frequences insertObject:[NSNumber numberWithFloat:uneFrequence] atIndex:i];
          [gains insertObject:[NSNumber numberWithFloat:unGain] atIndex:i];
          [phases insertObject:[NSNumber numberWithFloat:unePhase] atIndex:i];
        }
       
}



- (NSMutableArray *) getFrequences{
  return frequences;}
- (NSMutableArray *) getGains{
  return gains;}
- (NSMutableArray *) getPhases{
  return phases;}

-(float) getMaxGain {
  return maxGain;
}
-(float) getMinGain{
  return minGain;
}
-(float) getMaxPhase{
  return maxPhase;
}
-(float) getMinPhase{
  return minPhase;
}



- (void) setMinPlotGain:(float) minValue{
plotMinGain=minValue;
}
- (void) setMaxPlotGain:(float) maxValue{
plotMaxGain=maxValue;}
- (void) setMinPlotPhase:(float) minValue{
plotMinPhase=minValue;
}
- (void) setMaxPlotPhase:(float) maxValue{
plotMaxPhase=maxValue;
}
-(float) getPlotMaxGain {
return plotMaxGain;
}
-(float) getPlotMinGain{
return plotMinGain;
}
-(float) getPlotMaxPhase{
return plotMaxPhase;
}
-(float) getPlotMinPhase{
return plotMinPhase;

}



- (void) dealloc {
  [ frequences release];
  [ gains release];
  [ phases release];
  [super dealloc];
}


@end
