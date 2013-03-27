//==================================================================================================================================
// GtkMenuRadio.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkMenuCheck.h>

//==================================================================================================================================
@interface GtkMenuRadio : GtkMenuCheck

//----------------------------------------------------------------------------------------------------------------------------------
+ menuRadioWithGroup:(void *)group;
+ menuRadioWithGroup:(void *)group andText:(OFString *)text;
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText :(OFString *)text;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+ menuRadioWithGroup:(void *)group                                           andDelegate:(id)delegate;
+ menuRadioWithGroup:(void *)group andText:(OFString *)text                  andDelegate:(id)delegate;
+ menuRadioWithGroup:(void *)group andAccel:(OFString *)text                 andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember                           andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andText :(OFString *)text andDelegate:(id)delegate;
+ menuRadioWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text andDelegate:(id)delegate;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithGroup:(void *)group;
- initWithGroup:(void *)group andText:(OFString *)text;
- initWithGroup:(void *)group andAccel:(OFString *)text;
- initWithSibling:(GtkMenuRadio *)groupMember;
- initWithSibling:(GtkMenuRadio *)groupMember andText:(OFString *)text;
- initWithSibling:(GtkMenuRadio *)groupMember andAccel:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) void *groupId;

//----------------------------------------------------------------------------------------------------------------------------------
-(OFArray *)listGroup;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
