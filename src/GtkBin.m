//==================================================================================================================================
// GtkBin.m
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
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
