//==================================================================================================================================
// GtkBin.m
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
==================================================================================================================================*/
#import "GtkNative.h"
#import "GtkBin.h"

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
