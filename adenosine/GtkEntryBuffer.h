//==================================================================================================================================
// GtkEntryBuffer.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>

//==================================================================================================================================
@class GtkEntryBuffer;
@protocol GtkEntryBufferDelegate <OFObject>
@optional
-(void)gtkEntryBuffer:(GtkEntryBuffer *)buffer textDeleted:(of_range_t)range;
-(void)gtkEntryBuffer:(GtkEntryBuffer *)buffer textInserted:(of_range_t)range;
@end

//==================================================================================================================================
@interface GtkEntryBuffer : OFObject
{
  id              _delegate;
  void           *_native;
  OFMutableArray *_connections;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ entryBuffer;
+ entryBufferWithText:(OFString *)text;
- initEntryBuffer;
- initWithText:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void     *native;
@property (readonly) int       bytes;
@property (readonly) int       length;
@property (assign)   int       maxLength;
@property (assign)   OFString *text;
@property (retain)   id        delegate;

//----------------------------------------------------------------------------------------------------------------------------------
-(int)insertText:(OFString *)text atIndex:(int)index;
-(int)deleteTextRange:(of_range_t)range;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onTextDeleted:(of_range_t)range;
-(void)onTextInserted:(of_range_t)range;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
