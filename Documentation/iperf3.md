# iPerf3

Source: [iPerf3](https://iperf.fr/)

Target OS: Linux

## Summary from website

iPerf3 is a tool for active measurements of the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, buffers and protocols (TCP, UDP, SCTP with IPv4 and IPv6). For each test it reports the bandwidth, loss, and other parameters. This is a new implementation that shares no code with the original iPerf and also is not backwards compatible. iPerf was orginally developed by [NLANR/DAST](https://iperf.fr/contact.php#authors). iPerf3 is principally developed by [ESnet](https://www.es.net/) / [Lawrence Berkeley National Laboratory](https://www.lbl.gov/). It is released under a three-clause [BSD license](https://en.wikipedia.org/wiki/BSD_licenses).

## Basic usage

1. Download the [iPerf3](https://iperf.fr/) CLI tool on two machines.
2. set one session to client mode (-c {server IP}), and one session to server mode (-s).
