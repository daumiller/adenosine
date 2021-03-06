//==================================================================================================================================
// GtkTextTagTable.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkEnums.h>

//==================================================================================================================================
@interface GtkTextTagTable : OFObject
{
  void           *_native;
  OFMutableArray *_tags;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textTagTable;
- initTextTagTable;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void    *native;
@property (readonly) int      size;
@property (readonly) OFArray *tags;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)add:(GtkTextTag *)textTag;
-(void)remove:(GtkTextTag *)textTag;
-(GtkTextTag *)findByName:(OFString *)name;
-(void)forEachTag:(void (^)(GtkTextTag *))block;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
