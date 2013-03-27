//==================================================================================================================================
// GtkBuilder.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_BUILDER ((struct _GtkBuilder *)_native)

//==================================================================================================================================
@implementation GtkBuilder

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ builder                               { return [[[self alloc] init                 ] autorelease]; }
+ builderWithFile:(OFString *)filename  { return [[[self alloc] initWithFile:filename] autorelease]; }
+ builderWithString:(OFString *)string  { return [[[self alloc] initWithString:string] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithFile:(OFString *)filename
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
    [self addFromFile:filename];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithString:(OFString *)string
{
  self = [super init];
  if(self)
  {
    _native = gtk_builder_new();
    [self addFromString:string];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  if(_native) g_object_unref(G_OBJECT(_native));
  [super dealloc];
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
@synthesize native = _native;

//==================================================================================================================================
// Lookups
//==================================================================================================================================
-(void *)nativeByName:(OFString *)name
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  void *result = gtk_builder_get_object(NATIVE_BUILDER, [name UTF8String]);
  [pool drain];
  return result;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(id)widgetByName:(OFString *)name
{
  void *native = [self nativeByName:name];
  //this object may already have been wrapped; double check before creating a new one
  GtkWidget *wrap = [GtkWidget nativeToWrapper:native];
  if(wrap == nil) wrap = [GtkWidget wrapExistingNative:native];
  return wrap;
}

//==================================================================================================================================
// Loaders
//==================================================================================================================================
-(BOOL)addFromFile:(OFString *)filename
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  unsigned int result = gtk_builder_add_from_file(NATIVE_BUILDER, [filename UTF8String], NULL); 
  [pool drain];
  return (result != 0);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)addFromString:(OFString *)string
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  unsigned int result = gtk_builder_add_from_string(NATIVE_BUILDER, [string UTF8String], -1, NULL); 
  [pool drain];
  return (result != 0);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
