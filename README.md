Hey, if you just showed up here this weekend. The docs are still being written, because, well, you know. Check on Monday.


### tl;dr
Really? You don't want to read this? It's the best README you'll ever encounter. 

Ok, fine.

Download these;

Install them

Enable them

Add spreadsheet.

Install backend nodes.



### Prologue
============

It may be turtles all the way down in some universes, but not in the data center world. At the bottom of every cloud is a 
bare metal turtle(&trade;<sup>?</sup>) holding up your VMs, containers, and apps. If you have to install 10 - 1000s of machines on a regular basis with heterogenous hardware and application stacks, you want to be able to automate that from one place, fast.

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.<sup name="a1">[1](#f1)</sup>

Stacki is an open-source system for automating deployment, scaling, and management of bare metal systems.<sup name="a2">[2](#f2)</sup> 

Stacki+Kubernetes, can deploy a Kubernetes stack on bare metal, in about the same time it takes to make a pot of coffee 
and drink the first couple of cups. <sup name="a3">[3](#f3)</sup>

### Introduction

The stacki-kubernetes pallet installed on top of Stacki, will give you a functioning Kubernetes cluster with a kubernetes-dashboard deployment if you request it. 

This is a Phase 1 project. A Phase 1 project for us means: it's going to work, at least as good as what you currently have, and possibly simpler or better than what you currently have,<sup name="a4">[4](#f4)</sup> but it will work. You'll be able to install backend nodes with the current stable version of Kubernetes and run your, or public, containers. 

### Requirements

As in, you need these to make this work. If you don't have all of these, it won't work.

- [stacki-os-3.2](https://s3.amazonaws.com/stacki/3.x/stacki-os-3.2-7.x.x86_64.disk1.iso) (If you already have a Stacki 3.2 frontend up, you don't need this again.)
- [CentOS-7.2](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-1511.iso)
- [CentOS-7.2 Updates](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.2-0.x86_64.disk1.iso)
- [stacki-docker](https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-1.13.0-7.x.x86_64.disk1.iso)
- [stacki-kubernetes](http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso)
- You'll need a spreadsheet, an example files in the document. Hopefully a link too.

You should download these. If you have a Stacki frontend up already, download these to /export which should be the biggest partition on the frontend.

### Versions (all latest stable)
- Docker 1.13 (It's in the stacki-docker pallet.)
- Kubernetes 1.5.2
- etcd 3.1.0
- flannel 0.7.0

This is the current default stack. Docker 1.13 is in the stacki-docker pallet which is why you need it. Everything else for Kubernetes is in the stacki-kubernetes pallet. Phase 1 only uses these versions. Phase 2 will have more options. See the Caveats section for what you may need but this may not have.

### Caveats
This is what it doesn't have - yet. If you have opinions on what should be in Phase 2, make it known on the googlegroups or on the Stacki Slack channel.

- rkt (Really? Go away and leave me alone.)
- The only overlay network currently supported is flannel.
- No TLS, nothing secured except by your network. 
- docker registry runs with "--insecure-registry"
- No DevOps tools used, just straight kickstart.<sup name="a5">[5](#f5)</sup> So if you've seen the Stacki+Kubernetes+Salt video demo, that's not valid anymore. Salt is not in Stacki unless you put it there. 
- The only service running in a container is a docker registry if you want it.

## Installing Kubernetes

### Prepare the stacki frontend

The installation of Kubernetes and subsequent deployment of you cluster requires:

* A working stacki frontend with nodes installed.
* The stacki-docker pallet
* The stacki-kubernetes pallet
* The CentOS-7.2 and CentOS-updates pallets.

Luckily, we have made this easy for you.

1. First install a stacki frontend.
This has been documented [before](https://github.com/StackIQ/stacki/wiki/Frontend-Installation). If you're on this documentation, 
you have already installed a frontend. If you are here without a stacki frontend. Go install one. Then come back. 
I can wait...(Are we there yet?)

2. Install the pallets.
On your frontend, either download, or add/enable if they have been downloaded already.

If downloading to the frontend:
```
# cd /export

# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-1511.iso 
# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.2-0.x86_64.disk1.iso
# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-1.13.0-7.x.x86_64.disk1.iso 
# wget --no-check-certificate http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso 
```

Either all at once or one at a time.

Check the md5sums.
```
# md5sum stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso stacki-docker-1.13.0-7.x.x86_64.disk1.iso
```

against the following:

cc4eac50e97dc0169751a2267409b00e  stacki-docker-1.13.0-7.x.x86_64.disk1.iso
eaee67dc91ad35ebf6a5525e84747661  stacki-kubernetes-1.5.2-7.x_p1.x86_64.disk1.iso

Add and enable the pallets:
```
Add the pallets:

# stack add pallet stacki-*iso CentOS*.iso
# stack list pallet 

to make sure everything is present.

Then enable the pallets
# stack enable pallet CentOS CentOS-Updates stacki-docker stacki-kubernetes

You MUST disable the OS pallet:

# stack disable pallet os

```

A pallet generally has both frontend and backend configuration. To get the frontend configuration to happen for a pallet that contains it, run the pallet:
```
# stack run pallet stacki-kubernetes
```
To see what scripts are going to run. 

Then run it for real:
```
# stack run pallet stacki-kubernetes | bash
```
### Preparing backend nodes.

It's our assumption that you have already installed backend nodes with Stacki. Now you want Kubernetes, and you're going to reinstall the backend nodes. Yes, you are, or you're going to look for a different solution.

If you haven't installed backend nodes, I highly recommend installing them with the base installation to shake out any hardware problems and know that they are going to work. Do this before enabling the stacki-docker and stacki-kubernetes pallets. You don't have to, but it's highly recommended. Then install them after adding a spreadsheet for some required attributes, and reinstall them. The reinstalling them is the short part of this.

If you haven't installed backend, and you have a host spreadsheet. (See the [Backend Install](https://github.com/StackIQ/stacki/wiki/Backend-Installation) section of our docs.) You can add the following attrfile before installation, but there's more to troubleshoot if something goes wrong. 

So in any event, we assume you have backend nodes. They don't have kubernetes on them and you're going to reinstall. 

Do the following:

Get the example spreadsheet file from the repository:
```
wget stacki-kubernetes/spreadsheets/kubernetes-attrs.csv
```
Open it with your favorite editor or Excel/Libre Office/etc.

It looks like [this](./stacki-kubernetes/spreadsheets/kubernetes-attrs.csv)


<h6>Footnotes:</h6>

<sup name="f1">[1](#a1)</sup> I stole this quote from the front page of here: https://kubernetes.io/. I could have mitigated this by using "" to quote it, but I need my little thrills, so I stole it.

<sup name="f2">[2](#a2)</sup> Did you see what I did there? I plagarized 93% of the above footnote which I had previously plagarized.

<sup name="f3">[3](#a3)</sup> Really, mostly if you have your act together and read this documentation. The first few times you install Stacki, it's not gonna do what you think it should. There's a learning curve, though not as steep as Cobbler/Satellite/Spacewalk, or, my God, Ironic. 

<sup name="f4">[4](#a4)</sup> If you currently have nothing, this will definitely work better than what you have. 

<sup name="f5">[5](#a5)</sup> If you've seen any of the Kubernetes documentation, there are multiple ways to skin this particular software cat. We aren't doing those. If you want, you can just use Stacki to get the machines to a ping and a prompt and then use another/other tools for deploying Kubernetes. But then, you're not running it on bare metal anymore if that's a priority for you.
