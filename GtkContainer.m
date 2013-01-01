//==================================================================================================================================
// GtkContainer.m
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
#import "GtkContainer.h"

//==================================================================================================================================
#define NATIVE_WIDGET    ((struct _GtkWidget    *)_native)
#define NATIVE_CONTAINER ((struct _GtkContainer *)_native)

//==================================================================================================================================
static void WrapAllChildren_Proxy(Native_GtkWidget *child, gpointer gp)
{
  GtkContainer *me = (GtkContainer *)gp;
  GtkWidget *wrap = [GtkWidget nativeToWrapper:child];
  if(wrap != nil) if([me contains:wrap]) return;
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:child];
  [(OFMutableArray *)(me.children) addObject:wrap];
}

//==================================================================================================================================
@implementation GtkContainer

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
- initWithExistingNative:(void *)native
{
  self = [super initWithExistingNative:native];
  if(self)
    _children = [[OFMutableArray alloc] init];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [_children release];
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize children = _children;
//----------------------------------------------------------------------------------------------------------------------------------
- (unsigned int) borderWidth { return (unsigned int)gtk_container_get_border_width(NATIVE_CONTAINER); }
- (void) setBorderWidth:(unsigned int)border { gtk_container_set_border_width(NATIVE_CONTAINER, (guint)border); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)add:(GtkWidget *)widget
{
  [_children addObject:widget];
  gtk_container_add(NATIVE_CONTAINER, widget.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)remove:(GtkWidget *)widget
{
  [_children removeObjectIdenticalTo:widget];
  gtk_container_remove(NATIVE_CONTAINER, widget.native);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)contains:(GtkWidget *)widget
{
  for(GtkWidget *child in _children)
    if(child == widget)
      return YES;
  return NO;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(GtkWidget *)wrapNativeChild:(void *)native
{
  GtkWidget *wrap = [GtkWidget nativeToWrapper:native];
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:native];
  [_children addObject:wrap];
  return wrap;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)wrapAllChildren
{
  //iterate native children:
  gtk_container_foreach(NATIVE_CONTAINER, WrapAllChildren_Proxy, self);
  //recurse:
  for(GtkWidget *child in _children)
    if(native_is_gtk_type_named(child.native, "GtkContainer"))
      [(GtkContainer *)child wrapAllChildren];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
