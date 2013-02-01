#===================================================================================================================================
all    : tests libgtk
webkit : testwebkit libwebkit
extra  : extras

#===================================================================================================================================
# Linux
EXTSHARED=.so
EXTBINARY=.bin
#--------------------------------------------------
# Windows
#EXTSHARED=.dll
#EXTBINARY=.exe
#--------------------------------------------------
# Common
LIBATROPINE=../atropine/libatropine$(EXTSHARED)

#===================================================================================================================================
tests : test00 test01 test02 test03 test04 test05 test06 test08 test09 test10 test11

test00 : tests/test00.o libgtk
	clang tests/test00.o src/Gtk*.o -o tests/test00$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test01 : tests/test01.o libgtk
	clang tests/test01.o src/Gtk*.o -o tests/test01$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test02 : tests/test02.o libgtk
	clang tests/test02.o src/Gtk*.o -o tests/test02$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test03 : tests/test03.o libgtk
	clang tests/test03.o src/Gtk*.o -o tests/test03$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test04 : tests/test04.o libgtk
	clang tests/test04.o src/Gtk*.o -o tests/test04$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test05 : tests/test05.o libgtk
	clang tests/test05.o src/Gtk*.o -o tests/test05$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test06 : tests/test06.o libgtk
	clang tests/test06.o src/Gtk*.o -o tests/test06$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test08 : tests/test08.o libgtk
	clang tests/test08.o src/Gtk*.o -o tests/test08$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test09 : tests/test09.o libgtk
	clang tests/test09.o src/Gtk*.o -o tests/test09$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test10 : tests/test10.o libgtk
	clang tests/test10.o src/Gtk*.o -o tests/test10$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

test11 : tests/test11.o libgtk
	clang tests/test11.o src/Gtk*.o -o tests/test11$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0` `objfw-config --libs`

#===================================================================================================================================
testwebkit : libwebkit test07

test07 : tests/test07.o libgtk libwebkit
	clang tests/test07.o src/Gtk*.o src/WebKit*.o -o tests/test07$(EXTBINARY) -I./ -I../ $(LIBATROPINE) `pkg-config --libs gtk+-3.0 webkitgtk-3.0` `objfw-config --libs`	

#===================================================================================================================================
extras : OFRegexTester

OFRegexTester : extras/OFRegexTester.o libgtk
	clang extras/OFRegexTester.o libadenosine$(EXTSHARED) $(LIBATROPINE) ../../OFExtensions/OFRegex.o -o extras/OFRegexTester$(EXTBINARY) -I./ -I../ -I../../OFExtensions `pkg-config --libs gtk+-3.0` `objfw-config --libs` -lpcre

extras/OFRegexTester.o : extras/OFRegexTester.m
	clang -c extras/OFRegexTester.m -o extras/OFRegexTester.o -I./ -I../ -I../../OFExtensions `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
libgtk : objgtk
	ar rcs libadenosine.a src/*.o
	clang -shared $(LIBATROPINE) src/*.o -o libadenosine$(EXTSHARED) `objfw-config --libs` `pkg-config --libs gtk+-3.0`

objgtk : src/GtkAdjustment.o       \
         src/GtkBin.o              \
         src/GtkBox.o              \
         src/GtkBuilder.o          \
         src/GtkButton.o           \
         src/GtkComboBox.o         \
         src/GtkComboBoxText.o     \
         src/GtkContainer.o        \
         src/GtkDialog.o           \
         src/GtkDialogMessage.o    \
         src/GtkDrawingArea.o      \
         src/GtkEntry.o            \
         src/GtkEntryBuffer.o      \
         src/GtkEventBox.o         \
         src/GtkFontButton.o       \
         src/GtkFrame.o            \
         src/GtkGrid.o             \
         src/GtkImage.o            \
         src/GtkLabel.o            \
         src/GtkLayout.o           \
         src/GtkListBox.o          \
         src/GtkMenu.o             \
         src/GtkMenuBar.o          \
         src/GtkMenuCheck.o        \
         src/GtkMenuImage.o        \
         src/GtkMenuItem.o         \
         src/GtkMenuRadio.o        \
         src/GtkMenuSeparator.o    \
         src/GtkMenuShell.o        \
         src/GtkMisc.o             \
         src/GtkNotebook.o         \
         src/GtkProgressBar.o      \
         src/GtkRuntime.o          \
         src/GtkScrolledWindow.o   \
         src/GtkTextBuffer.o       \
         src/GtkTextChildAnchor.o  \
         src/GtkTextIterator.o     \
         src/GtkTextMark.o         \
         src/GtkTextSearchResult.o \
         src/GtkTextTag.o          \
         src/GtkTextTagTable.o     \
         src/GtkTextView.o         \
         src/GtkViewport.o         \
         src/GtkWidget.o           \
         src/GtkWindow.o

#===================================================================================================================================
libwebkit : objwebkit

objwebkit : src/WebKitWebView.o

src/WebKitWebView.o : src/WebKitWebView.m
	clang -c src/WebKitWebView.m -o src/WebKitWebView.o -I./ -I../ `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0 webkitgtk-3.0`

#===================================================================================================================================
%.o : %.m
	clang -c $^ -o $@ -I./ -I../ -fPIC `objfw-config --cflags --objcflags` `pkg-config --cflags gtk+-3.0`

#===================================================================================================================================
clean :
	rm -f *.a
	rm -f *$(EXTSHARED)
	rm -f src/*.o
	rm -f tests/*.o
	rm -f tests/*$(EXTBINARY)
	rm -f extras/*.o
	rm -f extras/*$(EXTBINARY)
	rm -f dump.png
