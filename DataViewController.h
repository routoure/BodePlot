/*
   Project: filtrage

   Copyright (C) 2025 Free Software Foundation

   Author: routoure,,,

   Created: 2025-02-28 16:22:37 +0100 by routoure

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

#ifndef _DATAVIEW_H_
#define _DATAVIEW_H_

#import <AppKit/AppKit.h>
#import "model.h"

@interface DataViewController : NSWindowController {
   IBOutlet NSTableView *tableView;
   ModelFiltre *plotModel;
}

- (IBAction) closeDataViewPanel;
 
-(void) setData:(ModelFiltre *) unModele;


@end

#endif // _DATAVIEW_H_

