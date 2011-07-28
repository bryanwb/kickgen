#!/usr/bin/env python2.5

from __future__ import with_statement
from fabric.api import * 
from fabric.contrib.files import *


el4_i386_rpms = 'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el4/en/x86_64/dag/RPMS/perl-XML-Simple-2.16-1.el4.rf.noarch.rpm ' + \
	'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el4/en/i386/extras/RPMS/perl-XML-Parser-2.40-1.el4.rfx.i386.rpm'
el4_x86_64_rpms = 'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el4/en/x86_64/dag/RPMS/perl-XML-Simple-2.16-1.el4.rf.noarch.rpm  ' + \
	'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el4/en/x86_64/extras/RPMS/perl-XML-Parser-2.40-1.el4.rfx.x86_64.rpm' 
el5_i386_rpms = 'ftp://ftp.pbone.net/mirror/ftp.freshrpms.net/pub/freshrpms/pub/dag/redhat/el5/en/i386/RPMS.dag/perl-XML-Simple-2.16-1.el5.rf.noarch.rpm ' + \
	'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el5/en/i386/extras/RPMS/perl-XML-Parser-2.40-1.el5.rfx.i386.rpm '
el5_x86_64_rpms = 'ftp://ftp.pbone.net/mirror/ftp.freshrpms.net/pub/freshrpms/pub/dag/redhat/el5/en/i386/RPMS.dag/perl-XML-Simple-2.16-1.el5.rf.noarch.rpm ' + \
	'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el5/en/x86_64/extras/RPMS/perl-XML-Parser-2.40-1.el5.rfx.x86_64.rpm '
el3_i386_rpms = 'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el3/en/x86_64/dag/RPMS/perl-XML-Simple-2.14-2.1.el3.rf.noarch.rpm ' + \
	'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el3/en/i386/dag/RPMS/perl-XML-Parser-2.34-1.1.el3.dag.i386.rpm'
el3_x86_64_rpms = 'ftp://ftp.univie.ac.at/systems/linux/dag/redhat/el3/en/x86_64/dag/RPMS/perl-XML-Simple-2.16-1.el3.rf.noarch.rpm ' + \
	'ftp://ftp.pbone.net/mirror/ftp.pramberger.at/systems/linux/contrib/rhel3/archive/x86_64/perl-XML-Parser-2.36-3.el3.pp.x86_64.rpm '

def determineRpms():
	arch = run('uname -i')
	osVersion = run("cat /etc/redhat-release | sed -e 's/.*lease\ \([3-5]\).*/\\1/'")
 	rpms = "el" + osVersion + "_" + arch + "_rpms"  	
	return eval(rpms)

def testRpms():
 	run('rpm --test -Uvh ' + determineRpms()) 	

def installRpms():
 	run('rpm -Uvh ' + determineRpms()) 	

def getDeps():
	installed = run("rpm -qa 'perl-XML-Simple'")
	if (installed == ""):
		installRpms()
	else:
		print "rpm dependencies already installed"	

def putFiles():
	put('./kickgen.cron', '/etc/cron.daily/', mode=0755) 
	put('./kickgen.pl', '/root/', mode=0755) 

def install():
	getDeps()
	putFiles()


def testInstall():
	if (exists('/root/kickgen.pl')):
		print ('kickgen installed [PASS]')
	else:
		print '' + env.host + ': kickgen not installed [FAIL]'

def renameCronJob():
	run('mv /etc/cron.daily/kickgen.sh /etc/cron.daily/kickgen.cron')

def checkCronJob():
	if (exists('/etc/cron.daily/kickgen.cron') == False):
		print("[%s]: kickgen.cron not found [FAIL]" % env.host)

def hello():
	run("sleep 10")
