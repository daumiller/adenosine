//==================================================================================================================================
// GtkTextChildAnchor.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_TEXTCHILDANCHOR ((struct _GtkTextChildAnchor *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_textchildanchor"

//==================================================================================================================================
@implementation GtkTextChildAnchor

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkTextChildAnchor nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkTextChildAnchor *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ wrapExistingNative:(void *)native
{
  return [[[self alloc] initWithExistingNative:native] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithExistingNative:(void *)native
{
  self = [super init];
  if(self)
  {
    _native = native;
    g_object_ref(_native);
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup { g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self); }
-(void)destroy             { g_object_unref(_native);                                                              }

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ textChildAnchor { return [[[self alloc] initTextChildAnchor] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initTextChildAnchor
{
  self = [super init];
  if(self)
  {
    _native = gtk_text_child_anchor_new();
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)native   { return _native; }
-(BOOL)wasDeleted { return gtk_text_child_anchor_get_deleted(NATIVE_TEXTCHILDANCHOR); }

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(OFArray *)listWidgets
{
  OFMutableArray *ofWidgets = [[OFMutableArray alloc] init];
  GList *goWidgets = gtk_text_child_anchor_get_widgets(NATIVE_TEXTCHILDANCHOR);
  unsigned int goCount = g_list_length(goWidgets);
  for(unsigned int i=0; i<goCount; i++)
  {
    void *nativeWidget = g_list_nth_data(goWidgets, i);
    GtkWidget *ofWidget = [GtkWidget nativeToWrapper:nativeWidget];
    if(!ofWidget) ofWidget = [[GtkWidget alloc] initWithExistingNative:nativeWidget];
    [ofWidgets addObject:ofWidget];
  }
  g_list_free(goWidgets);

  OFArray *retArr = [OFArray arrayWithArray:ofWidgets];
  [ofWidgets release];
  return retArr;
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
