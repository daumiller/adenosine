//==================================================================================================================================
// GtkGrid.h
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
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
@interface GtkGrid : GtkContainer

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL forceEqualRows;
@property (assign) BOOL forceEqualColumns;
@property (assign) unsigned int rowSpacing;
@property (assign) unsigned int columnSpacing;

//----------------------------------------------------------------------------------------------------------------------------------
+ grid;
- initGrid;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top;
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachWidget:(GtkWidget *)widget nextTo:(GtkWidget *)sibling onSide:(GtkPosition)position width:(int)colWidth height:(int)rowHeight;
-(GtkWidget *)childAtColumn:(int)x andRow:(int)y;
-(void *)nativeAtColumn:(int)x andRow:(int)y;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)insertRowAtIndex:(int)index;
-(void)insertColumnAtIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight hExpand:(BOOL)hExpand hAlign:(GtkAlign)hAlign vExpand:(BOOL)vExpand vAlign:(GtkAlign)vAlign;
-(void)attachSpacerLeft:(int)left top:(int)top pixelWidth:(int)width pixelHeight:(int)height;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
