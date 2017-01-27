export KUBE_ROOT=/opt/kubernetes

if [ -d $KUBE_ROOT/bin ]; then
    export PATH=$PATH:$KUBE_ROOT/bin
fi

if [ -d $KUBE_ROOT/sbin ]; then
    export PATH=$PATH:$KUBE_ROOT/sbin
fi
