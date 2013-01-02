//==================================================================================================================================
// GtkGrid.m
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

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

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ grid
{
  return [[[self alloc] initGrid] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initGrid
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_grid_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(BOOL)forceEqualRows                               { return gtk_grid_get_row_homogeneous(NATIVE_GRID);                }
-(void)setForceEqualRows:(BOOL)forceEqualRows       { gtk_grid_set_row_homogeneous(NATIVE_GRID, forceEqualRows);       }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)forceEqualColumns                            { return gtk_grid_get_column_homogeneous(NATIVE_GRID);             }
-(void)setForceEqualColumns:(BOOL)forceEqualColumns { gtk_grid_set_column_homogeneous(NATIVE_GRID, forceEqualColumns); }
//----------------------------------------------------------------------------------------------------------------------------------
-(unsigned int)rowSpacing                           { return gtk_grid_get_row_spacing(NATIVE_GRID);                    }
-(void)setRowSpacing:(unsigned int)rowSpacing       { gtk_grid_set_row_spacing(NATIVE_GRID, rowSpacing);               }
//----------------------------------------------------------------------------------------------------------------------------------
-(unsigned int)columnSpacing                        { return gtk_grid_get_column_spacing(NATIVE_GRID);                 }
-(void)setColumnSpacing:(unsigned int)columnSpacing { gtk_grid_set_column_spacing(NATIVE_GRID, columnSpacing);         }

//==================================================================================================================================
// Utilities - Children
//==================================================================================================================================
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)width height:(int)height
{
  gtk_grid_attach(NATIVE_GRID, widget.native, left, top, width, height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget nextTo:(GtkWidget *)sibling onSide:(GtkPosition)position width:(int)colWidth height:(int)rowHeight
{
  gtk_grid_attach_next_to(NATIVE_GRID, widget.native, sibling.native, (GtkPositionType)position, colWidth, rowHeight);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void *)nativeAtColumn:(int)x andRow:(int)y
{
  return gtk_grid_get_child_at(NATIVE_GRID, x, y);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget *)childAtColumn:(int)x andRow:(int)y
{
  return [GtkWidget nativeToWrapper:[self nativeAtColumn:x andRow:y]];
}

//==================================================================================================================================
// Utilities - Col/Row
//==================================================================================================================================
-(void)insertRowAtIndex:(int)index    { gtk_grid_insert_row(NATIVE_GRID, index);    }
-(void)insertColumnAtIndex:(int)index { gtk_grid_insert_column(NATIVE_GRID, index); }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
