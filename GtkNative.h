//==================================================================================================================================
// GtkNative.h
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
#define GtkWidget      Native_GtkWidget
#define GtkContainer   Native_GtkContainer
#define GtkBin         Native_GtkBin
#define GtkWindow      Native_GtkWindow
#define GtkWindowType  Native_GtkWindowType
#define GtkButton      Native_GtkButton
#define GtkMisc        Native_GtkMisc
#define GtkLabel       Native_GtkLabel
#define GtkGrid        Native_GtkGrid
#define GtkFrame       Native_GtkFrame
#define GtkDrawingArea Native_GtkDrawingArea
#define GtkImage       Native_GtkImage
#define GtkIconSize    Native_GtkIconSize
#define GtkProgressBar Native_GtkProgressBar
#define GtkBuilder     Native_GtkBuilder

#include <gtk/gtk.h>

#undef GtkBuilder
#undef GtkProgressBar
#undef GtkIconSize
#undef GtkImage
#undef GtkDrawingArea
#undef GtkFrame
#undef GtkGrid
#undef GtkLabel
#undef GtkMisc
#undef GtkButton
#undef GtkWindowType
#undef GtkWindow
#undef GtkBin
#undef GtkContainer
#undef GtkWidget
