#
# Makefile for fbv
#

include Make.conf

CC      = gcc
CFLAGS  = -O2 -Wall -D_GNU_SOURCE -static
CFLAGS += `pkgconf --cflags libpng libjpeg`
LIBS   += `pkgconf --static --libs libpng libjpeg` -lgif -lz -lm

SOURCES = main.c jpeg.c gif.c png.c bmp.c fb_display.c transforms.c
OBJECTS = ${SOURCES:.c=.o}

OUT     = fbv

all: $(OUT)
	@echo Build DONE.

$(OUT): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT) $(OBJECTS) $(LIBS)

clean:
	rm -f $(OBJECTS) *~ $$$$~* *.bak core config.log $(OUT)

distclean: clean
	@echo -e "error:\n\t@echo Please run ./configure first..." >Make.conf
	rm -f $(OUT) config.h

install: $(OUT)
	mkdir -p $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(mandir)/man1
	cp $(OUT) $(DESTDIR)$(bindir)
	gzip -9c $(OUT).1 > $(DESTDIR)$(mandir)/man1/$(OUT).1.gz

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(OUT)
	rm -f $(DESTDIR)$(mandir)/man1/$(OUT).1.gz
