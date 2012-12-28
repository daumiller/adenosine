//==================================================================================================================================
// GtkFrame.h
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
#import <adenosine/GtkBin.h>

//==================================================================================================================================
typedef enum
{
  GTKFRAMESHADOW_NONE,
  GTKFRAMESHADOW_BEVEL_IN,
  GTKFRAMESHADOW_BEVEL_OUT,
  GTKFRAMESHADOW_SUNKEN,
  GTKFRAMESHADOW_RAISED
} GtkFrameShadow;

//==================================================================================================================================
@interface GtkFrame : GtkBin

//----------------------------------------------------------------------------------------------------------------------------------
+ frame;
+ frameWithText:(OFString *)text;
- init;
- initWithText:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString      *text;
@property (assign) GtkFrameShadow shadow;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
