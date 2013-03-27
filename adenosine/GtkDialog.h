//==================================================================================================================================
// GtkDialog.h
//==================================================================================================================================
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
