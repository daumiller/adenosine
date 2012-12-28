//==================================================================================================================================
// GtkWidget.m
/*==================================================================================================================================
Copyright © 2012 Dillon Aumiller <dillonaumiller@gmail.com>

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
#import "GtkWidget.h"

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_widget"

//==================================================================================================================================
@implementation GtkWidget

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ nativeToWrapper:(void *)native
{
  if(!GTK_IS_WIDGET(native)) return nil;
  return (GtkWidget *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
}
//----------------------------------------------------------------------------------------------------------------------------------
+ widget
{
  GtkWidget *widget = [[self alloc] init];
  widget->_native = (void *)gtk_widget_new(GTK_TYPE_WIDGET, NULL);
  [widget installNativeLookup];
  return [widget autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup
{
  //use by subclasses after setting up their _native
  g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)destroy
{
  if(GTK_IS_WIDGET(NATIVE_WIDGET)) gtk_widget_destroy(NATIVE_WIDGET);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize native = _native;

//==================================================================================================================================
// Utilities
//==================================================================================================================================
- (void) show         { gtk_widget_show         (NATIVE_WIDGET); }
- (void) showAll      { gtk_widget_show_all     (NATIVE_WIDGET); }
- (void) hide         { gtk_widget_hide         (NATIVE_WIDGET); }
- (void) activate     { gtk_widget_activate     (NATIVE_WIDGET); }
- (void) grabFocus    { gtk_widget_grab_focus   (NATIVE_WIDGET); }
- (void) grabDefault  { gtk_widget_grab_default (NATIVE_WIDGET); }
- (BOOL) isFocused    { return (gtk_widget_is_focus(NATIVE_WIDGET) == TRUE); }
//----------------------------------------------------------------------------------------------------------------------------------
- (void) setProperty:(OFString *)property toValue:(void *)value
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  g_object_set_data((gpointer)_native, [property UTF8String], (gpointer)value);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- (void *)getProperty:(OFString *)property
{
  if(!GTK_IS_WIDGET(_native)) return NULL;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *data = (void *)g_object_get_data((GObject *)_native, [property UTF8String]);
  [pool drain];
  return data;
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
