# @SI_Copyright@
# @SI_Copyright@

PKGROOT         = /opt/kubernetes/bin
ROLLROOT	= ../..
URL		= https://github.com/coreos/$(NAME)/releases/download/
RURL		= https://github.com/coreos/$(NAME)/releases/latest
GOTAR		= go1.8.linux-amd64.tar.gz
GOURL 		= https://storage.googleapis.com/golang

include $(STACKBUILD)/etc/CCRules.mk

build::
	if [ ! -e ./$(GOTAR) ]; then \
		wget --no-check-certificate $(GOURL)/$(GOTAR); \
	fi
	if [ ! -d /usr/local/go ]; then \
		tar -xzvf $(GOTAR) -C /usr/local; \
	fi
	if [ ! -h /usr/local/bin ]; then \
		ln -s /usr/local/go/bin/go /usr/local/bin/go; \
	fi
	go get -u github.com/cloudflare/cfssl/cmd/cfssl
	go get -u github.com/cloudflare/cfssl/cmd/...

install::
	mkdir -p $(ROOT)$(PKGROOT)
	$(INSTALL) ./go/bin/* $(ROOT)$(PKGROOT)

clean::
	rm -f /usr/local/bin/go
	rm -fr /usr/local/go
	rm -fr go
