//==================================================================================================================================
// GtkDialog.h
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
#import <adenosine/GtkWindow.h>

//==================================================================================================================================
typedef enum
{
  GTKDIALOG_FLAG_MODAL               = 1<<0,
  GTKDIALOG_FLAG_DESTROY_WITH_PARENT = 1<<1
} GtkDialogFlags;
//----------------------------------------------------------------------------------------------------------------------------------t
typedef enum
{
  GTKDIALOG_RESPONSE_NONE   = - 1,
  GTKDIALOG_RESPONSE_REJECT = - 2,
  GTKDIALOG_RESPONSE_ACCEPT = - 3,
  GTKDIALOG_RESPONSE_DELETE = - 4,
  GTKDIALOG_RESPONSE_OK     = - 5,
  GTKDIALOG_RESPONSE_CANCEL = - 6,
  GTKDIALOG_RESPONSE_CLOSE  = - 7,
  GTKDIALOG_RESPONSE_YES    = - 8,
  GTKDIALOG_RESPONSE_NO     = - 9,
  GTKDIALOG_RESPONSE_APPLY  = -10,
  GTKDIALOG_RESPONSE_HELP   = -11
} GtkDialogResponse;

//==================================================================================================================================
@interface GtkDialog : GtkWindow

//----------------------------------------------------------------------------------------------------------------------------------
+dialog;
-initDialog;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) GtkWidget *actionArea;
@property (readonly) GtkWidget *contentArea;
@property (assign)   int        defaultResponse;

//----------------------------------------------------------------------------------------------------------------------------------
-(int)run;
-(GtkWidget *)addButtonWithText:(OFString *)text andId:(int)idNumber;
-(void)addButtons:(OFDictionary *)buttons;
-(void)addActionWidget:(GtkWidget *)child withId:(int)idNumber;
-(void)addActionWidgets:(OFDictionary *)children;
-(void)setButtonOrder:(OFArray *)ids;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
