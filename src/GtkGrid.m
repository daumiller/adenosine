//==================================================================================================================================
// GtkGrid.m
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
#import "GtkNative.h"
#import <adenosine/GtkGrid.h>

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
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top
{
  [_children addObject:widget];
  gtk_grid_attach(NATIVE_GRID, widget.native, left, top, 1, 1);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)width height:(int)height
{
  [_children addObject:widget];
  gtk_grid_attach(NATIVE_GRID, widget.native, left, top, width, height);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget nextTo:(GtkWidget *)sibling onSide:(GtkPosition)position width:(int)colWidth height:(int)rowHeight
{
  [_children addObject:widget];
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
//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight
{
  gtk_grid_attach(NATIVE_GRID, gtk_drawing_area_new(), left, top, colWidth, rowHeight);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight hExpand:(BOOL)hExpand hAlign:(GtkAlign)hAlign vExpand:(BOOL)vExpand vAlign:(GtkAlign)vAlign;
{
  void *da = gtk_drawing_area_new();
  gtk_widget_set_hexpand(da, hExpand); gtk_widget_set_halign(da, (Native_GtkAlign)hAlign);
  gtk_widget_set_vexpand(da, vExpand); gtk_widget_set_valign(da, (Native_GtkAlign)vAlign);
  gtk_grid_attach(NATIVE_GRID, da, left, top, colWidth, rowHeight);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attachSpacerLeft:(int)left top:(int)top pixelWidth:(int)width pixelHeight:(int)height
{
  void *da = gtk_drawing_area_new();
  gtk_widget_set_size_request(da, width, height);
  gtk_grid_attach(NATIVE_GRID, da, left, top, 1, 1);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
