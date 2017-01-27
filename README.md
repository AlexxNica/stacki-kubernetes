### Prologue
============

It may be turtles all the way down in some universes, but not in the data center world. At the bottom of every cloud is a 
bare metal turtle(&trade;<sup>?</sup>) holding up your VMs, containers, and apps. If you have to install 10 - 1000s of machines on a regular basis with heterogenous hardware and application stacks, you want to be able to automate that from one place, fast.

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.<sup name="a1">[1](#f1)</sup>

Stacki is an open-source system for automating deployment, scaling, and management of bare metal systems.<sup name="a2">[2](#f2)</sup> 

Stacki+Kubernetes, can deploy a Kubernetes stack on bare metal, in about the same time it takes to make a pot of coffee 
and drink the first couple of cups. <sup name="a3">[3](#f3)</sup>

### Introduction

The stacki-kubernetes pallet installed on top of Stacki, will give you a functioning Kubernetes cluster.

This is a Phase 1 project. A Phase 1 project for us means: it's going to work, at least as good as what you currently have, and possibly simpler or better than what you currently have,<sup name="a4">[4](#f4)</sup> but it will work. You'll be able to install backend nodes with the current stable version of Kubernetes and run your, or public, containers. 

### Requirements

As in, you need these to make this work. If you don't have all of these, it won't work.

- [stacki-os 3.2](https://s3.amazonaws.com/stacki/3.x/stacki-os-3.2-7.x.x86_64.disk1.iso)
- [CentOS-7.2](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-1511.iso)
- [CentOS-7.2 Updates](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.2-0.x86_64.disk1.iso)
- [stacki-docker](https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-1.13.0-7.x.x86_64.disk1.iso)
- [stacki-kubernetes](http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso)
- You'll need a spreadsheet, an example files in the document. Hopefully a link too.

You should download these. If you have a Stacki frontend up already, download these to /export which should be the biggest partition on the frontend.

### Versions (all latest stable)
- Docker 1.13
- Kubernetes 1.5.2
- etcd 3.1.0
- flannel 0.7.0

This is the current default stack. Phase 1 only uses these. Phase 2 will have more options. See the Caveats section.

### Caveats
This is what it doesn't have - yet. If you have opinions on what should be in Phase 2, make it know on the googlegroups or on the Stacki Slack channel.

- rkt (Really? Go away and leave me alone.)
- The only overlay network currently supported is flannel.
- No TLS, nothing secured except by your network. 
- docker registry runs with "--insecure-registry"
- No DevOps tools used, just straight kickstart. If you've seen 
The only service running in a container is a docker registry if you want it.

It's promiscuous: nothing is nailed down with tls certs yet, or put it on a closed network, but that brings it's own challenges.

### tl;dr

<h6>Footnotes:</h6>

<sup name="f1">[1](#a1)</sup> I stole this quote from the front page of here: https://kubernetes.io/. I could have mitigated this by using "" to quote it, but I need my little thrills, so I stole it.

<sup name="f2">[2](#a2)</sup> Did you see what I did there? I plagarized 93% of the above footnote which I had previously plagarized.

<sup name="a3">[3](#f3)</sup> Really, mostly if you have your act together and read this documentation. The first few times you install Stacki, it's not gonna do what you think it should. There's a learning curve, though not as steep as Cobbler/Satellite/Spacewalk, or, my God, Ironic. 

<sup name="a4">[4](#f4)</sup> If you currently have nothing, this will definitely work better than what you have. 
