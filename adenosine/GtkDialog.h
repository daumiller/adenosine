//==================================================================================================================================
// GtkDialog.h
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
