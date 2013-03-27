//==================================================================================================================================
// GtkGrid.h
//==================================================================================================================================
#import <adenosine/GtkContainer.h>

//==================================================================================================================================
@interface GtkGrid : GtkContainer

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL forceEqualRows;
@property (assign) BOOL forceEqualColumns;
@property (assign) unsigned int rowSpacing;
@property (assign) unsigned int columnSpacing;

//----------------------------------------------------------------------------------------------------------------------------------
+ grid;
- initGrid;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top;
-(void)attachWidget:(GtkWidget *)widget left:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachWidget:(GtkWidget *)widget nextTo:(GtkWidget *)sibling onSide:(GtkPosition)position width:(int)colWidth height:(int)rowHeight;
-(GtkWidget *)childAtColumn:(int)x andRow:(int)y;
-(void *)nativeAtColumn:(int)x andRow:(int)y;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)insertRowAtIndex:(int)index;
-(void)insertColumnAtIndex:(int)index;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight;
-(void)attachSpacerLeft:(int)left top:(int)top width:(int)colWidth height:(int)rowHeight hExpand:(BOOL)hExpand hAlign:(GtkAlign)hAlign vExpand:(BOOL)vExpand vAlign:(GtkAlign)vAlign;
-(void)attachSpacerLeft:(int)left top:(int)top pixelWidth:(int)width pixelHeight:(int)height;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
