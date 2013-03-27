//==================================================================================================================================
// GtkNative.h
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
#define GtkWidget                Native_GtkWidget
#define GtkAlign                 Native_GtkAlign
#define GtkContainer             Native_GtkContainer
#define GtkBin                   Native_GtkBin
#define GtkWindow                Native_GtkWindow
#define GtkWindowType            Native_GtkWindowType
#define GtkButton                Native_GtkButton
#define GtkMisc                  Native_GtkMisc
#define GtkLabel                 Native_GtkLabel
#define GtkGrid                  Native_GtkGrid
#define GtkFrame                 Native_GtkFrame
#define GtkDrawingArea           Native_GtkDrawingArea
#define GtkImage                 Native_GtkImage
#define GtkIconSize              Native_GtkIconSize
#define GtkProgressBar           Native_GtkProgressBar
#define GtkBuilder               Native_GtkBuilder
#define GtkBox                   Native_GtkBox
#define GtkComboBox              Native_GtkComboBox
#define GtkComboBoxText          Native_GtkComboBoxText
#define GtkNotebook              Native_GtkNotebook
#define GtkScrolledWindow        Native_GtkScrolledWindow
#define GtkMenuItem              Native_GtkMenuItem
#define GtkSeparatorMenuItem     Native_GtkMenuSeparatorItem
#define GtkImageMenuItem         Native_GtkImageMenuItem
#define GtkCheckMenuItem         Native_GtkCheckMenuItem
#define GtkRadioMenuItem         Native_GtkRadioMenuItem
#define GtkMenuShell             Native_GtkMenuShell
#define GtkMenuBar               Native_GtkMenuBar
#define GtkMenu                  Native_GtkMenu
#define GtkDialog                Native_GtkDialog
#define GtkDialogFlags           Native_GtkDialogFlags
#define GtkMessageDialog         Native_GtkMessageDialog
#define GtkEntryBuffer           Native_GtkEntryBuffer
#define GtkEntry                 Native_GtkEntry
#define GtkTextTag               Native_GtkTextTag
#define GtkTextDirection         Native_GtkTextDirection
#define GtkTextTagTable          Native_GtkTextTagTable
#define GtkTextIter              Native_GtkTextIter
#define GtkTextMark              Native_GtkTextMark
#define GtkTextChildAnchor       Native_GtkTextChildAnchor
#define GtkTextBuffer            Native_GtkTextBuffer
#define GtkTextBufferTargetInfo  Native_GtkTextBufferTargetInfo
#define GtkTextView              Native_GtkTextView
#define GtkWrapMode              Native_GtkWrapMode
#define GtkTextWindowType        Native_GtkTextWindowType
#define GtkTextSearchFlags       Native_GtkTextSearchFlags
#define GtkViewport              Native_GtkViewport
#define GtkStateFlags            Native_GtkStateFlags
#define GtkFontChooser           Native_GtkFontChooser
#define GtkFontButton            Native_GtkFontButton
#define GtkLayout                Native_GtkLayout
#define GtkEventBox              Native_GtkEventBox
#define GtkListBox               Native_GtkListBox
#define GtkWindowPosition        Native_GtkWindowPosition
#define GtkAdjustment            Native_GtkAdjustment

#include <gtk/gtk.h>

#undef GtkAdjustment
#undef GtkWindowPosition
#undef GtkListBox
#undef GtkEventBox
#undef GtkLayout
#undef GtkFontButton
#undef GtkFontChooser
#undef GtkStateFlags
#undef GtkViewport
#undef GtkTextSearchFlags
#undef GtkTextWindowType
#undef GtkWrapMode
#undef GtkTextView
#undef GtkTextBufferTargetInfo
#undef GtkTextBuffer
#undef GtkTextChildAnchor
#undef GtkTextMark
#undef GtkTextIter
#undef GtkTextTagTable
#undef GtkTextDirection
#undef GtkTextTag
#undef GtkEntry
#undef GtkEntryBuffer
#undef GtkMessageDialog
#undef GtkDialogFlags
#undef GtkDialog
#undef GtkMenu
#undef GtkMenuBar
#undef GtkMenuShell
#undef GtkRadioMenuItem
#undef GtkCheckMenuItem
#undef GtkImageMenuItem
#undef GtkSeparatorMenuItem
#undef GtkMenuItem
#undef GtkScrolledWindow
#undef GtkNotebook
#undef GtkComboBoxText
#undef GtkComboBox
#undef GtkBox
#undef GtkBuilder
#undef GtkProgressBar
#undef GtkIconSize
#undef GtkImage
#undef GtkDrawingArea
#undef GtkFrame
#undef GtkGrid
#undef GtkLabel
#undef GtkMisc
#undef GtkButton
#undef GtkWindowType
#undef GtkWindow
#undef GtkBin
#undef GtkContainer
#undef GtkAlign
#undef GtkWidget

#define native_is_gtk_type_named(x,y) g_type_is_a(G_OBJECT_TYPE(x), g_type_from_name(y))
