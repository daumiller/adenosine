//==================================================================================================================================
// GtkMisc.m
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
#import <adenosine/GtkMisc.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_MISC   ((struct _GtkMisc   *)_native)

//==================================================================================================================================
@implementation GtkMisc

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OMCoordinate)alignment
{
  OMCoordinate alignment;
  gtk_misc_get_alignment(NATIVE_MISC, &alignment.x, &alignment.y);
  return alignment;
}
-(void)setAlignment:(OMCoordinate)alignment
{
  gtk_misc_set_alignment(NATIVE_MISC, alignment.x, alignment.y);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)padding
{
  int width, height;
  gtk_misc_get_padding(NATIVE_MISC, &width, &height);
  return OMMakeSize((float)width, (float)height);
}
-(void)setPadding:(OMSize)padding
{
  int width  = (int)padding.width;
  int height = (int)padding.height;
  gtk_misc_set_padding(NATIVE_MISC, width, height);
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
