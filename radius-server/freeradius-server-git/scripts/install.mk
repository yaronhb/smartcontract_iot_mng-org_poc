# boilermake: A reusable, but flexible, boilerplate Makefile.
#
# Copyright 2008, 2009, 2010 Dan Moulding, Alan T. DeKok
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# ADD_INSTALL_RULE.* - Parameterized "functions" that adds a new
#   installation to the Makefile.  There should be one ADD_INSTALL_RULE
#   definition for each type of target that is used in the build.
#
#   New rules can be added by copying one of the existing ones, and
#   replacing the line after the "mkdir"
#

#
#  You can watch what it's doing by:
#
#	$ VERBOSE=1 make ... args ...
#
ifeq "${VERBOSE}" ""
    Q=@
else
    Q=
endif

# ADD_INSTALL_RULE.exe - Parameterized "function" that adds a new rule
#   and phony target for installing an executable.
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.exe
    ALL_INSTALL += $${${1}_INSTALLDIR}/$(notdir ${1})

    # Global install depends on ${1}
    install: $${${1}_INSTALLDIR}/$(notdir ${1})

    # Install executable ${1}
    $${${1}_INSTALLDIR}/$(notdir ${1}): ${JLIBTOOL} $${${1}_BUILD}/${1} | $${${1}_INSTALLDIR}
	@$(ECHO) INSTALL ${1}
	$(Q)$${PROGRAM_INSTALL} -c -m 755 $${BUILD_DIR}/bin/${1} $${${1}_INSTALLDIR}/
	$(Q)$${${1}_POSTINSTALL}

endef

# ADD_INSTALL_RULE.bin - Parameterized "function" that adds a new rule
#   and phony target for installing an executable into the "bin" directory
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.bin
    ALL_INSTALL += ${R}${bindir}/$(notdir ${1})

    # Global install depends on ${1}
    install: ${R}${bindir}/$(notdir ${1})

    # Install executable ${1}
    ${R}${bindir}/$(notdir ${1}): ${1} | ${R}${bindir}/
	@$(ECHO) INSTALL $(notdir ${1})
	$(Q)$${PROGRAM_INSTALL} -c -m 755 ${1} ${R}${bindir}/
endef

# ADD_INSTALL_RULE.a - Parameterized "function" that adds a new rule
#   and phony target for installing a static library
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.a
    ALL_INSTALL += $${${1}_INSTALLDIR}/$(notdir ${1})

    # Global install depends on ${1}
    install: $${${1}_INSTALLDIR}/$(notdir ${1})

    # Install static library ${1}
    $${${1}_INSTALLDIR}/$(notdir ${1}): ${JLIBTOOL} ${1} | $${${1}_INSTALLDIR}
	@$(ECHO) INSTALL ${1}
	$(Q)$${PROGRAM_INSTALL} -c -m 755 $${BUILD_DIR}/lib/${1} $${${1}_INSTALLDIR}/
	$(Q)$${${1}_POSTINSTALL}

endef

# ADD_INSTALL_RULE.la - Parameterized "function" that adds a new rule
#   and phony target for installing a libtool library
#
#   FIXME: The libtool install *also* installs a bunch of other files.
#          ensure that those are removed, too.
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.la
    ALL_INSTALL += $${${1}_INSTALLDIR}/$(notdir ${1})

    # Global install depends on ${1}
    install: $${${1}_INSTALLDIR}/$(notdir ${1})

    # Install libtool library ${1}
    $${${1}_INSTALLDIR}/$(notdir ${1}): ${JLIBTOOL} $${${1}_BUILD}/${1} | $${${1}_INSTALLDIR}
	@$(ECHO) INSTALL ${1}
	$(Q)$${PROGRAM_INSTALL} -c -m 755 $${LOCAL_FLAGS_MIN} $${BUILD_DIR}/lib/${1} $${${1}_INSTALLDIR}/
	$(Q)$${${1}_POSTINSTALL}

endef

# ADD_INSTALL_RULE.man - Parameterized "function" that adds a new rule
#   and phony target for installing a "man" page.  It will take care of
#   installing it into the correct subdirectory of "man".
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.man
    ALL_INSTALL += ${2}/$(notdir ${1})

    # Global install depends on ${1}
    install: ${2}/$(notdir ${1})

    # Install manual page ${1}
    ${2}/$(notdir ${1}): ${JLIBTOOL} ${1} | ${2}
	@$(ECHO) INSTALL $(notdir ${1})
	$(Q)$${PROGRAM_INSTALL} -c -m 644 ${1} ${2}/

endef

# ADD_INSTALL_RULE.file - Parameterized "function" that adds a new rule
#   and phony target for installing a file.
#
#   ${1} = file to install
#   ${2} = destination where it is installed
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.file
    ALL_INSTALL += ${2}

    # Global install depends on the installed file
    install: ${2}

    # Install the file
    ${2}: ${1} | $(patsubst %/,%,$(dir ${2}))
	@$(ECHO) INSTALL ${1}
	$(Q)$${PROGRAM_INSTALL} -c -m 644 ${1} ${2}

endef


# ADD_INSTALL_RULE.h - Parameterized "function" that adds a new rule
#   and phony target for installing a header file.
#
#  Note that we re-write the header files to get rid of
#  "freeradius-devel" and replace it with "freeradius"
#
#  install-sh function for creating directories gets confused
#  if there's a trailing slash, tries to create a directory
#  it already created, and fails...
#
# ${1} = filename where it will be installed
# ${2} = filename in the source
#
#  Because things in .../src/lib/io/foo.h go into .../io/foo.h
#
#  For 'sed', the expression must deal with indentation after the hash
#  and copy it to the substitution string.  The hash is not anchored
#  in order to allow substitution in function documentation.
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.h
    ALL_INSTALL += $(DESTDIR)/${includedir}/${PROJECT_NAME}/${1}

    install: $(DESTDIR)/${includedir}/${PROJECT_NAME}/${1}

    $(DESTDIR)/${includedir}/${PROJECT_NAME}/${1}: ${2}
	${Q}echo INSTALL ${1}
	${Q}$(INSTALL) -d -m 755 `echo $$(dir $$@) | sed 's/\/$$$$//'`
	${Q}sed -e 's/#\([\\t ]*\)include <${PROJECT_NAME}-devel\/\([^>]*\)>/#\1include <${PROJECT_NAME}\/\2>/g' < $$< > $$@
	${Q}chmod 644 $$@
endef

# ADD_INSTALL_RULE.dir - Parameterized "function" that adds a new rule
#   and phony target for installing a directory
#
#   We would like to have this directory have an order dependency on it's parent:
#
#	| $(dir $(patsubst %/,%,$(dir ${1})))
#
#  but ONLY to the root of the directory we're installing.  There's no simple way
#  to get at that information right now, so we'll ignore it.  Until that's fixed,
#  doing "make -j 14 install.doc" will get a series of complaints about
#
#	"mkdir: foo: File exists"
#
#  but ONLY once for each directory.
#
#   USE WITH EVAL
#
define ADD_INSTALL_RULE.dir
    # Install directory
    .PHONY: ${1}
    ${1}: ${JLIBTOOL}
	@$(ECHO) INSTALL -d -m 755 ${1}
	$(Q)$${PROGRAM_INSTALL} -d -m 755 ${1}
endef


# ADD_INSTALL_TARGET - Parameterized "function" that adds a new rule
#   which installs everything for the target.
#
#   USE WITH EVAL
#
define ADD_INSTALL_TARGET
    # Figure out which target rule to use for installation.
    ifeq "$${${1}_SUFFIX}" ".exe"
        ifeq "$${TGT_INSTALLDIR}" ".."
            TGT_INSTALLDIR := $${bindir}
        endif
    else
        ifeq "$${TGT_INSTALLDIR}" ".."
            TGT_INSTALLDIR := $${libdir}
        endif
    endif

    # add rules to install the target
    ifneq "$${TGT_INSTALLDIR}" ""
        ${1}_INSTALLDIR := $${DESTDIR}$${TGT_INSTALLDIR}

        $$(eval $$(call ADD_INSTALL_RULE$${${1}_SUFFIX},${1}))
    endif

    # add rules to install the MAN pages.
    ifneq "$$(strip $${${1}_MAN})" ""
        ifeq "$${mandir}" ""
            $$(error You must define 'mandir' in order to be able to install MAN pages.)
        endif

        MAN := $$(call QUALIFY_PATH,$${DIR},$${MAN})
        MAN := $$(call CANONICAL_PATH,$${MAN})

        $$(foreach PAGE,$${MAN},\
            $$(eval $$(call ADD_INSTALL_RULE.man,$${PAGE},\
              $${DESTDIR}$${mandir}/man$$(subst .,,$$(suffix $${PAGE})))))
    endif
endef

.PHONY: install
install:

ALL_INSTALL :=

# Define reasonable defaults for all of the installation directories.
# The user can over-ride these, but these are the defaults.
ifeq "${prefix}" ""
    prefix = /usr/local
endif
ifeq "${exec_prefix}" ""
    exec_prefix = ${prefix}
endif
ifeq "${bindir}" ""
    bindir = ${exec_prefix}/bin
endif
ifeq "${sbindir}" ""
    sbindir = ${exec_prefix}/sbin
endif
ifeq "${libdir}" ""
    libdir = ${exec_prefix}/lib
endif
ifeq "${sysconfdir}" ""
    sysconfdir = ${prefix}/etc
endif
ifeq "${localstatedir}" ""
    localstatedir = ${prefix}/var
endif
ifeq "${datarootdir}" ""
    datarootdir = ${prefix}/share
endif
ifeq "${datadir}" ""
    datadir = ${prefix}/share
endif
ifeq "${mandir}" ""
    mandir = ${datadir}/man
endif
ifeq "${docdir}" ""
    docdir = ${datadir}/doc/${PROJECT_NAME}
endif
ifeq "${logdir}" ""
    logdir = ${localstatedir}/log/
endif
ifeq "${includedir}" ""
    includedir = ${prefix}/include/${PROJECT_NAME}
endif


# Un-install any installed programs.  We DON'T want to depend on the
# install target.  Doing so would cause "make uninstall" to build it,
# install it, and then remove it.
#
# We also want to uninstall only when there are "install_foo" targets.
.PHONY: uninstall
uninstall:
	$(Q)rm -f ${ALL_INSTALL} ./.no_such_file

# Wrapper around INSTALL
ifeq "${PROGRAM_INSTALL}" ""
    PROGRAM_INSTALL := ${INSTALL}

endif

# Make just the installation directories
.PHONY: installdirs
installdirs:

# Be nice to the user.  If there is no INSTALL program, then print out
# a helpful message.  Without this check, the "install" rules defined
# above would try to run a command-line with a blank INSTALL, and give
# some inscrutable error.
ifeq "${INSTALL}" ""
install: install_ERROR

.PHONY: install_ERROR
install_ERROR:
	@$(ECHO) Please define INSTALL in order to enable the installation rules.
	$(Q)exit 1
endif
