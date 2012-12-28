//==================================================================================================================================
// GtkGrid.m
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
==================================================================================================================================*/
#import "GtkNative.h"
#import "GtkGrid.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_GRID   ((struct _GtkGrid   *)_native)

//==================================================================================================================================
@implementation GtkGrid

//----------------------------------------------------------------------------------------------------------------------------------
+ grid
{
  GtkGrid *grid = [[GtkGrid alloc] init];
  grid->_native = (void *)gtk_grid_new();
  [grid installNativeLookup];
  return [grid autorelease];
}

//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)width height:(int)height
{
  gtk_grid_attach(NATIVE_GRID, widget->_native, left, top, width, height);
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
