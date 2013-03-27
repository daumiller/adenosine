//==================================================================================================================================
// GtkEntryBuffer.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_BUFFER ((struct _GtkEntryBuffer *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_buffer"

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_TextDeleted(struct _GtkEntryBuffer *buffer, unsigned int position, unsigned int length, void *data)
{
  GtkEntryBuffer *obj = (GtkEntryBuffer *)[GtkEntryBuffer nativeToWrapper:(void *)buffer];
  [obj onTextDeleted:of_range((int)position, (int)length)];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_TextInserted(struct _GtkEntryBuffer *buffer, unsigned int position, char *str, unsigned int length, void *data)
{
  GtkEntryBuffer *obj = (GtkEntryBuffer *)[GtkEntryBuffer nativeToWrapper:(void *)buffer];
  [obj onTextInserted:of_range((int)position, (int)length)];
}

//==================================================================================================================================
@implementation GtkEntryBuffer

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkEntryBuffer nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkEntryBuffer *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
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
    _connections = [[OFMutableArray alloc] init];
    _native = native;
    g_object_ref(_native); //keep alive; and even out our -[destroy]
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)installNativeLookup
{
  g_object_set_data((gpointer)_native, ADENOSINE_NATIVE_LOOKUP_STRING, (gpointer)self);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)destroy
{
  //if we create a EntryBuffer, then assign it to a Entry, then let the EntryBuffer be drained:
  //  -- during assignment, the native Entry should increment the native EntryBuffer's reference count
  //  -- our wrapped EntryBuffer will be discarded; decrementing (but not zeroing) the native EntryBuffer's reference count
  //  -- the native EntryBuffer will live on, for the life of any assigned to Entrys
  //however: if a wrapped EntryBuffer has a delegate receiving signals, then you probably want to keep it alive
  g_object_unref(_native);
}

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ entryBuffer                          { return [[[self alloc] initEntryBuffer  ] autorelease]; }
+ entryBufferWithText:(OFString *)text { return [[[self alloc] initWithText:text] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initEntryBuffer
{
  self = [super init];
  if(self)
  {
    _connections = [[OFMutableArray alloc] init];
    _native = gtk_entry_buffer_new(NULL,0);
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    _connections = [[OFMutableArray alloc] init];
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_entry_buffer_new([text UTF8String], -1);
    [pool drain];
    [self installNativeLookup];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.delegate = nil;
  [_connections release];
  [self destroy];
  [super dealloc]; 
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(void *)native                    { return _native;                                                                  }
-(int)bytes                        { return (int)gtk_entry_buffer_get_bytes(NATIVE_BUFFER);                           }
-(int)length                       { return (int)gtk_entry_buffer_get_length(NATIVE_BUFFER);                          }
-(int)maxLength                    { return (int)gtk_entry_buffer_get_max_length(NATIVE_BUFFER);                      }
-(void)setMaxLength:(int)maxLength { gtk_entry_buffer_set_max_length(NATIVE_BUFFER, maxLength);                       }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(OFString *)text                  { return [OFString stringWithUTF8String:gtk_entry_buffer_get_text(NATIVE_BUFFER)]; }
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_entry_buffer_set_text(NATIVE_BUFFER, [text UTF8String], -1);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(id)delegate                      { return _delegate;                                                                }
-(void)setDelegate:(id)delegate
{
  for(OFNumber *idNumber in _connections)
    g_signal_handler_disconnect(_native, [idNumber unsignedLongValue]);
  [_connections release];
  _connections = [[OFMutableArray alloc] init];

  if(_delegate) [_delegate release];
  _delegate = [delegate retain];
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkEntryBuffer:textDeleted:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "deleted-text", G_CALLBACK(ConnectionProxy_TextDeleted),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkEntryBuffer:textInserted:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "inserted-text", G_CALLBACK(ConnectionProxy_TextInserted),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(int)insertText:(OFString *)text atIndex:(int)index
{
  if(!text) return 0;
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  int result = (int)gtk_entry_buffer_insert_text(NATIVE_BUFFER, (unsigned int)index, [text UTF8String], -1);
  [pool drain];
  return result;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(int)deleteTextRange:(of_range_t)range
{
  return (int)gtk_entry_buffer_delete_text(NATIVE_BUFFER, (unsigned int)range.location, (unsigned int)range.length);
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onTextDeleted:(of_range_t)range  { [_delegate gtkEntryBuffer:self textDeleted:range ];  }
-(void)onTextInserted:(of_range_t)range { [_delegate gtkEntryBuffer:self textInserted:range]; }

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
