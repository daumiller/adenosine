//==================================================================================================================================
// WebKitNative.h
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

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

#define WebKitWebView            Native_WebKitWebView
#define WebKitNavigationResponse Native_WebKitNavigationResponse
#define WebKitWebViewTargetInfo  Native_WebKitWebViewTargetInfo
#define WebKitWebViewViewMode    Native_WebKitWebViewViewMode
#define WebKitLoadStatus         Native_WebKitLoadStatus

#include <gtk/gtk.h>
#include <webkit/webkit.h>

#undef WebKitLoadStatus
#undef WebKitWebViewViewMode
#undef WebKitWebViewTargetInfo
#undef WebKitNavigationResponse
#undef WebKitWebView

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
