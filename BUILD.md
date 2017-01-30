The short version:

git clone http://github.com/StackIQ/stacki-kubernetes.git

cd stacki-kubernetes

make bootstrap

make

make manifest-check

stack add pallet build-stacki-kubernetes-master/stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso

stack enable pallet stacki-kubernetes
