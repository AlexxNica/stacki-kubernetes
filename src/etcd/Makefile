# @SI_Copyright@
# @SI_Copyright@

PKGROOT         = /opt/kubernetes/bin
TGZ 		= tar.gz
ROLLROOT	= ../..
URL		= https://github.com/coreos/$(NAME)/releases/download/
RURL		= https://github.com/coreos/$(NAME)/releases/latest
SHAREDOCDIR	= /usr/share/doc/$(NAME)/
TGZNAME		= $(NAME)-$(VERSION)-linux-amd64.$(TGZ)
TARDIR		= $(NAME)-$(VERSION)-linux-amd64

include $(STACKBUILD)/etc/CCRules.mk

VERS=$(shell curl -s -k $(RURL) | sed "s/.*\(v.*\)\".*/\1/g")

refresh::
	rm -f $(NAME)*-linux-amd64.$(TGZ)
	(						\
		echo "NAME=etcd" > version.mk;		\
		echo "VERSION=$(VERS)" >> version.mk;	\
	)
	
	wget --no-check-certificate -O $(TGZNAME) $(URL)$(VERS)/$(TGZNAME)

build::
	tar -xf $(TGZNAME)

install::
	mkdir -p $(ROOT)$(PKGROOT)
	mkdir -p $(ROOT)$(SHAREDOCDIR)
	
	$(INSTALL) -m0755 $(TARDIR)/etcd $(ROOT)$(PKGROOT)
	$(INSTALL) -m0755 $(TARDIR)/etcdctl $(ROOT)$(PKGROOT)
	cp $(TARDIR)/README* $(ROOT)$(SHAREDOCDIR)
	cp -a $(TARDIR)/Documentation/* $(ROOT)$(SHAREDOCDIR)

clean::
