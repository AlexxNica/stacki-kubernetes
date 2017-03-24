
# Stacki+Kubernetes Cluster Install - Phase 2

This is the documentation for phase2 of the stacki-kubernetes. It locks all systemd kubernetes services with SSL/TLS termination, for both clients and servers. You're welcome.

### tl;dr
Really? You don't want to read this? It's the best README you'll ever encounter. 

Alright. Fine.

We assume you have:
1. A Stacki frontend/management node installed.
2. Either backend nodes already installed or a hostfile you're going to load.
3. Time, patience, no need to answer the question "Why?"


* Download these to your frontend
    - [CentOS-7.3](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-1611.iso)
    - [CentOS-7.3 Updates](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.3-7.x.x86_64.disk1.iso)
    - [stacki-docker-17-03 phase2](https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-17.03.0-3.2_phase2.x86_64.disk1.iso)
    - [stacki-kubernetes](http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.4-7.x_p2.x86_64.disk1.iso)

* Install, enable, and then run stacki-kubernetes:
```
# stack add pallet stacki-*iso CentOS*.iso
# stack enable pallet CentOS CentOS-Updates stacki-docker stacki-kubernetes
# stack disable pallet os

# stack run pallet stacki-kubernetes | bash
```

* Prepare spreadsheet.
```
# cd /export/stack/spreadsheets/examples/
```

Edit full-kubernetes-attrs.csv change the "backend-0-?" hostnames to your 
hostnames. Edit any ip addresses for the master ip. This is easier opened 
in Excel or Google Spreadsheet. Export it back csv on your frontend.

If you have more hostnames than in this example, add them and assign them roles. 
Mostly they'll be nodes.

Add it:
```
# stack load attrfile file=full-kubernetes-attrs.csv

```

* Install backend nodes.
```
# stack set host boot backend action=install
# stack set host attr backend attr=nukedisks value=True
```

Reboot your nodes. Breathe. 

* Access

```
# ssh <master node>

List pods:

# kubectl -n kube-system get pods

Port forward the name of the pod to access the Kubernetes Dashboard.

# kubectl -n kube-system port-forward <pod name> 9090

From your laptop ssh port forward:

# ssh -L 9090:127.0.0.1:9090 root@10.1.255.254

Go to http://127.0.0.1:9090 in a browser.

```

There is a little script I'll leave in scripts so you can connect from your desktop to the K8s cluster, assuming you have network access to that subnet. It will be explained further below.

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

This is a Phase 2 project. A Phase 2 project for us means: it's going to work as advertised in the Kubernetes docs only on bare metal, and all the kube daemons are now secure. As in wrapped with SSL/TLS<sup name="a4">[4](#f4)</sup>. You'll be able to install backend nodes with the current stable version of Kubernetes and run your own or public containers. 

### Requirements

As in, you need these to make this work. If you don't have all of these, it won't work.

- [stacki-os-3.2](https://s3.amazonaws.com/stacki/3.x/stacki-os-3.2-7.x.x86_64.disk1.iso) (If you already have a Stacki 3.2 frontend up, you don't need this again.)
- [CentOS-7.3](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-1611.iso)
- [CentOS-7.3 Updates](https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.3-7.x.x86_64.disk1.iso)
- [stacki-docker-17-03 phase2](https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-17.03.0-3.2_phase2.x86_64.disk1.iso)
- [stacki-kubernetes](http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.4-7.x_p2.x86_64.disk1.iso)

You should download these. If you have a Stacki frontend up already, download these to /export which should be the biggest partition on the frontend.

### Versions (all latest stable)
- Docker 17.03.0 Community Edition (It's in the stacki-docker pallet.)
- Kubernetes 1.5.4
- etcd 3.1.3
- flannel 0.7.0

This is the current default stack. Docker 17.03.0 is in the stacki-docker pallet which is why you need it. Everything else for Kubernetes is in the stacki-kubernetes pallet. Phase 2 only uses these versions. Phase 3 will have more options. See the Caveats section for what you may need but this may not have.

### Caveats
This is what it doesn't have - yet. If you have opinions on what should be in Phase 3, make it known on the googlegroups or on the Stacki Slack channel.

- rkt (Really? Go away and leave me alone.)
- The only overlay network currently supported is flannel.
- docker registry runs with "--insecure-registry"
- No DevOps tools used, just straight kickstart.<sup name="a5">[5](#f5)</sup> So if you've seen the Stacki+Kubernetes+Salt video demo, that's not valid anymore. Salt is not in Stacki unless you put it there. 
- The only service running in a container is a docker registry if you want it.

## Installing Kubernetes

### Prepare the stacki frontend

The installation of Kubernetes and subsequent deployment of you cluster requires:

* A working stacki frontend with nodes installed.
* The stacki-docker pallet
* The stacki-kubernetes pallet
* The CentOS-7.3 and CentOS-Updates pallets.

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

# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-7-x86_64-Everything-111.iso 
# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/os/centos/7/CentOS-Updates-7.3-7.x.x86_64.disk1.iso
# wget --no-check-certificate https://s3.amazonaws.com/stacki/public/pallets/3.2/open-source/stacki-docker-17.03.0-3.2_phase2.x86_64.disk1.iso 
# wget --no-check-certificate http://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-kubernetes-1.5.4-7.x_p2.x86_64.disk1.iso 
```

Either all at once or one at a time.

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

A pallet generally has both frontend and backend configuration. To get the frontend configuration to happen for a pallet that contains it. The stacki-kubernetes pallet needs to be run; however, the stacki-docker pallet should not be run. The stacki-docker pallet does double duty: it provides docker for stacki-kubernetes, and it can be used without stacki-kubernetes. You only run the stacki-docker pallet if it is NOT being used with stacki-kubernetes.

Did you get that. Let me say it again, only louder.

*** Do not run the stacki-docker pallet ***

But you should run the stacki-kubernetes pallet, like this:

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

Or you haven't installed them and you already have a hosts.csv file to add them to the frontend. Add that file first if you have it. 

If you haven't installed backend nodes, I highly recommend installing them with the base installation to shake out any hardware problems and know that they are going to work. Do this before enabling the stacki-docker and stacki-kubernetes pallets. You don't have to, but it's highly recommended. Then enable/re-enable stacki-kubernetes and stacki-docker after adding a spreadsheet for some required attributes, and reinstall the nodes. The reinstalling nodes is the short part of this.

If you haven't installed backends, and you have a host spreadsheet. (See the [Backend Install](https://github.com/StackIQ/stacki/wiki/Backend-Installation) section of our docs.) You can load the attrfile before installation, but there's more to troubleshoot if something goes wrong. 

So in any event, we assume you have backend nodes. They don't have kubernetes on them and you're going to install or reinstall. You have to add the following attr file. The hostnames may need to change because "backend-?-?" is the default and you may have different host names.

So to create your attrfile, just adapt the example here and add them. After the spreadsheet, we'll go through what this means. However, if this is the first time you've encountered a spreadsheet attribute file, go review this [here]<sup name="a6">[6](#f6)</sup> which apparently I'm now writing also.

Do the following:

I've included a few spreadsheets for you to adopt/adapt/disregard. These should be installed when you run the stacki-kubernetes pallet.
So let's go find them and look at them.

```
# cd /export/stack/spreadsheets/examples/

# ls -1
full-kubernetes-attrs.csv
global-kubernetes-attrs.csv
hosts-kubernetes-attrs.csv
kubernetes-partitions.csv
```

I'll explain the files, and then we'll go into further detail on the attributes because you will/may want to change attributes for your cluster.

The global-kubernetes-attrs.csv contains only attributes at a global level. It's easier to see if you just have to deal with one line of keys and values.

The hosts-kubernetes-attrs.csv shows the changes for our example backend nodes without the global values being defined. Again easier to see.

The full-kubernetes-attrs.csv file is the combined hosts-kubernetes-attrs.csv and global-kubernetes-attrs.csv files. Not as easy to see, but easier to use because you take care of everything all at once. 

The kubernetes-partitions.csv file will be used for partitioning. We use overlay fs for Docker and that needs a little extra something to get it to work with Docker correctly. 

We're going to work with the full-kubernetes-attrs.csv for our explanation. 

Open it with your favorite editor <sup name="a7">[7](#f7)</sup>, Excel/Libre Office/Google Spreadsheets

It looks like this:

| target      | kube.secure | kube.master | kube.master_ip | kube.minion | etcd.prefix     | etcd.cluster_member | kube.enable_dashboard | kube.pull_pods | kube.pod_dir            | docker.registry.local | docker.registry.external | sync.hosts | kube.spark_demo | 
|-------------|-------------|-------------|----------------|-------------|-----------------|---------------------|-----------------------|----------------|-------------------------|-----------------------|--------------------------|------------|-----------------| 
| global      | True        | False       | 10.1.255.254   | True        | /stacki/network | False               | False                 | True           | install/kubernetes/pods | True                  | False                    | True       | True            | 
| backend-0-0 |             | True        |                |             |                 | True                | True                  |                |                         |                       |                          |            |                 | 
| backend-0-1 |             |             |                |             |                 | True                |                       |                |                         |                       |                          |            |                 | 
| backend-0-2 |             |             |                |             |                 | True                |                       |                |                         |                       |                          |            |                 | 
| backend-0-3 |             |             |                |             |                 |                     |                       |                |                         |                       |                          |            |                 | 
| backend-0-4 |             |             |                |             |                 |                     |                       |                |                         |                       |                          |            |                 | 


The goal here is to edit this file so that it reflects your site and needs, not mine. Since there isn't currently a page to describe attributes and what they are used for, I will do so here.

We'll go through each of these values and tell you why it exists, what it will do at the current default setting, and why you might want to change it. This will be valuable when you add backend hosts below and whant to change the role they play in the Docker set-up.

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
# stack load attrfile file=full-kubernets-attrs.csv
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
Target = kube.secure
Global Value = True
Used for: Running kubernetes/docker with TLS/SSL termination.
Host change: No, don't do that.
```
Leave this alone. You really want this to run securely.

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
Etcd requires either that you have one etcd master with a storage backing store or 3, 5, or 7 etcd nodes in cluster. In this case, three nodes are designated to provide etcd redundancy. You can get away with one but we don't have a backing store in Phase 2. Phase 3 probably.

```
Target = kube.enable_dashboard
Global Value = False
Used for: Setting up the kubernetes-dashboard automatically
Host change: backend-0-0 is set to True.
```

The kubernetes-dashboard is a UI for deployment of containers, services, pods etc. It's pretty. It's helpful especially if you're new to this. But I think it's beta? Setting a node to True will put the kubernetes-dashboard automatically. You'll have to start it up. (See below.) I've put it on the master. Technically you can put it on any node, but I haven't tested that yet.

```
Target = kube.pull_pods
Global Value = True
Used for: pulling yaml files from the frontend for stuff you already have.
Host change: None - is a global set to "False" if you have no pods and aren't using the kubernetes-dashboard.
```

This is a pallet thing, not Kubernetes. I wanted to test both the dashboard and other pods and services I have without having to copy them to the node after every install. Since a Stacki frontend has a web server running for the backend node installation that's available at /var/www/html/install/ I put yaml in a directory and pull it during install. The directory is /export/stack/kubernetes/pods. So if you have stuff you want to run and don't want to have to pass around you yaml files with ssh, drop them in that directory.

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

Oh this is a can of worms, and I don't like how I did it so it will be changing. If you have a completely closed cluster, meaning, backend nodes don't have an internet connection, then set this to True. We'll discuss the issues further below in the Docker section below.

```
Target = docker.registry.external
Global Value = True
Used for: everything that needs web connectivity
Host change: Global - change only if you have an off-line cluster.
```
If the frontend or all the backend nodes do have connectivty to the internet, then set this to True. Actually, you have to, either all the nodes do or you have to masquerade below. See the Firwall section.

```
Target = sync.hosts
Global Value = True
Used for: syncing /etc/hosts to all backend nodes
Host change:
```
I do this because things just work better if /etc/hosts is populated on all the backend nodes because your DNS infrastructure sucks. (Mine does.)

```
Target = kube.spark_demo
Global Value = True
Used for: Starting up Spark in a K8s cluster.
Host change: Global - set to false if you don't want it.
```

I do this because I do demos, lots and lots of demos. Set it to false. It's pretty though.

There is one other attribute you have to set by hand, because adding it in spreadsheet doesn't work. I believe this is fixed in stacki 4.0 however. Kubernetes needs a network for containers to live in/on and we want to define that:

```
stack set attr attr=kube.network value='{ "Network": "172.16.0.0/16", "SubnetLen": 24, "SubnetMin": "172.16.1.0", "SubnetMax": "172.16.254.0", "Backend": { "Type": "udp", "Port": 7890 } }'
```

Feel free to change the ip schema before you run that command. 

##### Docker - we have to talk

The Docker registry runs insecurely in Phase

Okay, with Docker there are two options: if no nodes don't have internet access, or if at least the frontend has internet access.

###### Cluster is private

If there are no nodes with internet access, set the docker.registry.local to True. This will create a registry on the master node. You can push docker images to this directory with "docker push master_ip:5000/imagename" and it will work.

To get the kubernetes-dashboard up on a closed network, several docker images have been pre-created and installed on the master node, so that will at least work. But any other images that need to be pulled for your pods, also need to be pushed to the private registry. Including ones you may have in a site registry. This will change in Phase 3.

###### Cluster has one public interface.

I'm assuming if you have a public interface it's on the frontend. If all the backends are public facing, just set the docker.registry.external to "True" and be on your way.

If your frontend has a public interface, then do the following:

```
# stack list network
NETWORK  ADDRESS     MASK        GATEWAY      MTU   ZONE       DNS   PXE
private: 10.1.0.0    255.255.0.0 10.1.1.1     1500  local      True  True
public:  192.168.0.0 255.255.0.0 192.168.10.1 1500  jkloud.com False False
```
I have a public and a private. Backends are on the private. So I want to masquerade requests through my public interface, so I'll add three firewall rules for the frontend. (We are using iptables not firewalld.)

```
# stack add host firewall frontend action=MASQUERADE chain=POSTROUTING output-network=public protocol=all rulename=MASQUERADE service=all table=nat
# stack add host firewall kaiza chain=FORWARD  output-network=private network=public protocol=all rulename=FORWARD_PUB service=all table=filter action=ACCEPT
# stack add host firewall kaiza chain=FORWARD  output-network=public network=private protocol=all rulename=FORWARD_PRIV service=all table=filter action=ACCEPT
```
With rules set, I'll sync my firewall and restart it:

```
stack sync host firewall &hostname; restart=true
```

You should be able to ping google.com from any backend node. If not, get on the list and we'll help you work through the problem. 

### Back to installing

Now that you've set up your attrfile, load it:

```
# stack load attrfile file=full-kubernetes-attrs.csv

```

* Install backend nodes.
```
# stack set host boot backend action=install
# stack set host attr backend attr=nukedisks value=True

This is going to wipe the disks. 

Reboot your nodes. Wait. 
```

* Access

Yeah access on bare metal is funky because there's no automatic loadbalancer that multiplexes the pods to the external world. AWS and GCE both do this but that's because they way their hands and invoke incantations. It's magic and they don't care if you think that. There are a couple of ways to get to the dashboard

- Path 1
```
# ssh <master node>

List pods:

# kubectl -n kube-system get pods

NAME                                    READY     STATUS    RESTARTS   AGE
kubernetes-dashboard-1728291479-vh085   1/1       Running   0          45m
```

Port forward the name of the pod to access the Kubernetes Dashboard.
```
# kubectl -n kube-system port-forward <pod name> 9090

e.g.
# kubectl -n kube-system port-forward kubernetes-dashboard-1728291479-vh085 9090
Forwarding from 127.0.0.1:9090 -> 9090
Forwarding from [::1]:9090 -> 9090
```

From your control machine ssh port forward to the dashboard node.
```
# ssh -L 9090:127.0.0.1:9090 root@10.1.255.254
```

If you have access from a desktop or laptop to the Manager node, you could also do this:

Install [kubectl](https://kubernetes.io/docs/tasks/kubectl/install) on your laptop/desktop:

```
# kubectl -n kube-system get pods --server=http://10.1.255.254:8080
```

Then

```
kubectl -n kube-system port-forward kubernetes-dashboard-1728291479-q1sjp --server=http://10.1.255.254:8080 9090
```

Go to http://127.0.0.1:9090 in a browser.

- Path 2

This is a bit hacky, but it works, expecially when I'm demoing.

On my desktop/laptop that has access to the network the K8s cluster is running on, and that has [kubectl](https://kubernetes.io/docs/tasks/kubectl/install/) on it.

```
# mkdir .kube
# cd .kube

Copy the certs and keys:

# scp root@frontendIP:/opt/kubernetes/etc/certs.d/*.pem .
```

Then create a config file. Go ahead and copy this and make edits to the server URL and the directory path. I doubt you're in /Users/joekaiser/.kube when you do this.

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /Users/joekaiser/.kube/ca.pem
    server: https://10.1.255.254:6443
  name: kubernetes
- cluster:
    certificate-authority: /Users/joekaiser/.kube/ca.pem
    server: https://10.1.255.254:6443
  name: local
contexts:
- context:
    cluster: local
    user: kubelet
  name: kubelet-context
- context:
    cluster: local
    user: kube-proxy
  name: kubeproxy-context
current-context: kubelet-context
kind: Config
preferences: {}
users:
- name: kube-proxy
  user:
    client-certificate: /Users/joekaiser/.kube/kube-proxy-client.pem
    client-key: /Users/joekaiser/.kube/kube-proxy-client-key.pem
- name: kubelet
  user:
    client-certificate: /Users/joekaiser/.kube/kubelet-client.pem
    client-key: /Users/joekaiser/.kube/kubelet-client-key.pem
```

Now get really hacky, This is a script I use to get to the dashboard and spark web UIs.

```
#!/bin/bash
SVC=${1}
PORT=${2}

if [ "${1}" = "kubernetes-dashboard" ]; then
    NSPACE="kube-system"
    SELECTOR="app"
else
    NSPACE="default"
    SELECTOR="component"
fi

POD=`kubectl -n ${NSPACE} get po --selector=${SELECTOR}=${SVC} -o name | awk -F'/' '{print $2}'`
CPORT=`kubectl -n ${NSPACE} get po ${POD} --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'`
kubectl -n ${NSPACE} port-forward ${POD} ${PORT}:${CPORT} &
```

This basically port forwards my locahost to the container managed by Kubernetes and make the port available at 127.0.0.1:PORT.

And I use it like this:
```
For the dashboard:
./k8shack kubernetes-dashboard 7777

For Spark demo UI:
./k8shack spark-ui-proxy 8888

For Zeppelin workbook UI
./k8shack zeppelin 9999
```

##### Monitoring

I've created a stacki-prometheus pallet that runs Prometheus/Grafana on the frontend with some default dashboards for bare metal, Kubernetes, and Docker. Follow the [stacki-prometheus README.md](https://github.com/StackIQ/stacki-prometheus) to add monitoring to your kubernetes infrastructure. 

##### Proposed changes in no particular order
* You oughta be able to install with CoreOS too.
* Rkt
* Docker to support external,site, and cluster local registries.
* Run just an etcd cluster?
* Storage backed etcd. 
* Persistent fileystem options for stateful sets.
* System Kubernetes daemons to use kubecfg versus /etc/sysconfig files. 
* kube-dns really working

##### Fixing stuff that's done broke

Get on googlegroups or the Stacki Slack channel and tell us what you need. You have a chance to influence the direction of this pallet in positive ways.

<h6>Footnotes:</h6>

<sup name="f1">[1](#a1)</sup> I stole this quote from the front page of here: https://kubernetes.io/. I could have mitigated this by using "" to quote it, but I need my little thrills, so I stole it.

<sup name="f2">[2](#a2)</sup> Did you see what I did there? I plagarized 93% of the above footnote which I had previously plagarized.

<sup name="f3">[3](#a3)</sup> Really, mostly if you have your act together and read this documentation. The first few times you install Stacki, it's not gonna do what you think it should. There's a learning curve, though not as steep as Cobbler/Satellite/Spacewalk, or, my God, Ironic. 

<sup name="f4">[4](#a4)</sup> If you currently have nothing, this will definitely work better than what you have. 

<sup name="f5">[5](#a5)</sup> If you've seen any of the Kubernetes documentation, there are multiple ways to skin this particular software cat. We aren't doing those. If you want, you can just use Stacki to get the machines to a ping and a prompt and then use another/other tools for deploying Kubernetes. But then, you're not running it on bare metal anymore if that's a priority for you.

<sup name="a6">[6](#f6)</sup> There should a link here about attributes and how to use them. Apparently, no one has ever written this. I will do so, next week. Really. Next. Week.

<sup name="f7">[7](#a7)</sup> vim or swim! I guess you could use emacs, but that means you're probably a developer and why are you reading this? 


