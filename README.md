###Prologue
============

It may be turtles all the way down in some universes, but not in the data center world. At the bottom of every cloud is a 
bare metal turtle() holding up your VMs, containers, and apps. If you have to install 10 - 100s of machines on a regular basis, 
with heterogenous hardware and application stacks, you want to be able to automate that from one place, fast.

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.<sup name="a1">[1](#f1)</sup>

Stacki is an open-source system for automating deployment, scaling, and management of bare metal systems.<sup name="a2">[2](#f2)</sup> 

Together, Stacki+Kubernetes, can deploy a Kubernetes stack on bare metal, in about the same time it takes to make a pot of coffee 
and drink the first couple of cups. 




This pallet will give you a functioning Kubernetes cluster.

On bare metal. 

The only service running in a container is a docker registry if you want it.

It's promiscuous: nothing is nailed down with tls certs yet, or put it on a closed network, but that brings it's own challenges.


<h6>Footnotes:</h6>

<sup name="f1">[1](#a1)</sup> I stole this quote from the front page of here: https://kubernetes.io/. I could have mitigated this by using "" to quote it, but I need my little thrills, so I stole it.

<sup name="f2">[2](#a2)</sup> Did you see what I did there? I plagarized 95% of the above footnote which I had previously plagarized.
