#!/usr/bin/perl
# Copyright Jerome Delamarche, year ?
# Licensing terms unclear 
# www.trickytools.com/php/kickgen.php
# patched extensively by Bryan W. Berry, bryan.berry@gmail.com
# 
# TODO: recreate users > 500 ????
#
# Kickstart File Generator
#
# -----------------------------------------------------------------
# Input Parameters:
#
# 	none
#
# -----------------------------------------------------------------
# We list in the table below the kickstart options that we must
# generate. Unuseful options are not listed.
#
# -----------------------------------------------------------------
#				RH9(2)	RHEL3	RHEL4	RHEL5
# Kickstart Option
# OK    : supported by this script
# NOSUP : unuseful or not supported by the script
# PS    : handled by the Post Installation Script
# USR	: must be set by the user (cmd line, dialog box...)
# -----------------------------------------------------------------
# autopart NOSUP		 	x	x	x
#
# autostep NOSUP		x	x	x	x
#
# authconfig
# OK	--enablemd5		x	x	x	x
# OK	--enablenis		x	x	x	x
# OK 	--nisdomain=		x	x	x	x
# OK 	--nisserver=		x	x	x	x
# OK	--enableshadow		x	x	x	x
# OK	--enableldap		x	x	x	x
# OK	--enableldapauth	x	x	x	x
# OK	--ldapserver=		x	x	x	x
# OK	--ldapbasedn=		x	x	x	x
# OK	--enableldaptls		x	x	x	x
# OK 	--enablekrb5		x	x	x	x
# OK 	--krb5realm=		x	x	x	x
# OK 	--krb5kdc=		x	x	x	x
# OK 	--krb5adminserver=	x	x	x	x
# 	--enablehesiod		x	x	x	x
# 	--hesiodlhs		x	x	x	x
# 	--hesiodrhs		x	x	x	x
# 	--enablesmbauth		x	x	x	x
# 	--smbservers=		x	x	x	x
# 	--smbworkgroup=		x	x	x	x
# OK	--enablecache		x	x	x	x
#
# bootloader					
# OK	--append=		x	x	x	x
#	--driveorder			?	x	x
#	--location=		x	x	x	x
# OK	--password=		x	x	x	x
#	--useLilo		x	?
#	--linear		x	?
#	--nolinear		x	?
#	--lba32			x	?
# OK	--md5pass		x	x	x	x
# NOSUP	--upgrade		x	x	x	x
#
# clearpart
#	--linux			x	x	x	x
#	--all			x	x	x	x
# OK	--drives=		x	x	x	x
#	--initlabel		x	x	x	x
#	--none						x
#
# device
#	<type>	(scsi/eth)	x	x	x	x
#	<module>		x	x	x	x
#	--opts=			x	x	x	x
#
# deviceprobe			x
#
# driverdisk
#	<partition>		x	x	x	x
#	--type=			x	x	x	x
#
# firewall	
# PS	<seclevel>		x	x	x	x
# PS	--trust=		x	x	x	x
# PS	<incoming>		x	x	x	x
# PS	--port=			x	x	x	x
#
# note: v9: <seclevel> = --high|--medium|--disabled
#       v4/5: <seclevel> = --enabled|--disabled
#
# install			
# USR	cdrom			x	x	x	x
# USR	harddrive		x	x	x	x
# USR		--partition=	x	x	x	x
# USR		--dir=		x	x	x	x
# USR		--biospart				x
# USR	nfs			x	x	x	x
# USR		--server=	x	x	x	x
# USR		--dir=		x	x	x	x
# USR		--opts=		 	 	 	x
# USR	url			x	x	x	x
# USR		--url		x	x	x	x
#
# interactive	
# NOSUPP			x	x	x	x
#
# iscsi							x
#	--target					x
#	--port=						x
#	--user=						x
#	--pasword=					x
#
# iscsiname						x
#
# key							x
#	--skip						x
#
# keyboard
# OK				x	x	x	x
#
# lang	
# OK				x	x	x	x
#
# langsupport			x	x	x	x
#	--default=		x	x	x	x
#
# logvol			x	x	x	x
# OK	--vgname=		x	x	x	x
# OK	--size=			x	x	x	x
# OK	--name=			x	x	x	x
# NOSUP	--noformat			?	x	x
# NOSUP	--useexisting			?	x	x
# OK	--fstype=					x
# NOSUP	--fsoptions=					x
# OK	--bytes-per-inode=				x
# NOSUP	--grow=						x
# NOSUP	--maxsize=					x
# NOSUP	--recommended=					x
# NOSUP	--percent=					x
#
# logging						x
# PS	--host=						x
# PS	--port=						x
# PS	--level=					x
#
# monitor						x
#	--hsync=					x
#	--vsync=					x
#	--monitor=					x
#	--noprobe=					x
#
# mouse
#	--device=		x	x	x
#	--emulthree		x	x	x
#
# network
# OK	--bootproto=		x	x	x	x
# OK	--device=		x	x	x	x
# OK	--ip=			x	x	x	x
# OK	--gateway=		x	x	x	x
# OK	--nameserver=		x	x	x	x
# OK	--nodns			x	x	x	x
# OK	--netmask=		x	x	x	x
# 	--hostname=		x	x	x	x
# OK	--ethtool=					x
# OK	--essid=					x
# OK	--wepkey=					x
# OK	--onboot=					x
#	--class=					x
#	--mtu=						x
#	--noipv4=					x
# OK	--noipv6=					x
#
# multipath						x
#	--name=						x
#	--device=					x
#	--rule=						x
#
# part
# OK	swap --recommended	x	x	x	x
# NOSUP	--size=			x	x	x	x
# NOSUP	--grow			x	x	x	x
# NOSUP	--maxsize=		x	x	x	x
# NOSUP	--noformat		x	x	x	x
# OK	--onpart=		x	x	x	x
# OK	--ondisk=		x	x	x	x
# OK   	--asprimary		x	x	x	x
# OK	--bytes-per-inode=	x	x	x	x
# OK	--fstype=		x	x	x	x
# OK	--start=		x	x	x	x
# OK	--end=			x	x	x	x
# NOSUP	--badblocks		x	?
# NOSUP	--recommended					x
# NOSUP	--onbiosdisk					x
#
# raid
# OK	--level=		x	x	x	x
# OK	--device=		x	x	x	x
# OK	--spares=		x	x	x	x
# OK	--fstype=		x	x	x	x
# NOSUP	--fsoptions=					x
# NOSUP	--noformat		x	x	x	x
# NOSUP	--useexisting			?	x	x
# OK	--bytes-per-inode				x
#
# repo							x
#	--name=						x
#	--baseurl=					x
#	--mirrorlist=					x
#
# rootpw
# OK	--iscrypted		x	x	x	x
#
# selinux				?	x	x
# OK	--enforcing			?	x	x
# OK	--permissive			?	x	x
# OK	--disabled			?	x	x
#
# services						x
# PS	--disabled					x
# PS	--enabled					x
#
# skipx	
# OK				x	x	x	x
#
# timezone
# OK	--utc			x	x	x	x
#
# user							x
#	--name=						x
#	--groups=					x
#	--homedir=					x
#	--password=					x
#	--iscrypted=					x
#	--shell=					x
#	--uid=						x
#
# vnc							x
#	--host=						x
#	--port=						x
#	--password=					x
#
# volgroup			x	x	x	x
# NOSUP	--noformat			?	x	x
# NOSUP	--useexisting			?	x	x
# OK	--pesize=					x
#	
# xconfig
#	--driver=					x
#	--noprobe		x	x	x
#	--card=			x	x	x
#	--videoram=		x	x	x	x
#	--monitor=		x	x	x
#	--hsync=		x	x	x
#	--vsync=		x	x	x
# OK	--defaultdesktop=	x	x	x	x
# OK	--startxonboot		x	x	x	x
#	--resolution=		x	x	x	x
#	--depth=		x	x	x	x
#
# zfcp 						x
#	--devnum=					x
#	--fcplun=					x
#	--scsiid=					x
#	--scsilun=					x
#	--wwpn=						x
#
# -----------------------------------------------------------------
# Other Configuration saved:
# - network bonding
# - syslog
# -----------------------------------------------------------------
#

use strict;
use File::Basename;
use XML::Simple;
use Data::Dumper;

# -----------------------------------------------------------------
# Global Variables:
# -----------------------------------------------------------------
my $C_STDOUT 	= "/tmp/kickgen.out";
my $C_PROMPT	= "y";
my $C_ONERROR	= "exit";
my $C_ERRCOUNT	= 0;
my $C_WARNCOUNT	= 0;
my $C_VERBOSE	= 1;

use constant RH9   => 9;
use constant RHEL3 => 13;
use constant RHEL4 => 14;
use constant RHEL5 => 15;
my $C_VERSION	= RHEL5;	# default version
my $C_VERSION_STRING = "";
my $C_ARCH_STRING = "";
my $C_SUBVERSION_DIR = "rhel5"; # set the subdir name of ./comps/

my %C_DISK_LIST = ();		# Disks to be partitioned
my %C_EXCLUDE_DISK = ( );	# Disks to NOT partition
my %C_CREATED_PART = ( );	# List of create partitions
my $C_RAID_NU = "10";		# starting index for RAID part creation
my $C_POST_SCRIPT = "";


# List of configuration files to copy:
my @C_COPYFILES = ();
my @C_EXTRA_PKGS = ( );		# pkg installed not from the distro


# Initialization:
# --------------
unlink($C_STDOUT);

GetRHVersion();
if ($C_VERSION_STRING eq "") {
	Error("Could not determine the RedHat Version !");
}

ScanDisks();

# kickstart file creation starts here:
# -----------------------------------
OutputKick("# File generated by kickgen.pl for RedHat Version $C_VERSION_STRING architecture $C_ARCH_STRING :");

# Installation method:
# -------------------
SetInstallMethod();

# System Language:
# ---------------
SetSystemLang();

# Keyboard Mapping:
# ----------------
SetKeyboardMapping();

# X Configuration:
# ---------------
SetXConf();

# Network Configuration:
# ---------------------
my @interfaces = glob("/etc/sysconfig/network-scripts/ifcfg-*");
for my $ifconf (@interfaces) {
	SetNetwork($ifconf);
	AddCopyFile($ifconf);
}

# Root Password:
# -------------
SetRootPassword();

# Firewall:
# --------
CreateFirewall();

# Authconfig:
# ----------
AuthConfig();

# SELinux:
# -------
SetSELinux();

# Timezone:
# --------
SetTimezone();

# Bootloader:
# ----------
CheckBootLoader();

# Partitions:
# ----------
ClearPart();
CreatePart();

# Handle services:
# ---------------
#SetServices();

# Packages:
# --------
OutputKick("");
OutputKick("%packages");
InstallPackages();

# Add more Configuration File to save:
# -----------------------------------
# remote logging is supported by RHEL5, but it is not sufficient:
# the Admin could have changed the file:
AddCopyFile("/etc/sysconfig/syslog");
AddCopyFile("/etc/syslog.conf");

# Post-Installation script:
# ------------------------
OutputKick("");
OutputKick("%post");

# Add a comment for each package that could not be installed:
OutputKick("# List of installed packages not belonging to the Distro:");
foreach my $pkg (@C_EXTRA_PKGS) {
	OutputKick("# $pkg");
}

OutputKick($C_POST_SCRIPT);
OutputKick("#EOF");

# Run custom FAO post-install
OutputKick('tmpfile=$(/bin/mktemp)');
OutputKick('/usr/bin/wget http://git.fao.org/\?p=fao_post_install.git\;a=blob_plain\;f=post_install.sh\;hb=HEAD -O $tmpfile');
OutputKick('/bin/bash $tmpfile 2>&1 > post_install.log');


# Copy the configuration files:
OutputKick("BackupFile() {");
OutputKick("\tif [ -e \"\$1\" ]; then");
OutputKick("\tmv \"\$1\" \"\$1.bak\"");
OutputKick("\tfi");
OutputKick("}\n");
foreach my $f (@C_COPYFILES) {
	#next;
	open(FD,"<$f") or Error("Could not open Configuration File %f");
	my @lines = <FD>;
	close(FD);
	OutputKick("# Set Configuration file '$f':");
	# Save the former file if it exists:
	OutputKick("BackupFile(\"$f\")");
	OutputKick("cat <<END >$f");
	foreach my $l (@lines) {
		chomp $l;
		OutputKick($l);
	}
	OutputKick("END");
	OutputKick("");
}

DumpFSInfo();

# Internal Functions:
# ------------------
sub GetRHVersion
{
	my $uname = `uname -r`;
	my @v = split(/[\.-]/,$uname);
	if ($v[1] eq "4") {
		if ($v[2] eq "20") { $C_VERSION = RH9; $C_VERSION_STRING = "RH.9"; }
		if ($v[2] eq "21") { $C_VERSION = RHEL3; $C_VERSION_STRING = "RHEL3"; }
	}
	elsif ($v[1] eq "6") {
		if ($v[2] eq "9") { $C_VERSION = RHEL4; $C_VERSION_STRING = "RHEL4"; }
		if ($v[2] eq "18") { $C_VERSION = RHEL5; $C_VERSION_STRING = "RHEL5"; }
	}
	$C_ARCH_STRING = `uname -i`;
	chomp $C_ARCH_STRING;  
}

sub AddPostScript
{
	$C_POST_SCRIPT .= $_[0]."\n";
}

sub AddCopyFile
{
	if (-f $_[0]) {
		push(@C_COPYFILES,$_[0]);
	}
}

sub AddCopyFiles
{
	my @files = glob($_[0]);
	foreach my $f (@files) {
		if (-d $f) {
			AddCopyFiles("$f/*");
			next;
		}
		AddCopyFile($f);
	}
}

sub SetInstallMethod
{
	# TODO:
	OutputKick("install");
}

sub SetSystemLang
{
	my $f_i18n="/etc/sysconfig/i18n";
	my $lang = "en_US";
	if (! -f $f_i18n ) {
		Warning("File $f_i18n missing - Could not determine the System Language");
	}
	else {
		$lang=`grep "^LANG=" $f_i18n | cut -d'"' -f2`;
		chomp $lang;
	}

	OutputKick("lang $lang");
}

sub SetKeyboardMapping
{
	my $f_keyb="/etc/sysconfig/keyboard";
	my $keytable = "us";
	if (! -f $f_keyb) {
		Warning("File $f_keyb missing - Could not determine the Keyboard Mapping");
	}
	else {
		$keytable=`grep "^KEYTABLE=" $f_keyb | cut -d'"' -f2`;
		chomp $keytable;
	}

	OutputKick("keyboard $keytable");
}

sub SetXConf
{
	my $ret = system("type X >/dev/null 2>/dev/null");
	if ($ret) {
		Warning("X Window does not seem to be installed here");
		OutputKick("skipx");
	}
	else {
		my $xstartonboot = "";
		my $initdflt = `grep "^id:.*:initdefault" /etc/inittab | cut -d: -f2`;
		chomp $initdflt;
		if ("$initdflt" eq "5") { 
			$xstartonboot = "--startxonboot";
		}

		my $defaultdesktop = `grep -i DESKTOP /etc/sysconfig/desktop | cut -d= -f2`;
		chomp $defaultdesktop;
		if ($defaultdesktop ne "") { $defaultdesktop = "--defaultdesktop=$defaultdesktop"; }

		# option --card is not provided so the card type will be determined automatically
		# option --monitor, --hsync and --vsync are not provided so the monitor type will be determined automatically

		# Note: since the videocard and the monitor may differ, let Kickstart find the good ones:
		OutputKick("xconfig $xstartonboot $defaultdesktop");
	}
}

sub SetRootPassword
{       # set to default root passwd rather grabbing the actual one 
	#my $rootpwd = `grep "^root:" /etc/shadow | cut -d: -f2`;
	my $rootpwd = '$1$MU.LQte3$rAr0zFvfTcpb7ve4WYtkR0';
	chomp $rootpwd;
	my $prefx = substr($rootpwd,0,3);
	my $is_crypted = "";
	if ("$prefx" eq '$1$') {
		$is_crypted="--iscrypted"
	}
	OutputKick("rootpw $is_crypted $rootpwd");
}

sub CreateFirewall
{
	# The firewall rules are stored by copying a conf file
	# it is hard and unuseful to reverse-engineer the rules
	AddCopyFile("/etc/sysconfig/iptables");
	OutputKick("firewall --disabled");
}

sub AuthConfig
{
	my $enable_md5 = "";
	my $enable_shadow = "";
	my $enable_nis = "";
	my $enable_nisdomain = "";
	my $enable_nisserver = "";
	my $enable_cache = "";
	my $enable_ldap = "";
	my $enable_ldapauth = "";
	my $ldap_server = "";
	my $ldap_basedn = "";
	my $ldap_usetls = "";
	my $enable_krb5 = "";
	my $krb5realm	= "";
	my $krb5kdc	= "";
	my $krb5adminserver = "";

	my @files = glob("/etc/pam.d/*");
	foreach my $f (@files) {
		open(FD,"<$f") or next;
		my @lines = <FD>;
		close(FD);
		# Unix + shadow + md5
		my @good  = grep(/^password.*pam_unix/,@lines);
		foreach my $g (@good) {
			if ($g =~ /md5/) {
				$enable_md5="--enablemd5";
			}
			if ($g =~ /shadow/) {
				$enable_shadow="--enableshadow";
			}
			if ($g =~ /nis/) {
				$enable_nis="--enablenis";
				CheckNIS(\$enable_nisdomain,\$enable_nisserver);
			}
		}

		@good = grep(/^auth.*pam_ldap/,@lines);
		if (scalar(@good) && !$enable_ldap) {
			CheckLdap(\$enable_ldap,\$enable_ldapauth,\$ldap_server,
				  \$ldap_basedn,\$ldap_usetls); 
		}
		@good = grep(/^auth.*pam_krb5/,@lines);
		if (scalar(@good) && !$enable_krb5) {
			CheckKrb5(\@good,\$enable_krb5,\$krb5realm,\$krb5kdc,
				  \$krb5adminserver); 
		}
	}

	# Check if nscd daemon running:
	my $pid = `pidof nscd`;
	chomp $pid;
	if ($pid ne "") {
		$enable_cache="--enablecache";
		AddCopyFile("/etc/nscd.conf");
	}

	OutputKick("authconfig $enable_cache $enable_md5 $enable_shadow $enable_nis $enable_nisdomain $enable_nisserver $enable_ldap $enable_ldapauth $ldap_server $ldap_basedn $ldap_usetls $enable_krb5 $krb5realm $krb5kdc $krb5adminserver");
}

sub CheckNIS
{
	my ($enable_nisdomain,$enable_nisserver) = @_;
	
	my $nis_conf = "/etc/yp.conf";
	if (! -f $nis_conf) { return; }

	my @good = `grep "^domain " $nis_conf 2>/dev/null`;
	if (scalar(@good) > 1) {
		Warning("More then one Domain defined in '$nis_conf'");
	}

	my $line = $good[0];
	$line =~ s/^[[:space:]]+/ /g;
	my (undef,$nisdomain,undef,$nisserver) = split(/ /,$line);
	if ($nisdomain) { $$enable_nisdomain = "--nisdomain=$nisdomain"; }
	if ($nisserver) { $$enable_nisserver = "--nisserver=$nisserver"; }
}

sub CheckLdap
{
	my ($enable_ldap,$enable_ldapauth,$ldap_server,$ldap_basedn,$ldap_usetls) = @_; 

	my $ldap_conf = "/etc/ldap.conf";
	if (! -f $ldap_conf) { return; }

	$$enable_ldapauth="--enableldapauth";

	my @good = `grep "^passwd.*:.*ldap" /etc/nsswitch.conf`;
	if (scalar(@good) && scalar(@good)) {
		$$enable_ldap="--enableldap";
	}

	open(FD,"<$ldap_conf") or return;
	my @lines = <FD>;
	close(FD);

	foreach my $l (@lines) {
		if ($l =~ /^base[[:space:]]+(.*)/) {
			$$ldap_basedn = "--ldapbasedn=$1";
			next;
		}
		if ($l =~ /^uri[[:space:]]+(.*)/) {
			$$ldap_server = "--ldapserver=$1";
			next;
		}
		if ($l =~ /^ssl[[:space:]]+start_tls/) {
			$$ldap_usetls = "--enableldaptls";
			next;
		}
	}

	if ($$ldap_server eq "") {
		Warning("This system uses LDAP for authentication - but I could not determine the LDAP Server in use");
		return;
	}
	if ($$ldap_basedn eq "") {
		Warning("This system uses LDAP for authentication - but I could not determine the base suffix");
		return;
	}

	AddCopyFile($ldap_conf);
}

sub CheckKrb5
{
	my ($goodlines,$enable_krb5,$krb5realm,$krb5kdc,$krb5adminserver) = @_; 

	my $krb5_conf = "/etc/krb5.conf";
	if (! -f $krb5_conf) { return; }

	$$enable_krb5="--enablekrb5";

	open(FD,"<$krb5_conf") or return;
	my @lines = <FD>;
	close(FD);

	my ($inrealms,$inrealm) = 0;
	my $pat = "";
	foreach my $l (@lines) {
		chomp $l;
		if ($l =~ /default_realm[[:space:]]+=[[:space:]]+(.*)/) {
			Verbose("realm=$1");
			$pat = $1;
			$$krb5realm = "--krb5realm=$1";
			$pat =~ s/\./\\./g;
			next;
		}
		if ($l =~ /\[realms\]/i) {
			$inrealms = 1;
			next;
		}
		if ($l =~ /\[.*\]/) {
			$inrealms = 0;
			next;
		}
		if ($inrealm) {
			print "$l\n";
			if ($l =~ /kdc.*=[[:space:]]*(.*)/i) {
				if ($$krb5kdc eq "") { $$krb5kdc = "--krb5kdc=$1"; }
				else { $$krb5kdc .= ",$1"; }
				next;
			}
			if ($l =~ /admin_server.*=[[:space:]]*(.*)/i) {
				$$krb5adminserver = "--krb5adminserver=$1";
				next;
			}
			if ($l =~ /}/) {
				$inrealm = 0;
				next;
			}
		}
		if ($inrealms && $l =~ /$pat/i) {
			$inrealm = 1;
			next;
		}
	}

	# Check for the "realm=" option with pam_krb5:
	# it overwrites /etc/krb5.conf
	if ($$goodlines[0] =~ /realm=([^[:space:]]*)/) {
		Verbose("Kerberos Realm overriden in PAM Configuration");
		$$krb5realm = "--krb5realm=$1";
	}

	if ($$krb5kdc eq "") {
		Warning("This system uses Kerberos 5 for authentication - but I could not determine the KDC in use");
		return;
	}

	AddCopyFile($krb5_conf);
}

sub SetSELinux
{
	if ($C_VERSION >= RHEL4) {
		my $selinux = `getenforce 2>/dev/null`;
		chomp $selinux;
		if ($selinux ne "") {
			OutputKick("selinux --".lc($selinux));
		}
	}
}

sub SetTimezone
{
	my $f_clock = "/etc/sysconfig/clock";
	my $utc = "";
	my $timezone = "";
	if (! -f $f_clock) {
		Warning("File $f_clock missing - Could not determine the timezone");
	}
	else {
		$utc = `grep -i "^UTC=true" $f_clock`;
		chomp $utc;
		if ($utc ne "") {
			$utc = "--utc";
		}

		$timezone = `grep -i "^Zone" $f_clock`;
		chomp $timezone;
		$timezone =~ s/Zone="(.*)"/$1/i;
	}

	OutputKick("timezone $utc $timezone");
}

sub CheckBootLoader
{
	my $boot_append = "";
	my $boot_location = "";
	my $boot_password = ""; # --password or --md5pass

	my $grub_conf = "/boot/grub/grub.conf";
	if (! -f $grub_conf) {
		CheckLilo();
		return;
	}

	open(FD,"<$grub_conf") or return;
	my @lines = <FD>;
	close(FD);

	AddCopyFile($grub_conf);

	my $kernel = `uname -r`;
	chomp $kernel;

	my @good = grep(/kernel.*vmlinuz-$kernel/,@lines);
	if (scalar(@good) == 0) {
		Error("Could not determine the kernel options at boot time");
		return;
	}
	if (scalar(@good) > 1) {
		Error("There is more than one line in grub.conf matching the current kernel version");
		return;
	}
	
	$boot_append = @good[0];
	chomp $boot_append;

	$boot_append =~ s/^.*kernel.*vmlinuz-$kernel[[:space:]]+([^[:space:]]*)/$1/;
	if ("$boot_append" ne "") {
		$boot_append = "--append=\"$boot_append\"";
	}

	# Look for a "password" directive before the first "title"
	# (because it is possible to add a "password" inside a "title")
	foreach my $l (@lines) {
		if ($l =~ /^password.*--md5[[:space:]]+([^[:space:]]+)/) {
			$l =~ s/^password.*--md5[[:space:]]+//;
			$boot_password="--md5pass $l";
			last;
		}
		if ($l =~ /^password/) {
			$l =~ s/^password[[:space:]]+//;
			$boot_password="--password $l";
			last;
		}
		if ($l =~ /^title/) {
			last;
		}
	}

	OutputKick("bootloader $boot_append $boot_location $boot_password");
}

sub CheckLilo
{
	my $lilo_conf = "/etc/lilo.conf";

	my $ret = system("lilo -q");
	if ($ret) {
		Error("Could not determine the Bootloader (should be Lilo ?)");
		return;
	}

	if (! -f $lilo_conf) {
		Error("Could not determine the Bootloader (should be Lilo ?)");
		return;
	}

	# TODO: no Lilo support
	Error("LILO not supported");
}

sub AddDisk
{
	my ($disk) = @_;

	if (!exists($C_DISK_LIST{$disk})) { 
		Verbose("Adding Disk $disk");
		$C_DISK_LIST{$disk} = 1; 
	}
}

sub AddRaidDisk
{
	my ($a_disk) = @_;

	Verbose("Adding RAID Disk $a_disk");

	# Get the RAID configuration using /proc/mdstat (works in every case):
	# md0 : active raid1 sdb2[0] sdb3[1]
	my @mdstat = `cat /proc/mdstat | grep $a_disk`;
	my @parts = split(/ /,$mdstat[0]);
	foreach my $part (@parts) {
		if ($part =~ /(.*)\[.*\]/) {
			my $a_disk = GetDiskFromPart($1);
			AddDisk($a_disk);
		}
	}
}

sub AddHPRaidDisk
{
	my ($a_part) = @_;

	Verbose("Adding HP RAID part $a_part");
	
	# all HP RAID drives are in /dev/cciss
	my $a_disk = GetDiskFromPart($a_part);
	Verbose("Added HP disk $a_disk");
	AddDisk($a_disk);
}

sub ScanDisks
{
	Verbose("Entering ScanDisks()");

	# We analyse the currently mounted FS to get the names of:
	# the system disks, the software RAID devices, the LVM components:

	# /dev/sda3 on / type ext3 (rw)
	my @mount_list = `mount | grep "^/dev"`;
	foreach my $mount_info (@mount_list) {
		chomp $mount_info;
		my ($part,undef,$mount_point) = split(/ /,$mount_info);
		Verbose("Checking partition $part");
		my (undef,undef,$second_part) = split(/\//,$part);
		Verbose("Second part is $second_part");
		my $a_disk = GetDiskFromPart($second_part);
		Verbose("a_disk is $a_disk");

		# Standard Disk (IDE or SCSI) ?
		if (IsDiskSCSI($a_disk) || IsDiskIDE($a_disk)) {
			AddDisk($a_disk);
			next;
		}
			
		# Software RAID ?
		if (IsDiskRAID($a_disk)) {
			AddRaidDisk($second_part);
			next;
		}
		
		# HP HW RAID?
		if (IsDiskHPRAID($a_disk)) {
		#	print "$\n";
			my (undef,undef,undef, $third_part) = split(/\//,$part);
			Verbose("found 3rd part $third_part");
			AddHPRaidDisk("$second_part/$third_part");
			next;
		}

		Verbose("not a physical disk");
	}

	# LVM ?
	# $disktype can be anything: "mapper" or vg_name
	my @lvs = `lvdisplay -c 2>/dev/null`;
	my @pvs = `pvdisplay -c 2>/dev/null`;
	foreach my $lv (@lvs) {
		chomp $lv;
		$lv =~ s/^[[:space:]]+//g;
		my ($logvol,$volgroup,undef,undef,undef,undef,$volsize) = split(/:/,$lv);
		my (undef,undef,undef,$logname) = split(/\//,$logvol);
		Verbose("Checking Logical Volume $volgroup-$logname");

		# the logical volume must appear in the "mount_list"
		foreach my $mount_info (@mount_list) {
			chomp $mount_info;
			if ($mount_info !~ /$logname/) { 
				next; 
			}
			Verbose("mounted: determine the Physical Volume");

			# Analyse the Volume Group and add the Physical Volume in list of disk:
			foreach my $pv (@pvs) {
				my $a_disk = "";
				chomp $pv;
				$pv =~ s/^[[:space:]]+//g;
				my ($device,$volgroup2) = split(/:/,$pv);

				if ($volgroup ne $volgroup2) { next; }
			
				if ($device =~ m/.*cciss.*/){
					my (undef,undef,$second_part,$third_part) = split(/\//,$device);
					$a_disk = GetDiskFromPart("$second_part/$third_part");
				} else {
					my (undef,undef,$second_part) = split(/\//,$device);
					$a_disk = GetDiskFromPart($second_part);
				}

				# Raid Device ?
				if ($device =~ /\/dev\/md/) {
					AddRaidDisk($a_disk);
					next;
				}

				AddDisk($a_disk);
			}
		}
	}
}

sub ClearPart
{
	# Build the disk list to clear from %C_DISK_LIST and %C_EXCLUDE_DISK:
	my $drives = "";
	my $first_disk = 1;
	foreach my $disk (keys %C_DISK_LIST) {
		if (exists($C_EXCLUDE_DISK{$disk})) { next; }
		if (!$first_disk) { $drives .= ","; }
		$first_disk = 0;
		$drives .= "$disk";
	}

	OutputKick("clearpart --drives=$drives");
}

sub CreatePart
{
	Verbose("Entering CreatePart()");

	# Create partitions for the disk listed in %C_DISK_LIST but not in %C_EXCLUDE_DISK:
	my @mount_list = `mount | grep "^/dev"`;
	my $mount_part = "";
	foreach my $mount_info (@mount_list) {
		chomp $mount_info;
		my ($mount_dev,undef,$mount_point,undef,$fstype) = split(/ /,$mount_info);
		Verbose("Mount_dev is $mount_dev");
		if ($mount_dev =~ m/.*cciss.*/){
			my (undef,undef,$mount_part1, $mount_part2) = split(/\//,$mount_dev);
			$mount_part = "$mount_part1/$mount_part2";
		} else {
			(undef,undef,$mount_part) = split(/\//,$mount_dev);
		}
		Verbose("Mount_part is $mount_part");
		my $a_disk = GetDiskFromPart($mount_part);
		if ($a_disk =~ /map/) { next; }
		#Verbose("Must partition $a_disk ?");

		if (IsDiskRAID($a_disk)) {
			CreatePartRAID($mount_dev,$mount_point,$fstype);
			next;
		}

		# IDE or SCSI:
		if (exists($C_DISK_LIST{$a_disk}) && !exists($C_EXCLUDE_DISK{$a_disk})) {
			my $geometry = `fdisk -l /dev/$a_disk | grep '^$mount_dev'`;
			chomp $geometry;
			$geometry =~ s/[[:space:]]+/ /g;
			my ($first_cyl,$last_cyl) = GetPartCyl($mount_dev);
			my $bytes_per_inode = GetBytesPerInode($mount_dev);
			MemorizePart($mount_part);
			my $asprimary = IsPrimaryPart($mount_part) ? "--asprimary" : "";
			OutputKick("part $mount_point --fstype=$fstype $asprimary --bytes-per-inode=$bytes_per_inode --ondisk=$a_disk --onpart=$mount_part");
		}
	}

	# Is there some LVM located on the System Disk ?
	my @pvs = `pvdisplay -c 2>/dev/null`;
	my %vgs = ();

	# Create the Physical Volumes:
	my $pvid = 1;
	foreach my $pv (@pvs) {
		chomp $pv;
		$pv =~ s/^[[:space:]]+//g;
		my ($device,$volgroup) = split(/:/,$pv);
		# unintuitively, I grab the size of the pv from the volgroup 
		#my @vgprops = split(/:/, `vgdisplay -c $volgroup`);
		# munge the data
	    	#my $pv_size = (@vgprops[11] - .1 * @vgprops[11])/1000000; 
		# get rid of decimals
		#$pv_size =~ s/(.*)\.[0-9]+/$1/;
		#Verbose("pv_size is $pv_size");
		
		if (IsDiskRAID($device)) {
			CreatePartRAID($device,undef,$pvid);
			$pvid++;
			next;
		}

		# Standard Device:
		my $part = substr($device,5);
		my $a_disk = GetDiskFromPart($part);
		if (exists($C_DISK_LIST{$a_disk}) && !exists($C_EXCLUDE_DISK{$a_disk})) {
			if (!exists($vgs{$volgroup})) { $vgs{$volgroup} = (); }
			push(@{$vgs{$volgroup}},$pvid); 
			my ($first_cyl,$last_cyl) = GetPartCyl($device);
			MemorizePart($part);
			my $asprimary = IsPrimaryPart($part) ? "--asprimary" : "";
			OutputKick("part pv.$pvid $asprimary --size=100 --start=$first_cyl --end=$last_cyl --ondisk=$a_disk --onpart=$part");
			$pvid++;
		}
		else {
			# If we dont' create the PV, the VG will be incomplete !
			Warning("PV '$device' not create because it is not listed in the Disk List or it belongs to a Excluded Disk");
		}
	}

	# Create the Volume Groups:
	foreach my $k (keys %vgs) {
		my $volattr = `vgdisplay -c $k 2>/dev/null`;
		chomp $volattr;
		$volattr =~ s/^[[:space:]]+//g;
		my @parts = split(/:/,$volattr);
		my $pesize = $parts[12];
		my $volgroup = "volgroup $k --pesize=$pesize";
		foreach my $p (@{$vgs{$k}}) {
			$volgroup .= " pv.$p";
		}
		OutputKick($volgroup);
	}

	# Create the Logical Volume:
	my @lvs = `lvdisplay -c 2>/dev/null`;
	foreach my $lv (@lvs) {
		chomp $lv;
		$lv =~ s/^[[:space:]]+//g;
		my ($logvol,$volgroup,undef,undef,undef,undef,$volsize) = split(/:/,$lv);
		my (undef,undef,$vgname,$logname) = split(/\//,$logvol);

		# Must belong to a previously created VolGroup:
		if (!$vgs{$volgroup}) { next; }

		my @mount_list = `mount`;
		foreach my $m (@mount_list) {
			#chomp $m;
			my @m_list = split('\s', $m);
			my $m_name = @m_list[0];
			#print "$m_name\n";
			if ($m_name !~ /^.*$vgname.*$logname$/) { next; }

			my $bytes_per_inode = "";
			if ($C_VERSION >= RHEL5) {
				$bytes_per_inode = "--bytes-per-inode=".GetBytesPerInode($logvol);
			}

			my ($mount_dev,undef,$mount_point,undef,$fstype) = split(/ /,$m);
			$volsize = int($volsize / 2048); # because it must be specified in MB and not in block of 512 bytes

			OutputKick("logvol $mount_point --fstype=$fstype --name=$logname --vgname=$volgroup --size=$volsize $bytes_per_inode");
		}
	}

	# Create the swap zones:
	my @swaps = `swapon -s`;
	for my $sw (@swaps) {
		$sw =~ s/[[:space:]]+/ /g;
		if (substr($sw,0,1) != "/") { next; }
		my ($device,$swap_type,$swap_size) = split(/ /,$sw);
		# change size so it is in MB not KB 
		$swap_size = $swap_size/1000;
		$swap_size =~ s/(.*)\.[0-9]+/$1/;
		
		# is it a file ?
		if ($swap_type eq "file") {
			AddPostScript("/bin/dd if=/dev/zero of=$device bs=1024 count=$swap_size");
			AddPostScript("/sbin/mkswap $device");
			AddPostScript("/sbin/swapon $device");
			next;
		}

		# is it a partition on a Disk ?
		my $part = substr($device,5);
		Verbose("Swap partition is $part");
		my $a_disk = GetDiskFromPart($part);
		if (exists($C_DISK_LIST{$a_disk}) && !exists($C_EXCLUDE_DISK{$a_disk})) {
			my ($first_cyl,$last_cyl) = GetPartCyl($device);
			MemorizePart($part);
			my $asprimary = IsPrimaryPart($part) ? "--asprimary" : "";
			OutputKick("part swap $asprimary --size=$swap_size --start=$first_cyl --end=$last_cyl --ondisk=$a_disk --onpart=$part");
			next;
		}

		# is it a logical volume ?
		foreach my $k (keys %vgs) {
			if ($device =~ /mapper/) {
				my (undef,undef,undef,$devname) = split(/\//,$device);
				my ($vg,$lv) = split(/-/,$devname);
				$device = "/dev/$vg/$lv";
				# because lvdisplay does not work with /dev/mapper...
			}
			if ($device =~ /$k/) {
				my @lvs = `lvdisplay -c $device 2>/dev/null`;
				my $lv = $lvs[0];
				chomp $lv;
				$lv =~ s/^[[:space:]]+//g;
				my ($logvol,$volgroup,undef,undef,undef,undef,$volsize) = split(/:/,$lv);
				my (undef,undef,$vgname,$logname) = split(/\//,$logvol);
				$volsize = int($volsize / 2048); # because it must be specified in MB and not in block of 512 bytes
				OutputKick("logvol --fstype=swap --vgname=$k --name=$logname --size=$volsize");
			}
		}
	}
}

# $1 = /dev/md0
sub CreatePartRAID
{
	my ($device,$mount_point,$fstype) = @_;

	# Get the RAID configuration using /proc/mdstat (works in every case):
	# md0 : active raid1 sdb2[0] sdb3[1] sdd4(S)
	my $a_disk = substr($device,5);
	my @mdstat = `cat /proc/mdstat | grep $a_disk`;
	if (scalar(@mdstat) < 1) {
		Error("Could not determine the structure of RAID Device $device");
		return;
	}

	my $raid_dev = "";
	my @items = split(/ /,$mdstat[0]);
	my $level = uc($items[3]);
	my $spares = 0;
	foreach my $item (@items) {
		if ($item =~ /(.*)\[.*\]/) {
			my $part = $1;
			my $disk = GetDiskFromPart($part);

			# All disks must belong to the list:
			if (!exists($C_DISK_LIST{$disk}) || exists($C_EXCLUDE_DISK{$disk})) {
				# this is an error if at least one RAID component has been created:
				if ($raid_dev ne "") {
					Error("The RAID Device $device spans on multiple Disks. Some of them are excluded ($disk). The RAID cannot be re-created.");
				}
			}

			# Do not try to recreate disk not on block device
			if (!IsDiskIDE($disk) && !IsDiskSCSI($disk)) {
				Error("Don't know how to re-create a RAID device on Disk /dev/$part (not a block device ?)");
			}

			my ($first_cyl,$last_cyl) = GetPartCyl("/dev/$part");
			my $asprimary = IsPrimaryPart($part) ? "--asprimary" : "";
			OutputKick("part raid.$C_RAID_NU $asprimary --start=$first_cyl --end=$last_cyl --ondisk=$disk --onpart=$part");
			$raid_dev .= " raid.$C_RAID_NU";
			$C_RAID_NU++;
		}
		if ($item =~ /(.*)\[.*\]\(S\)/) {
			$spares++;
		}
	}

	# Create the RAID Device for direct mounting or as a PV ?
	if ($mount_point ne undef) {
		my $bytes_per_inode = "";
		if ($C_VERSION >= RHEL5) {
			$bytes_per_inode = "--bytes-per-inode=".GetBytesPerInode($device);
		}
		OutputKick("raid $mount_point --fstype=$fstype $bytes_per_inode --level=$level --device=$a_disk --spares=$spares $raid_dev");
	}
	else {
		# It is a PV: $fstype is the pvid
		OutputKick("raid pv.$fstype --level=$level --device=$a_disk --spares=$spares $raid_dev");
	}
}

# $1 = sda1
sub MemorizePart
{
	my ($part) = @_;

	# Consistency check to make sure we are not trying to partition
	# twice the same device:
	if (exists($C_CREATED_PART{$part})) {
		Error("Partition $part already created");
		return;
	}

	$C_CREATED_PART{$part} = 1;
}

# $1 = sda1 
sub GetDiskFromPart
{
	my ($part) = @_;
	my $disk = "";	
	# sanity check, strip off any leading /dev/
	if($part =~ m/\/dev\/.*/){
		$part =~ s/\/dev\/(.*)/$1/;
	}	
	
	if ($part =~ m/(cciss.*)p./){
		$disk = $1;
	} elsif ($part =~ /([[:alpha:]]+)/){
		$disk =$1;
		Verbose("found disk $disk");
	}
	return $disk;
}

sub IsDiskIDE
{
	return IsDiskOfType($_[0],"hd");
}

sub IsDiskSCSI
{
	return IsDiskOfType($_[0],"sd");
}

sub IsDiskRAID
{
	return IsDiskOfType($_[0],"md") ;
}

sub IsDiskHPRAID
{
	# HP smart array hw RAID starts with a "cciss"
 	return  IsDiskOfType($_[0],"cc")
}

sub IsDiskOfType
{
	my ($disk,$type) = @_;
	if (substr($disk,0,2) eq $type) { return 1; }
	return index($disk,"/$type") >= 0;
}

# $1 = sda1
sub IsPrimaryPart
{
	my ($part) = @_;
	
	# Determine the extended partition and check if
	# the given partition is included in this part:
	my $a_disk = GetDiskFromPart($part);
	my ($ext_part,$ext_first_cyl,$ext_last_cyl) = GetExtendedPart($a_disk);
	if ($ext_part eq undef) { return; }

	my ($first_cyl,$last_cyl) = GetPartCyl("/dev/$part");
	return ($first_cyl < $ext_first_cyl || $last_cyl > $ext_last_cyl); 
}

# $1 = sda
sub GetExtendedPart
{
	my ($disk) = @_;
	my @parts = `fdisk -l /dev/$disk | grep '^/dev/$disk' 2>/dev/null`;
	foreach my $part_desc (@parts) {
		chomp $part_desc;
		$part_desc =~ s/[[:space:]]+/ /g;
		my ($part) = split(/ /,$part_desc);
		my $pid = GetPartID($part);
		if ($pid == 5) {
			Verbose("Part '$part' is an Extended Part");
			my ($first_cyl,$last_cyl) = GetPartCyl($part);
			return ($part,$first_cyl,$last_cyl);
		}
	}
	
	Verbose("Disk '$disk' has no Extended Part");
	return (undef,undef,undef);	# no extended part
}

# Input: $fsname=/dev/sda1
sub GetBytesPerInode
{
	my ($fsname) = @_;
	my $block_size  = 0;
	my $block_count = 0;
	my $inode_count = 0;

	my @fsattr = `tune2fs -l $fsname 2>/dev/null`;
	foreach my $l (@fsattr) {
		chomp $l;
		my ($attr,$value) = split(/:/,$l);
		$value =~ s/[[:space:]]//g;
		if ($attr =~ /^block size/i)  { $block_size = $value; next; }
		if ($attr =~ /^block count/i) { $block_count = $value; next; }
		if ($attr =~ /^inode count/i) { $inode_count = $value; next; }
	}

	my $bytes_per_inode = 0;
	if ($inode_count) {
		$bytes_per_inode = ($block_size * $block_count) / $inode_count;
		Verbose("GetBytesPerInode($fsname): Block size=$block_size, Block count=$block_count, Inode count=$inode_count");

		# make sure we got a power of two !
		$bytes_per_inode = (int($bytes_per_inode / 1000)) * 1024;
	}

	return $bytes_per_inode;
}

# Input: $partname=/dev/sda1
sub GetPartCyl
{
	my ($partname) = @_;
	
	#my $diskname = substr($partname,5,3);
	my $diskname = GetDiskFromPart($partname);
	Verbose("GetPartCyl, diskname is $diskname and partname is $partname");
	my $geometry = `fdisk -l /dev/$diskname | grep "$partname"`;
	Verbose("fdisk -l $diskname | grep $partname\n");
	chomp $geometry;
	$geometry =~ s/[[:space:]]+/ /g;
	my (undef,$bootable) = split(/ /,$geometry);
	my ($first_cyl,$last_cyl);
	if ($bootable eq "*") {
		(undef,$bootable,$first_cyl,$last_cyl) = split(/ /,$geometry);
	}
	else {
		(undef,$first_cyl,$last_cyl) = split(/ /,$geometry);
	}

	Verbose("GetPartCyl($partname): Start Cyl=$first_cyl, Last Cyl=$last_cyl");

	return ($first_cyl,$last_cyl);
}

# Input: $partname=/dev/sda1
sub GetPartID
{
	my ($partname) = @_;

	#my $diskname = substr($partname,5,3);
	$partname =~ s/\/dev\/(.*)/$1/;
	my $diskname = GetDiskFromPart($partname);
	Verbose("GetPartID diskname is $diskname and partname is $partname");
	my $geometry = `fdisk -l /dev/$diskname | grep "^/dev/$partname"`;
	Verbose("fdisk -l /dev/$diskname | grep $partname\n");
	chomp $geometry;
	$geometry =~ s/[[:space:]]+/ /g;
	my (undef,$bootable) = split(/ /,$geometry);
	my ($first_cyl,$last_cyl,$pid);
	if ($bootable eq "*") {
		(undef,$bootable,$first_cyl,$last_cyl,undef,$pid) = split(/ /,$geometry);
	}
	else {
		(undef,$first_cyl,$last_cyl,undef,$pid) = split(/ /,$geometry);
	}

	Verbose("GetPartID($partname): Start Cyl=$first_cyl, Last Cyl=$last_cyl, ID=$pid");

	return $pid;
}
sub SetNetwork
{
	my ($ifconf) = @_;

	(my $if = $ifconf) =~ s/.*ifcfg-(.*)/$1/;
	if ($if eq "lo") { return; }

	# The interface must be UP:
	#my $ret = system("/sbin/ifconfig $if 2>/dev/null | grep 'UP.*RUNNING'");
	my $ret = system("/sbin/ifconfig $if 2>/dev/null | grep 'UP' >/dev/null 2>&1");
	if ($ret) { 
		Verbose("Interface $if not active");
		return; 
	}

	Verbose("Getting Interface $if Configuration:");

	my ($ethtool,$essid,$key) = "";
	my ($onboot,$ip,$gateway,$netmask,$hostname,$nameserver) = "";
	my ($ipv6) = "";
	my $bootproto = `grep -i bootproto $ifconf | cut -d= -f2`;
	chomp $bootproto;
	if ($bootproto =~ /dhcp/i || $bootproto =~ /bootp/i) {
		$bootproto = "--bootproto=dhcp";

		# Should set DNS server ?
		my $peerdns = GetNetworkParm($ifconf,"peerdns");
		if ($peerdns =~ /no/i) {
			$nameserver = GetNameServer();
		}
	}
	else {
		$bootproto = "--bootproto=static";

		# Get the static parameters
		$ip = GetNetworkParm($ifconf,"ipaddr","ip");
		if ($ip eq "") {
			Warning("Could not get IP Address for interface $if");
		}

		$gateway = GetNetworkParm($ifconf,"gateway");
		chomp $gateway;
		$netmask = GetNetworkParm($ifconf,"netmask");
		chomp $netmask;	
		$nameserver = GetNameServer();

		AddCopyFile("/etc/resolv.conf");
	}

	if ($C_VERSION >= RHEL5) {
		$ethtool = GetNetworkParm($ifconf,"ethtool_opts","ethtool");
		$essid = GetNetworkParm($ifconf,"essid");
		$key = GetNetworkParm($ifconf,"key");
		$onboot = GetNetworkParm($ifconf,"onboot");

		$ipv6 = `grep -i networking_ipv6 /etc/sysconfig/network | cut -d= -f2`;
		chomp $ipv6;
		if ($ipv6 =~ /yes/i) { $ipv6 = ""; }
		elsif ($ipv6 =~ /no/i) { $ipv6 = "--noipv6"; }
		else { $ipv6 = ""; }
	}
	
	$hostname = GetNetworkParm("/etc/sysconfig/network","hostname");

	# if gateway wasn't specified in ifcfg-eth*, try the network file	
	if ($gateway eq ""){
		$gateway = `grep -i gateway /etc/sysconfig/network | cut -d= -f2`;
		chomp $gateway;
		$gateway = "--gateway=$gateway";
	}

	# Note: interface bonding configuration is saved
	#	because all the ifcfg-* files are restored

	OutputKick("network --device=$if $onboot $ethtool $essid $key $bootproto $ip $gateway $netmask $nameserver $hostname $ipv6");
}

sub GetNetworkParm
{
	my ($ifconf,$parm,$parm2) = @_;

	my $value = `grep -i $parm $ifconf | cut -d= -f2`;
	chomp $value;
	if ($value) {
		if ($parm2 ne undef) {
			return "--$parm2=$value";
		}
		return "--$parm=$value";
	}

	return "";
}

sub GetNameServer
{
	my $nameservers = "--nameserver=";
	my @nss = `grep nameserver /etc/resolv.conf 2>/dev/null`;
	my $hasNS = 0;
	if (scalar(@nss)) {
		foreach my $ns (@nss){
			chomp $ns;
			if ($hasNS == 0){
				$ns =~ s/nameserver[[:space:]]+(.*)/$1/;
				$nameservers = "$nameservers$ns";
				$hasNS = 1;		
			} else {
				$ns =~ s/nameserver[[:space:]]+(.*)/$1/;
				$nameservers = "$nameservers,$ns";
			}
			
		}
		return $nameservers;
	}

	return "--nodns";
}

sub SetServices
{
	# Note: starting with RHEL5, services can be handled in the Kickstart file
	#	otherwise, they are configured in the Post installation script
	# 	But it is simple to always use the PS script.

	# Note: we don't use "chkconfig --list" because the output is localized
	#	we scan the rc?.d directories instead

	my @services = glob("/etc/init.d/*");
	for my $srv (@services) {
		$srv = File::Basename::basename($srv);
		my ($startlevel,$stoplevel) = "";
		for my $level (0..6) {
			my $dir = "/etc/rc.d/rc$level.d";
			my @start = glob("$dir/S??$srv");
			my @stop  = glob("$dir/K??$srv");
			if (scalar(@start)) { $startlevel .= $level; }
			if (scalar(@stop)) { $stoplevel .= $level; }
		}

		if ($startlevel ne "") { 
			AddPostScript("chkconfig --level $startlevel $srv on"); 
		}
		if ($stoplevel ne "") { 
			AddPostScript("chkconfig --level $stoplevel $srv off"); 
		}

		# For some services, save the configuration:
		if ($startlevel eq "") { next; }

		# We consider, directories and binaries will be created 
		# when installing the packages
		if ($srv eq "ntpd") {
			AddCopyFile("/etc/ntp.conf");
			AddCopyFiles("/etc/ntp/*");
		}
		elsif ($srv eq "cups") {
			AddCopyFiles("/etc/cups/*");
		}
	}
}

# TODO: does not handle Group Dependencies
sub InstallPackages
{
	my %comps = ( );	# Group description from comps.xml
	my %pkgs = ( );		# give the Group the Pkg belongs to
	my %pkgcount = ( );	# count of installed Packages per Group

	# Get the list of installed packages:
	Verbose("Getting the list of installed Packages");
	my @pkgs = `rpm -qa --queryformat "%{NAME}\n"`;

	my %installed_pkgs = ( );
	for my $pkg (@pkgs) {
		chomp $pkg;
		$installed_pkgs{$pkg} = 1;
	}

	# Get the list of comps.xml files:
	my @comps_file = <comps/$C_SUBVERSION_DIR/*.xml>;

	# If there is a comps.xml file give, we try to use it to recalculte
	# the groups and components:
	if (scalar(@comps_file) == 0 ) {
		Info("#Component files 'comps/$C_SUBVERSION_DIR/*.xml' do not exist - could not recreate package groups");
		for my $pkg (@pkgs) {
			chomp $pkg;
			OutputKick($pkg);
		}
		return;
	}

	Verbose("Building the List of Package Groups:");
	foreach my $comps_file (@comps_file) {
		Verbose("Parsing file '$comps_file'");
		my $xtree = XML::Simple->new();
		my $xdoc = $xtree->XMLin($comps_file, forcearray => 1);

		# Rebuild the group contents and dependencies:
		foreach my $group (@{$xdoc->{group}}) {
			my $names = $group->{name};
			$pkgcount{$group} = 0;
			Verbose("Group: ".$names->[0]);

			# get the list of component for the group:
			# they are listed as <packagereq> under <packagelist>
			if (!defined($group->{packagelist})) {
				next;
			}

			my $pkglist = $group->{packagelist}->[0]->{packagereq};
			foreach my $pkg (@{$pkglist}) {
				Verbose("contains package: ".$pkg->{content});
				$comps{$names->[0]}->{$pkg->{content}} = 1;
				$pkgs{$pkg->{content}} = $names->[0];
			}
		}
	}

	# Now, we determine if it is faster to specify Groups, single
	# Packages, or event exclude Packages from Groups:
	
	# 1st pass: count of many Packages must be installed per Group:
	for my $pkg (keys %installed_pkgs) {
		
		# Packages which does not belong to the distro do not
		# belong to a group. They must be installed in another way
		if (!exists($pkgs{$pkg})) {
			push(@C_EXTRA_PKGS,$pkg);
			next;
		}

		my $group = $pkgs{$pkg};
		$pkgcount{$group}++;
	}

	# 2nd pass: for each group, if the count of installed pkg
	# is greater than half the included pkg, we install the group
	# and substract the not-installed pkg. Otherwise, we directly
	# install the pkgs
	for my $group (keys %comps) {
		my $pkgcount = scalar(keys(%{$comps{$group}}));
		Verbose("Group $group has ".int($pkgcount{$group})."/$pkgcount installed Packages");

		if ($pkgcount == $pkgcount{$group}) {
			OutputKick("@".$group);
		}
		elsif (int($pkgcount/2) < $pkgcount{$group}) {
			OutputKick("@".$group);
			foreach my $pkg (keys(%{$comps{$group}})) {
				if (!exists($installed_pkgs{$pkg})) {
					OutputKick("-$pkg");
				}
			}
		}
		else {
			foreach my $pkg (keys(%{$comps{$group}})) {
				if (exists($installed_pkgs{$pkg})) {
					OutputKick("$pkg");
				}
			}
		}
	}
}

sub DumpFSInfo{
	my @mount_list = `mount`;
	OutputKick("# Dumping files system info, fyi only, not valid kickstart config");
	OutputKick("# ");
	OutputKick("# Mounted partitions");
	for my $mount (@mount_list){
		chomp $mount;
		OutputKick("# $mount");
	}
	OutputKick("# LVM PVs");
	my @pvs = `pvdisplay -c`; 
	for my $pv (@pvs){
		chomp $pv;	
		OutputKick("# $pv");
	}
	OutputKick("# LVM VGs");
	my @vgs = `vgdisplay -c`; 
	for my $vg (@vgs){
		chomp $vg;
		OutputKick("# $vg");
	}
	OutputKick("# LVM LVs");
	my @lvs = `lvdisplay -c`; 
	for my $lv (@lvs){
		chomp $lv;
		OutputKick("# $lv");
	}

}

# -----------------------------------------------------------------
# OUTPUT FUNCTIONS
# -----------------------------------------------------------------
my $COLNORM	= "^[[0;37m";
my $COLINFO	= "^[[0;33m";
my $COLINF2	= "^[[0;36m";
my $COLWARN	= "^[[0;35m";
my $COLERRO	= "^[[0;31m";
my $COLQUES	= "^[[0;32m";
my $COLSTEP	= "^[[1;36m";

sub CheckOutputFile 
{
	my $dir = dirname($C_STDOUT);
        if (! -d $dir) { 
                mkdir $dir || die("${COLERRO}Error:${COLNORM} Could not create $dir Directory\n");
        }
}

sub EchoFile
{
	my ($line) = @_;
	print "$line";
	open(FD,">>$C_STDOUT") or Error("Could not open file $C_STDOUT in write mode");
	print FD "$line";
	close(FD);
}

sub EchoNL
{
	EchoFile("\n");
}

sub Warning
{
	my ($text) = @_;

        CheckOutputFile
        EchoFile("${COLWARN}Warning:${COLNORM} $text\n");
        $C_WARNCOUNT++; 
}

sub Fatal
{
	my ($text) = @_;

        CheckOutputFile
        EchoFile("${COLERRO}Fatal:${COLNORM} $text\n"); 
        exit(1);
}

sub Error
{
	my ($text) = @_;

        CheckOutputFile
        EchoFile("${COLERRO}# Error:${COLNORM} $text\n");
        if ("$C_PROMPT" eq "y") {
                #print "Do you want to continue (y/n) ? ";
		#my $choice = <STDIN>;
		my $choice = "y";
		chomp $choice;
                if ("$choice" ne "y") {
                       # exit(1);
                }
	} 
	else {
                if ("$C_ONERROR" eq "exit") {
                       # exit(1);
                }
        }

        $C_ERRCOUNT++;
}

sub Ask
{
	my ($text) = @_;
        CheckOutputFile
        EchoFile("${COLQUES}$text (y/n) ? ${COLNORM}"); 
}

sub Info
{
	my ($text) = @_;
        CheckOutputFile
        EchoFile("${COLINFO}$text${COLNORM} "); 
}

sub InfoNL
{
	my ($text) = @_;
        CheckOutputFile
        EchoFile("${COLNORM}$text\n");
}

sub InfoVar
{
	my ($text) = @_;
        CheckOutputFile
        EchoFile("${COLQUES}$text${COLNORM} ");
}

sub OutputKick
{
	my ($text) = @_;
	EchoFile("$text\n");
}

sub Verbose
{
	my ($text) = @_;
	if ($C_VERBOSE) { print STDERR "VERBOSE: $text\n"; }
}

exit(0);
# EOF
