//==================================================================================================================================
// GtkMenuRadio.h
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
