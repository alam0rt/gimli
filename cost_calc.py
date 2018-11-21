#!/usr/local/bin/python

import subprocess

proc = subprocess.Popen('du -hs /storage/vault/ | awk \'{print substr($1, 1, length($1)-1)}\'', shell=True, stdout=subprocess.PIPE, )
size = proc.communicate()[0]
price = 0.005 * float(size)
print("Projected cost for " + str(size) + "GB is: $" + str(price))
print("ZFS quota for /storage/vault is " + str(size) + "/500G")

