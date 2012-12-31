//==================================================================================================================================
// GtkGrid.h
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
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
typedef enum
{
  GTKBOXORIENTATION_HORIZONTAL,
  GTKBOXORIENTATION_VERTICAL
} GtkBoxOrientation;

//==================================================================================================================================
@interface GtkBox : GtkContainer

//----------------------------------------------------------------------------------------------------------------------------------
+ boxWithOrientation:(GtkBoxOrientation)orientation;
- initWithOrientation:(GtkBoxOrientation)orientation;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL forceEqual;
@property (assign) int  spacing;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)addFromStart:(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding;
-(void)addFromEnd  :(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)queryChild:(GtkWidget *)child expand:(BOOL *)expand fill:(BOOL *)fill padding:(unsigned int *)padding;
-(void)alterChild:(GtkWidget *)child expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
