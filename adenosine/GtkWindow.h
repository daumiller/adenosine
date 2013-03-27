//==================================================================================================================================
// GtkWindow.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <atropine/OMCoordinate.h>
#import <adenosine/GtkBin.h>

//==================================================================================================================================
typedef enum
{
  GTKWINDOWTYPE_TOPLEVEL,
  GTKWINDOWTYPE_POPUP
} GtkWindowType;
//----------------------------------------------------------------------------------------------------------------------------------
typedef enum
{
  GTKWINDOWSTATE_NORMAL,
  GTKWINDOWSTATE_MINIMIZED,
  GTKWINDOWSTATE_MAXIMIZED,
  GTKWINDOWSTATE_FULLSCREEN,
  GTKWINDOWSTATE_HIDDEN
} GtkWindowState;

//==================================================================================================================================
@class GtkWindow;
@protocol GtkWindowDelegate <OFObject>
@optional
-(BOOL)gtkWindowShouldClose:(GtkWindow *)window;
-(void)gtkWindowDidClose:(GtkWindow *)window;
@end

//==================================================================================================================================
@interface GtkWindow : GtkBin

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign)   OFString *title;
@property (assign)   GtkWidget *modalParent;
@property (assign)   GtkWindowState state;
@property (assign)   BOOL isResizable;
@property (assign)   BOOL isModal;
@property (assign)   BOOL isUrgent;
@property (assign)   BOOL isDecorated;
@property (assign)   BOOL showInTaskbar;
@property (assign)   BOOL showInPager;
@property (assign)   BOOL quitOnClose;
@property (assign)   OMSize       size;
@property (assign)   OMCoordinate position;
@property (readonly) void        *hotkeyId;

//----------------------------------------------------------------------------------------------------------------------------------
+ window;
+ windowWithType:(GtkWindowType)type;
- initWindow;
- initWithType:(GtkWindowType)type;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)reposition:(GtkWindowPosition)position;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onShouldClose;
-(void)onDidClose;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
