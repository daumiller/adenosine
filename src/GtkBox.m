//==================================================================================================================================
// GtkBox.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/GtkBox.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_BOX    ((struct _GtkBox    *)_native)

//==================================================================================================================================
@implementation GtkBox

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ boxWithOrientation:(GtkBoxOrientation)orientation
{
  return [[[self alloc] initWithOrientation:orientation] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithOrientation:(GtkBoxOrientation)orientation
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_box_new((GtkOrientation)orientation, 0);
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(BOOL)forceEqual                     { return gtk_box_get_homogeneous(NATIVE_BOX);      }
-(void)setForceEqual:(BOOL)forceEqual { gtk_box_set_homogeneous(NATIVE_BOX, forceEqual); }
//----------------------------------------------------------------------------------------------------------------------------------
-(int)spacing                         { return gtk_box_get_spacing(NATIVE_BOX);          }
-(void)setSpacing:(int)spacing        { gtk_box_set_spacing(NATIVE_BOX, spacing);        }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addFromStart:(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  gtk_box_pack_start(NATIVE_BOX, widget.native, expand, fill, padding);
  [_children addObject:widget];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)addFromEnd  :(GtkWidget *)widget expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  gtk_box_pack_end(NATIVE_BOX, widget.native, expand, fill, padding);
  [_children addObject:widget];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)queryChild:(GtkWidget *)child expand:(BOOL *)expand fill:(BOOL *)fill padding:(unsigned int *)padding
{
  gtk_box_query_child_packing(NATIVE_BOX, child.native, (gboolean *)expand, (gboolean *)fill, padding, NULL);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)alterChild:(GtkWidget *)child expand:(BOOL)expand fill:(BOOL)fill padding:(unsigned int)padding
{
  GtkPackType packType;
  gtk_box_query_child_packing(NATIVE_BOX, child.native, NULL, NULL, NULL, &packType);
  gtk_box_set_child_packing(NATIVE_BOX, child.native, expand, fill, padding, packType);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
