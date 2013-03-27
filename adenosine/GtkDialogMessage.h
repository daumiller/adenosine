//==================================================================================================================================
// GtkDialogMessage.h
//==================================================================================================================================
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
