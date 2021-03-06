#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2016 Gordon W. Ross
#

PROG= \
	modetest

# from Makefile.in MODETEST_FILES
TEST_OBJS= \
	modetest.o \
	buffers.o \
	cursor.o

include	../../Makefile.drm

SRCDIR= $(LIBDRM_CMN_DIR)/tests/$(PROG)

LDLIBS	 +=	-ldrm -lm -lcairo

LDLIBS32 +=	$(LIBUTIL32) \
		-L$(ROOT)/usr/lib/xorg \
		-R/usr/lib/xorg
LDLIBS64 +=	$(LIBUTIL64) \
		-L$(ROOT)/usr/lib/xorg/$(MACH64) \
		-R/usr/lib/xorg/$(MACH64)

all:	 $(PROG)

#This is in the lower Makefile
#install:	$(ROOTCMD)

lint:

clean:     
	$(RM) $(PROG:%=%.o) $(TEST_OBJS)

$(PROG) : $(TEST_OBJS)
	$(LINK.c) -o $@ $(TEST_OBJS) $(LDLIBS)

%.o : $(SRCDIR)/%.c
	$(COMPILE.c) -o $@ -c $<

.KEEP_STATE:

include	../../../Makefile.targ
