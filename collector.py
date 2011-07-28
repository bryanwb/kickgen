#!/usr/bin/env python2.5

import sys,os,subprocess
from optparse import OptionParser
import time

# parse list of servers
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


# for each host see if the ks file is present and less than 24 hrs old
# if not put together a list for errors
def isUptodate(mtime):
	# 86400 seconds in the day
	timeLimitSeconds = 86400	
	now = time.time()
	timeLimit = now - timeLimitSeconds
	return mtime >= timeLimit

	
def checkFile(host):	
	timeout = "-o ConnectTimeout=40"
	hostnameProc = subprocess.Popen(['ssh', host, timeout, 'hostname', '-s'], \
		stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	returnCode = hostnameProc.wait()
	hostname = hostnameProc.stdout.read().strip()
	filename = '/root/' + hostname + '-ks.cfg'
	proc = subprocess.Popen(['ssh',timeout,host,'stat -c %Y',filename],\
		stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	returncode = proc.wait()
	if (returncode == 0):
		try:
			mtime = int(proc.stdout.read().strip())
			uptodate = isUptodate(mtime)		
			if (uptodate):
				return copyKickstart(host, filename)
		except ValueError:
			print "On host " + host + " couldn't read stdout\n"
			return False
	else:
		print 'ERROR: could not access the kickstart file on host ' + host
		print proc.stderr.read() 
		return False

def copyKickstart(host, filename):
	remotePath = host + ':' + filename
	localPath = '/root/ks.cache.d/'
	rsyncProc = subprocess.Popen(['rsync', '-Havz', remotePath, localPath], \
		stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	returnCode = rsyncProc.wait()
	if (returnCode != 0):
		stderr = rsyncProc.stderr.read().strip()
		print('ERROR: couldn\'t copy kickstart for %s \n' % host)  
		print('STDERR on remote host: %s \n' % stderr) 
		return False
	else:
		return True



def notifyAdmin(outofdateList):
	outofdateListStr = ','.join(outofdateList)
	cmd = 'echo ' + outofdateListStr + ' | mail -s ' + \
		'"hosts out of date kickstart" you@example.com'
	os.system(cmd)

def checkHosts(hosts):
	uptodateList = []
	outofdateList = []
	for host in hosts:
		boolUptodate = checkFile(host)
		if (boolUptodate):
			uptodateList.append(host)
		else:
			outofdateList.append(host)
	return uptodateList, outofdateList

usage = "usage: %prog hostsfile" 
parser = OptionParser(usage)
(options, args) = parser.parse_args()

if (len(args) < 1):
        print("ERROR: You must provide a hosts file")
        print usage
        sys.exit(1)
 
hosts = hostsfile(args[0])
uptodateList, outofdateList = checkHosts(hosts)
if (len(outofdateList) > 0):
	notifyAdmin(outofdateList)

