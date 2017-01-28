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

If you haven't installed backend nodes, I highly recommend installing them with the base installation to shake out any hardware problems and know that they are going to work. Do this before enabling the stacki-docker and stacki-kubernetes pallets. You don't have to, but it's highly recommended. Then enable/re-enable stacki-kubernetes and stacki-docker after adding a spreadsheet for some required attributes, and reinstall the nodes. The reinstalling nodes is the short part of this.

If you haven't installed backend, and you have a host spreadsheet. (See the [Backend Install](https://github.com/StackIQ/stacki/wiki/Backend-Installation) section of our docs.) You  attrfile before installation, but there's more to troubleshoot if something goes wrong. 

So in any event, we assume you have backend nodes. They don't have kubernetes on them and you're going to reinstall. You have to add the following attr file. The hostnames may need to change because "backend-?-?" is the default and you may have different host names.

So to create your attrfile, just adapt the example here and add them. After the spreadsheet, we'll go through what this means. However, if this is the first time you've encountered a spreadsheet attribute file, go review this here which apparently I'm now writing also.

Do the following:

Get the example spreadsheet file from the repository:

```
wget https://github.com/StackIQ/stacki-kubernetes/blob/master/spreadsheets/kubernetes-attrs.csv
```
Open it with your favorite editor<sup name="a6">[6](#f6)</sup>, Excel/Libre Office/etc.

It looks like [this](https://github.com/StackIQ/stacki-kubernetes/blob/master/spreadsheets/kubernetes-attrs.csv)

|  target         | kube.master | kube.master_ip  | kube.minion | etcd.prefix     | etcd.cluster_member  | kube.enable_dashboard  | kube.pull_pods  | kube.pod_dir            | docker.registry.local | docker.registry.external | docker.overlay_disk  | sync.hosts |
| --------------- | ----------- | --------------- | ----------- | --------------- | -------------------- | ---------------------- | --------------- | ----------------------- | --------------------- | ------------------------ | -------------------- | ---------- |
| global      | False       | 10.1.255.254    | True        | /stacki/network | False                | False                  | True            | install/kubernetes/pods | False                 | True                     | sdb                  | True       |
| backend-0-0     | True        |                 |             |                 | True                 | True                   |                 |                         |                       |                          |                      |            |
| backend-0-1     |             |                 |             |                 | True                 |                        |                 |                         |                       |                          |                      |            |
| backend-0-2     |             |                 |             |                 | True                 |                        |                 |                         |                       |                          |                      |            |
| backend-0-3     |             |                 |             |                 |                      |                        |                 |                         |                       |                          |                      |            |
| backend-0-4     |             |                 |             |                 |                      |                        |                 |                         |                       |                          |                      |            |


The goal here is to edit this file so that it reflects your site and needs, not mine. Since there isn't currently a page to describe attributes and what they are used for, I will do so here.

Actually, I sum up, then I write the attributes documentation.

###### Sum up attributes

* Attributes in Stacki nomenclature are just key/value pairs stored in a database. 

* Stacki defines a set of attributes that are used in creating kickstart for backend nodes. It's why they are generated dynamically and can be different depending on the role a node might play. You can use these.

* Attributes can be arbitrarily created, meaning that you can create your own and use them for customization.

* Attributes can be set on the command line or in an attributes file.

* Attributes are inherited. The can be set at a global level, "G", an appliance level, "A", or individual host level, "B". The last one wins.

###### Attrfile example

We'll use the attribute file above to explain how attributes get into the database.

The first line is "target." This is the header in the csv file. The keyword "target" means that everything that follows on this line is the attribute name - it is the "key" part in the key/value pair.

The next line has a scope called "global." This means all the values after the word "global" are the default values of the key they map to in the above line, and they will be set at the global level. They apply to all nodes.

The next five lines are applicable to only the name of the node at the beginning of the line. We only change those values for any given host that are different from the global setting. This way we have less typing. If a value is not set, it gets the global value.

To add the attributes you load the attrfile after you edit it:

```
# stack load attrfile file=kubernetes.csv
```

You can also add/set attributes on the command line. The above file would look like this if we did it on the command line instead:
```
# stack add attr attr=docker.overlay_disk value=sdb
# stack add attr attr=docker.registry.external value=True
# stack add attr attr=docker.registry.local value=False
# stack add attr attr=etcd.cluster_member value=False
# stack add attr attr=etcd.prefix value=/stacki/network
# stack add attr attr=kube.enable_dashboard value=False
# stack add attr attr=kube.master value=False
# stack add attr attr=kube.master_ip value=10.1.255.254
# stack add attr attr=kube.minion value=True
# stack add attr attr=kube.pod_dir value=install.kubernetes.pods
# stack add attr attr=kube.pull_pods value=True
# stack add attr attr=ssh.use_dns value=false
# stack add attr attr=sync.hosts value=True
# stack add attr attr=user.auth value=unix
# stack add host attr backend-0-0 attr=etcd.cluster_member value=True
# stack add host attr backend-0-0 attr=kube.enable_dashboard value=True
# stack add host attr backend-0-0 attr=kube.master value=True
# stack add host attr backend-0-1 attr=etcd.cluster_member value=True
# stack add host attr backend-0-2 attr=etcd.cluster_member value=True
```

You can use "set" instead of "add." If the attribute doesn't exist if you use "set," it will be created. "add" just adds and sets.
Use "set" when you want to change an attribute but don't want to reload the attr file.

###### Kubernetes file detail

At this point we'll go through the keys we are using and I'll tell you what they are for. You'll need to configure these for your site and change them in the attrfile and then load it.

The format I'll discuss them in is:
```
Target = key name
Global Value = default global value 
Used for:
Hosts changed:
```

You'll notice that some values have booleans: True/false, and some have actual values. Generally, if an attribute is a boolean, it's used to fire some piece of code or not. If it's an actual value, it's likely going in a config file for some service on a backend node.
Booleans are cool because true/false/yes/no/y/n/1/0 all work and they can be capped, all-capped or not. 

So let's explicate:

```
Target = kube.master
Global Value = False
Used for: setting which node is the Kubernetes master. You need one.
Host change: backend-0-0 is the host master in this example, so the value for this is "True".
```
You must designate one host as the Kubernetes Master. The Kubernetes master runs more services than the other hosts. In this case, backend-0-0 is the master and so it will run all the kube master daemons: kube-apiserver, kube-controller-manager, kubelet, kube-dns, kube-proxy. 

You can actually designate any node in your cluster as the master. All machines get the same software, they just don't run all the same services.

```
Target = kube.master_ip
Global Value = 10.1.255.254
Used for: Telling all the other services where their master host is.
Host change: It's global, no need to change.
```
Yeah, no need to change. In the future I may calculate this for you, but maybe not. 

```
Target = kube.minion
Global Value = True
Used for: Not used, but I reserve the right too when we start splitting services.
Host change: None - leave as a global and True
```

```
Target = etcd.prefix
Global Value = /stacki/network
Used for: etcd key for network pairing
Host change: None - leave as a global
```

Etcd is a cluster-wide key/value pair shared among the nodes. The only value we set is the network and it's stored as "/stacki/network." You can change that if you wish and you know what you're doing.

```
Target = etcd.cluster_member
Global Value = False
Used for: Setting up etcd service
Host change: backend-0-0, 0-1, and 0-2. Set to True for these three nodes.
```
Etcd requires either that you have one etcd master with a storage backing store or 3, 5, or 7 etcd nodes in cluster. In this case, three nodes are designated to provide etcd redundancy. You can get away with one but we don't have a backing store in Phase 1. Phase 2 probably.

```
Target = kube.enable_dashboard
Global Value = False
Used for: Setting up the kubernetes-dashboard automatically
Host change: backend-0-0 is set to True.
```

The kubernetes-dashboard is a UI for deployment of containers, services, pods etc. It's pretty. It's helpful especially if you're new to this. But I think it's beta? Setting a node to True will put the kubernetes-dashboard automatically. You'll have to start it up. (See below.) I've put it on the master. Technically you can put it on any node, but I haven't tested that yet - Phase 2 is around the corner.

```
Target = kube.pull_pods
Global Value = True
Used for: pulling yaml files from the frontend for stuff you already have.
Host change: None - is a global set to "False" if you have no pods and aren't using the kubernetes-dashboard.
```

This is a pallet thing, not Kubernetes. I wanted to test both the dashboard and other pods and services I have without having to copy them to the node after every install. Since a Stacki frontend has a web server running for the backend node installation that's available at /var/www/html/install/ I put yaml in a directory and pull it during install.

```
Target = kube.pod_dir
Global Value = install/kubernetes/pods
Used for: 
Host change: 
```

This is default. It's created during a "stack run pallet stacki-kubernetes." If you want it elsewhere under /var/www/html/ then create the directory and change this attribute.

```
Target = docker.registry.local
Global Value = False
Used for: Setting up a docker registry on a closed cluster.
Host change: Global, either true or false
```

Oh this is a can of worms, and I don't like how I did it so it will be changing in Phase 2. If you have a completely closed cluster, meaning, backend nodes don't have an internet connection, then set this to True. We'll discuss the issues further below in the Docker section below.

```
Target = docker.registry.external
Global Value = True
Used for: everything that needs web connectivity
Host change: Global - change only if you have an off-line cluster.
```
If the frontend or all the backend nodes do have connectivty to the internet, then set this to True.

```
Target = docker.overlay_disk
Global Value = sdb
Used for:
Host change:
```
Worms, lots more worms. The overlayfs recommended by Docker is only in preview for CentOS 7.2 and 7.3, which is their way of saying: "It could work," and shrugging their shoulders. To work on XFS (our default), the filesystem needs to be created with "ftype=1" There are a couple of reasons this is problematic in Stacki 3.2 and CentOS 7.x using parted. Some of it is our fault, part of it not. There is a workaround, however. Define a disk by itself that will get the proper xfs ftype=1. Just name the disk, we do the rest. It defaults to sdb. If you have an SSD, use that because that's what's recommended.

I plan on fixing this soon, but it may require a point release to get that done. 

```
Target = sync.hosts
Global Value = True
Used for: syncing /etc/hosts to all backend nodes
Host change:
```
I do this because things just work better. 

##### Docker - we have to talk

Okay, with Docker there are two options: if no nodes don't have internet access, or if at least the frontend has internet access.

######### Cluster is private

If there are no nodes with internet access, set the docker.registry.local to True. This will create a registry on the master node. You can push docker images to this directory with "docker push master_ip:5000/imagename" and it will work.

To get the kubernetes-dashboard up on a closed network, several docker images have been pre-created and installed on the master node.


<h6>Footnotes:</h6>

<sup name="f1">[1](#a1)</sup> I stole this quote from the front page of here: https://kubernetes.io/. I could have mitigated this by using "" to quote it, but I need my little thrills, so I stole it.

<sup name="f2">[2](#a2)</sup> Did you see what I did there? I plagarized 93% of the above footnote which I had previously plagarized.

<sup name="f3">[3](#a3)</sup> Really, mostly if you have your act together and read this documentation. The first few times you install Stacki, it's not gonna do what you think it should. There's a learning curve, though not as steep as Cobbler/Satellite/Spacewalk, or, my God, Ironic. 

<sup name="f4">[4](#a4)</sup> If you currently have nothing, this will definitely work better than what you have. 

<sup name="f5">[5](#a5)</sup> If you've seen any of the Kubernetes documentation, there are multiple ways to skin this particular software cat. We aren't doing those. If you want, you can just use Stacki to get the machines to a ping and a prompt and then use another/other tools for deploying Kubernetes. But then, you're not running it on bare metal anymore if that's a priority for you.

<sup name="f6">[6](#a6)</sup> vim or swim! I guess you could use emacs, but that means you're probably a developer and why are you reading this? 
