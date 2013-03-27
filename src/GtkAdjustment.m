//==================================================================================================================================
// GtkAdjustment.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_ADJUSTMENT ((struct _GtkAdjustment *)_native)
#define ADENOSINE_NATIVE_LOOKUP_STRING "_adenosine_wrapper_adjustment"

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Changed(struct _GtkAdjustment *adjustment, gpointer data)
{
  GtkAdjustment *obj = (GtkAdjustment *)[GtkAdjustment nativeToWrapper:(void *)adjustment];
  [obj onChanged];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
static void ConnectionProxy_ValueChanged(struct _GtkAdjustment *adjustment, gpointer data)
{
  GtkAdjustment *obj = (GtkAdjustment *)[GtkAdjustment nativeToWrapper:(void *)adjustment];
  [obj onValueChanged];
}

//==================================================================================================================================
@implementation GtkAdjustment

//==================================================================================================================================
// Wrapping
//==================================================================================================================================
+ (BOOL) isWrapped:(void *)native
{
  return ([GtkAdjustment nativeToWrapper:native] != nil);
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ nativeToWrapper:(void *)native
{
  if(!G_IS_OBJECT(native)) return nil;
  return (GtkAdjustment *)g_object_get_data((GObject *)native, ADENOSINE_NATIVE_LOOKUP_STRING);
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
-(void *)native { return _native; }
//----------------------------------------------------------------------------------------------------------------------------------
-(float)value         { return (float)gtk_adjustment_get_value(NATIVE_ADJUSTMENT);          }
-(float)lower         { return (float)gtk_adjustment_get_lower(NATIVE_ADJUSTMENT);          }
-(float)upper         { return (float)gtk_adjustment_get_upper(NATIVE_ADJUSTMENT);          }
-(float)pageSize      { return (float)gtk_adjustment_get_page_size(NATIVE_ADJUSTMENT);      }
-(float)pageIncrement { return (float)gtk_adjustment_get_page_increment(NATIVE_ADJUSTMENT); }
-(float)stepIncrement { return (float)gtk_adjustment_get_step_increment(NATIVE_ADJUSTMENT); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setValue        :(float)value         { gtk_adjustment_set_value(NATIVE_ADJUSTMENT, (float)value);                  }
-(void)setLower        :(float)lower         { gtk_adjustment_set_lower(NATIVE_ADJUSTMENT, (float)lower);                  }
-(void)setUpper        :(float)upper         { gtk_adjustment_set_upper(NATIVE_ADJUSTMENT, (float)upper);                  }
-(void)setPageSize     :(float)pageSize      { gtk_adjustment_set_page_size(NATIVE_ADJUSTMENT, (float)pageSize);           }
-(void)setPageIncrement:(float)pageIncrement { gtk_adjustment_set_page_increment(NATIVE_ADJUSTMENT, (float)pageIncrement); }
-(void)setStepIncrement:(float)stepIncrement { gtk_adjustment_set_step_increment(NATIVE_ADJUSTMENT, (float)stepIncrement); }
//----------------------------------------------------------------------------------------------------------------------------------
-(id)delegate { return _delegate; }
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
    if([_delegate respondsToSelector:@selector(gtkAdjustmentChanged:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "changed", G_CALLBACK(ConnectionProxy_Changed),NULL)]];

    if([_delegate respondsToSelector:@selector(gtkAdjustment:valueChangedTo:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "value-changed", G_CALLBACK(ConnectionProxy_ValueChanged),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)movePageOverRangeLower:(float)lower upper:(float)upper
{
  gtk_adjustment_clamp_page(NATIVE_ADJUSTMENT, lower, upper);
}

-(void)configureValue:(float)value lower:(float)lower upper:(float)upper pageSize:(float)pageSize pageIncrement:(float)pageInc stepIncrement:(float)stepInc
{
  gtk_adjustment_configure(NATIVE_ADJUSTMENT, value, lower, upper, stepInc, pageInc, pageSize);
}

-(float)minimumIncrement
{
  return gtk_adjustment_get_minimum_increment(NATIVE_ADJUSTMENT);
}

-(void)emitChanged      { gtk_adjustment_changed(NATIVE_ADJUSTMENT);       }
-(void)emitValueChanged { gtk_adjustment_value_changed(NATIVE_ADJUSTMENT); }

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onChanged
{
  [_delegate gtkAdjustmentChanged:self];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)onValueChanged
{
  [_delegate gtkAdjustment:self valueChangedTo:self.value];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
