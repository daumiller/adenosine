//==================================================================================================================================
// GtkContainer.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkWidget.h>

//==================================================================================================================================
@interface GtkContainer : GtkWidget
{
  OFMutableArray *_children;
}

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign  ) unsigned int borderWidth;
@property (readonly) OFArray     *children;

//----------------------------------------------------------------------------------------------------------------------------------
- (void)add:(GtkWidget *)widget;
- (void)remove:(GtkWidget *)widget;
- (BOOL)contains:(GtkWidget *)widget;
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)wrapNativeChild:(void *)native;
-(void)wrapAllChildren;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
