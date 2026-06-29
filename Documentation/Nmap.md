# Nmap

Source: [Nmap](https://nmap.org/)

Target OS: Linux, Windows

## Summary from website

Nmap ("Network Mapper") is a [free and open source](https://nmap.org/npsl/) utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts. Nmap runs on all major computer operating systems, and official binary packages are available for Linux, Windows, and Mac OS X. In addition to the classic command-line Nmap executable, the Nmap suite includes an advanced GUI and results viewer ([Zenmap](https://nmap.org/zenmap/)), a flexible data transfer, redirection, and debugging tool ([Ncat](https://nmap.org/ncat/)), a utility for comparing scan results ([Ndiff](https://nmap.org/ndiff/)), and a packet generation and response analysis tool ([Nping](https://nmap.org/nping/)).

## Basic usage

1. Download the [Nmap](https://nmap.org/download.html) CLI tool.

## Examples

### Prtiner scan

nmap --open -p 9100 -T 5 {CIDR}
