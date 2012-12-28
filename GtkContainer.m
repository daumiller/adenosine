//==================================================================================================================================
// GtkContainer.m
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
#import "GtkContainer.h"

//==================================================================================================================================
#define NATIVE_WIDGET    ((struct _GtkWidget    *)_native)
#define NATIVE_CONTAINER ((struct _GtkContainer *)_native)

//==================================================================================================================================
@implementation GtkContainer

//==================================================================================================================================
// Properties
//==================================================================================================================================
- (unsigned int) borderWidth { return (unsigned int)gtk_container_get_border_width(NATIVE_CONTAINER); }
- (void) setBorderWidth:(unsigned int)border { gtk_container_set_border_width(NATIVE_CONTAINER, (guint)border); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
- (void)add:(GtkWidget *)widget
{
  gtk_container_add(NATIVE_CONTAINER, widget->_native);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
