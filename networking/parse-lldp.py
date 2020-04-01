#!/usr/bin/python3

import json
import os


def write_header(f):
    f.write("<html><body>")

def write_footer(f):
    f.write("</body></html>")

lldp_dir='/tmp/lldp'
machines = []
ports = []
netmap = {}

for fname in os.listdir(lldp_dir):
    hostname=fname.split('.')[0]
    if hostname not in machines:
        machines.append(hostname)
    netmap[hostname]={}
    with open(lldp_dir + "/" + fname) as f:
        data = json.load(f)
        for iface in data['lldp']['interface']:
            for ifname in iface.keys():
                iflldp = iface[ifname]
                pdata = {}
                if 'port' in iflldp:
                    pdata['descr'] = iflldp['port']['descr']
                    pdata['port'] = iflldp['port']['id']['value']
                if 'vlan' in iflldp:
                    pdata['vlan'] = iflldp['vlan']['vlan-id']
                if 'chassis' in iflldp:
                    for c in iflldp['chassis'].keys():
                      pdata['chassis'] = c
                if ifname not in ports:
                    ports.append(ifname)
                netmap[hostname][ifname]=pdata


machines.sort()
ports.sort()
    
with open('lldp.html', 'w') as f:
    write_header(f)
    f.write("<table border=1>\n")
    #header
    f.write("<tr>")
    f.write("<td>Hostname</td>")
    for port in ports:
        f.write("<td>" + port + "</td>")
    f.write("</tr>\n")
    #/header
    #body
    for machine in machines:
        f.write("<tr>")
        f.write("<td>" + machine + "</td>")
        for port in ports:
            try:
                f.write("<td>" + str( netmap[machine][port]) + "</td>")
            except KeyError:
                 f.write("<td>" + "Not connected" + "</td>")
        f.write("</tr>\n")
    #/body
    f.write("</table>")
    write_footer(f)
