#!/usr/bin/env python2.5

import sys,os,subprocess
from optparse import OptionParser
import time

MAX_RUN_TIME = 240

def hostsfile(filename):
    """Loads a group of hosts from a config file.

    group: name of the group file, one host per line
    """
    try:
        fhosts = open(filename)
    except IOError:
        abort('file not found: %s' % filename)

    def has_data(line):
        """'line' is not commented out and not just whitespace."""
        return line.strip() and not line.startswith('#')

    hosts = [ line.strip() for line in fhosts
                        if has_data(line)]
    return hosts

def checkRuntimeExceeded(startTime):
	now = time.time()
	runTime = now - startTime
	return runTime > MAX_RUN_TIME

def killProcs(procs):
	killcount = 0 
	print "Runtime exceeded, killing remaining processes" 
	for proc in procs: 
		os.kill(proc.pid, 15)
		killcount += 1
	return killcount
		

def runFab(hosts, cmd):
	procs = []	
	completions = 0
	termcount = 0
	startTime = time.time()
        for host in hosts:
               proc = subprocess.Popen(['fab','-H', host,cmd])
	       procs.append(proc)
	while len(procs) > 0:
		proc = procs.pop()
		returnCode = proc.poll() 
		if returnCode == None :
			procs.insert(0, proc)
			if (checkRuntimeExceeded(startTime)):
				termcount = killProcs(procs)
				break
		else:
			completions += 1		
	print("Completed command %s on %d hosts with %d jobs terminated " % (cmd, completions, termcount))
		

usage = "usage: %prog hostsfile fab_command" 
parser = OptionParser(usage)
parser.add_option("-t", "--timeout", dest="timeout", type="int", help="override default timeout value of 240 seconds")
(options, args) = parser.parse_args()

if (len(args) < 2):
        print("ERROR: You must provide a hosts file and a fabric command")
        print usage
        sys.exit(1)

if (options.timeout):
	MAX_RUN_TIME = options.timeout

filename = args[0]
cmd = args[1]
hosts = hostsfile(filename)
runFab(hosts, cmd)


