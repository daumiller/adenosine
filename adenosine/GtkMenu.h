//==================================================================================================================================
// GtkMenu.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkMenuShell.h>

//==================================================================================================================================
@interface GtkMenu : GtkMenuShell

//----------------------------------------------------------------------------------------------------------------------------------
+ menu;
- initMenu;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL alwaysShowGutter;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)attach:(GtkWidget *)child column:(int)left row:(int)top;
-(void)attach:(GtkWidget *)child leftColumn:(int)left rightColumn:(int)right topRow:(int)top bottomRow:(int)bottom;
-(void)reorderChild:(GtkWidget *)child toIndex:(int)index;
-(void)popupFromButton:(int)button;
-(void)popdown;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
