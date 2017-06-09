# @SI_Copyright@
# @SI_Copyright@

PKGROOT         = /opt/kubernetes/bin
TGZ 		= tar.gz
ROLLROOT	= ../..
TARFILE 	= $(NAME)-$(VERSION)-linux-amd64.$(TGZ)
URL		= https://github.com/coreos/flannel/releases/download/
RURL		= https://github.com/coreos/flannel/releases/latest
SHAREDOCDIR	= /usr/share/doc/$(NAME)/
SHAREDIR	= /usr/share/$(NAME)/
TGZNAME		= $(NAME)-$(VERS)-linux-amd64.$(TGZ)
include $(STACKBUILD)/etc/CCRules.mk

VERS=$(shell curl -s -k $(RURL) | sed "s/.*\(v.*\)\".*/\1/g")

refresh::
	rm -f $(NAME)*-linux-amd64.$(TGZ)
	(						\
		echo "NAME=flannel" > version.mk;	\
		echo "VERSION=$(VERS)" >> version.mk;	\
	)
	
	wget --no-check-certificate -O $(TGZNAME) $(URL)$(VERS)/$(TGZNAME)

build:
	tar -xf $(TARFILE)

install::
	mkdir -p $(ROOT)$(PKGROOT)
	mkdir -p $(ROOT)$(SHAREDIR)
	mkdir -p $(ROOT)$(SHAREDOCDIR)
	mkdir -p $(ROOT)/$(PKGROOT)/share/licenses/
	
	$(INSTALL) -m0755 flanneld $(ROOT)$(PKGROOT)
	$(INSTALL) -m0644 mk-docker-opts.sh $(ROOT)$(SHAREDIR)
	$(INSTALL) -m0644 README.md $(ROOT)$(SHAREDOCDIR)

	( \
		cd LICENSE; \
		find . -type f | cpio -pudv $(ROOT)/$(PKGROOT)/share/licenses/; \
	)

clean::
