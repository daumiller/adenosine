//==================================================================================================================================
// GtkDialogMessage.h
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
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkDialog.h>

//==================================================================================================================================
typedef enum
{
  GTKDIALOGMESSAGE_TYPE_INFO,
  GTKDIALOGMESSAGE_TYPE_WARNING,
  GTKDIALOGMESSAGE_TYPE_QUESTION,
  GTKDIALOGMESSAGE_TYPE_ERROR,
  GTKDIALOGMESSAGE_TYPE_OTHER
} GtkDialogMessageType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKDIALOGMESSAGE_BUTTONS_NONE,
  GTKDIALOGMESSAGE_BUTTONS_OK,
  GTKDIALOGMESSAGE_BUTTONS_CLOSE,
  GTKDIALOGMESSAGE_BUTTONS_CANCEL,
  GTKDIALOGMESSAGE_BUTTONS_YES_NO,
  GTKDIALOGMESSAGE_BUTTONS_OK_CANCEL
} GtkDialogMessageButtons;

//==================================================================================================================================
@interface GtkDialogMessage : GtkDialog

//----------------------------------------------------------------------------------------------------------------------------------
+dialogMessageWithPrimary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons;
+dialogMessageWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons;
+dialogMessageWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons flags:(GtkDialogFlags)flags;
-initWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons flags:(GtkDialogFlags)flags;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) GtkWidget *image;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
