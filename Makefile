#===================================================================================================================================
all : tests libgtk libwebkit

#===================================================================================================================================
tests : test00 test01 test02 test03 test04 test05 test06 test07 test08 test09 test10

test00 : test00.o libgtk
	clang test00.o Gtk*.o -o test00.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test01 : test01.o libgtk
	clang test01.o Gtk*.o -o test01.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test02 : test02.o libgtk
	clang test02.o Gtk*.o -o test02.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test03 : test03.o libgtk
	clang test03.o Gtk*.o -o test03.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test04 : test04.o libgtk
	clang test04.o Gtk*.o -o test04.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test05 : test05.o libgtk
	clang test05.o Gtk*.o -o test05.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test06 : test06.o libgtk
	clang test06.o Gtk*.o -o test06.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test07 : test07.o libgtk libwebkit
	clang test07.o Gtk*.o WebKit*.o -o test07.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0 webkitgtk-3.0` `objfw-config --libs`	

test08 : test08.o libgtk
	clang test08.o Gtk*.o -o test08.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test09 : test09.o libgtk
	clang test09.o Gtk*.o -o test09.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test10 : test10.o libgtk
	clang test10.o Gtk*.o -o test10.bin -I../ ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs`

#===================================================================================================================================
# these tests may require more configuration and external libraries
# they're included for reference only, and not required for a "make all"
# maybe the WebKit section should be in here?
extest00 : extest00.o libgtk
	clang extest00.o Gtk*.o ../../ofextensions/OFRegex.o -o extest00.bin -I../ -I../../ofextensions ../atropine/libatropine.so `pkg-config --libs gtk+-3.0` `objfw-config --libs` -lpcre

extest00.o : extest00.m
	clang -c extest00.m -o extest00.o -I../ -I../../ofextensions `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
libgtk : objgtk

objgtk : GtkBin.o              \
         GtkBox.o              \
         GtkBuilder.o          \
         GtkButton.o           \
         GtkComboBox.o         \
         GtkComboBoxText.o     \
         GtkContainer.o        \
         GtkDialog.o           \
         GtkDialogMessage.o    \
         GtkDrawingArea.o      \
         GtkEntry.o            \
         GtkEntryBuffer.o      \
         GtkFrame.o            \
         GtkGrid.o             \
         GtkImage.o            \
         GtkLabel.o            \
         GtkMenu.o             \
         GtkMenuBar.o          \
         GtkMenuCheck.o        \
         GtkMenuImage.o        \
         GtkMenuItem.o         \
         GtkMenuRadio.o        \
         GtkMenuSeparator.o    \
         GtkMenuShell.o        \
         GtkMisc.o             \
         GtkNotebook.o         \
         GtkProgressBar.o      \
         GtkRuntime.o          \
         GtkScrolledWindow.o   \
         GtkTextBuffer.o       \
         GtkTextChildAnchor.o  \
         GtkTextIterator.o     \
         GtkTextMark.o         \
         GtkTextSearchResult.o \
         GtkTextTag.o          \
         GtkTextTagTable.o     \
         GtkTextView.o         \
         GtkViewport.o         \
         GtkWidget.o           \
         GtkWindow.o

#===================================================================================================================================
libwebkit : objwebkit

objwebkit : WebKitWebView.o

WebKitWebView.o : WebKitWebView.m
	clang -c WebKitWebView.m -o WebKitWebView.o -I ../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0 webkitgtk-3.0`

#===================================================================================================================================
%.o : %.m
	clang -c $^ -o $@ -I../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
clean :
	rm -f *.a
	rm -f *.bin
	rm -f *.o
	rm -f dump.png
