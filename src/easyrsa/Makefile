# @SI_Copyright@
# @SI_Copyright@

PKGROOT		= /opt/kubernetes
ROLLROOT	= ../..
URL		= https://storage.googleapis.com/golang
export GOPATH	= $(shell pwd)/work
export GOROOT	= $(shell pwd)/go

include $(STACKBUILD)/etc/CCRules.mk

refresh::
	curl -L -O https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz

build::
	tar -xzvf easy-rsa.tar.gz

install::
	mkdir -p $(ROOT)$(PKGROOT)
	cp -a easy-rsa-master/easyrsa3 $(ROOT)$(PKGROOT)

clean::
	rm -fr go $(GOPATH)
