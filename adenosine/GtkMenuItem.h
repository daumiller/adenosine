//==================================================================================================================================
// GtkMenuItem.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkBin.h>

//==================================================================================================================================
@class GtkMenuItem;
@protocol GtkMenuItemDelegate <OFObject>
@optional
-(void)gtkMenuItemActivated:(GtkMenuItem *)menuItem;
@end

//==================================================================================================================================
@interface GtkMenuItem : GtkBin
{
  GtkWidget *_submenu;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ menuItem;
+ menuItemWithText:(OFString *)text;
+ menuItemWithAccel:(OFString *)text;
+ menuItemWithAccel:(OFString *)text andDelegate:(id)delegate;
- initMenuItem;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;
- initWithAccel:(OFString *)text andDelegate:(id)delegate;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString  *text;
@property (assign) BOOL       textIsAccel;
@property (retain) GtkWidget *submenu;

//----------------------------------------------------------------------------------------------------------------------------------
//TODO: we need a wrapper Key Enumeration (not depending on GTK/GDK for this...)
-(void)addHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers toWindow:(GtkWindow *)window;
-(void)removeHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers fromWindow:(GtkWindow *)window;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onActivated;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
