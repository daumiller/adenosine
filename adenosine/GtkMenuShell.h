//==================================================================================================================================
// GtkMenuShell.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
@interface GtkMenuShell : GtkContainer

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign)   BOOL       doesTakeFocus;
@property (readonly) GtkWidget *selectedItem;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)append :(GtkWidget *)child;
-(void)prepend:(GtkWidget *)child;
-(void)insert :(GtkWidget *)child atIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)appendSeparator;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)selectFirstItem;
-(void)selectItem:(GtkWidget *)item;
-(void)deselectItem;
-(void)cancelSelection;
-(void)activateItem:(GtkWidget *)item andDeactivate:(BOOL)deactivate;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)deactivate;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
