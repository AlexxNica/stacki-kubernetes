#@SI_Copyright
#@SI_Copyright
setenv KUBE_ROOT /opt/kubernetes

if ( -d $KUBE_ROOT/bin ) then
    setenv PATH "${PATH}:$KUBE_ROOT/bin"
endif

if ( -d $KUBE_ROOT/sbin ) then
    setenv PATH "${PATH}:$KUBE_ROOT/sbin"
endif

