//==================================================================================================================================
// GtkBin.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/GtkBin.h>

//==================================================================================================================================
#define NATIVE_WIDGET    ((struct _GtkWidget    *)_native)
#define NATIVE_CONTAINER ((struct _GtkContainer *)_native)
#define NATIVE_BIN       ((struct _GtkBin       *)_native)

//==================================================================================================================================
@implementation GtkBin

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(GtkWidget *)child { if(_children.count == 0) return nil; return [_children objectAtIndex:0]; }
-(void)setChild:(GtkWidget *)child
{
  if(_children.count > 0)
  {
    gtk_container_remove(NATIVE_CONTAINER, child.native);
    [_children removeObjectAtIndex:0];
  }
  if(child != nil)
  {
    gtk_container_add(NATIVE_CONTAINER, child.native);
    [_children addObject:child];
  }
}

//==================================================================================================================================
// Overrides of GtkContainer
//==================================================================================================================================
- (void)add:(GtkWidget *)widget { self.child = widget; }
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)wrapNativeChild:(void *)native
{
  GtkWidget *wrap = [GtkWidget nativeToWrapper:native];
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:native];
  if(_children.count > 0) [_children removeObjectAtIndex:0];
  if(wrap != nil)         [_children addObject:wrap];
  return wrap;
}
-(void)wrapAllChildren
{
  //wrap single child:
  void *nativeChild = gtk_bin_get_child(NATIVE_BIN);
  if(!nativeChild) return;
  GtkWidget *child  = [self wrapNativeChild:nativeChild];
  //recurse:
  if(native_is_gtk_type_named(nativeChild, "GtkContainer"))
    [(GtkContainer *)child wrapAllChildren];
}


//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
