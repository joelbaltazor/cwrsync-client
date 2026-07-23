# Instructions on how to build your own cwrsync rsync client for windows.

## Install Cygwin and required packages:
Download latest version of Cygwin here: https://cygwin.com/setup-x86_64.exe

Install from Internet
Accept default of C:\cygwin64\
Set local package directory to something you wish, like: C:\cygwin_downloads
Direct connection (if not using proxy server)
Use whichever mirror works for you.

The window that pops up selects the packages you want.  Search for and install these (change skip to an install version):

Name - Version installed when these instructions were created - July 23, 2026
gcc-g++ (The compiler)  - 14.4.0-1
make (Build execution engine) – 4.4.1-2
automake / autoconf (Configuration tools) – 1.18.1-1  & 15-3
libiconv-devel (Character set conversion headers) – 1.19-2
liblz4-devel (LZ4 compression headers) – 1.9.4-1
libxxhash0 & libxxhash-devel (xxHash algorithm headers) – 0.8.3-1
libzstd-devel (Zstandard compression headers) – 1.5.7-1
libssl-devel (Crypto & OpenSSL headers) – 3.5.7-1
libpopt-devel (Command-line option parsing headers) – 1.19-1
attr & libattr-devel – 2.5.2-2
patch – 2.8-1
zip (needed for bash script to make zip file) – 3.0-13

Also, cwRsync would add ssh.exe, ssh-add.exe, ssh-agent.exe, ssh-keygen.exe.  These are part of the openssh package. Install it too.  - 10.3p1-1

Note: If you missed one of these packages, just re-run the installer and add more packages.

If asked, create shortcuts to cygwin

## Setup the build area

Create a temporary location, like C:\cygwin_temp
Download the .zip file or clone this git repository here.
When I used the .zip file, it creates it's own subfolder and my path looks like:
C:\cygwin_temp\cwrsync-client-main\

## Commpile
Run Cygwin 64 Terminal as an administrator of your windows computer (right-click, run as)
In the cygwin terminal:
cd /cygdrive/c/cygwin_temp/cwrsync-client-main/build/

(Everything below here is from cwrsync/itefix with the exception of the build link. I've pointed it back at this repository)
run ./build_rsync 3.4.4     (where 3.4.4 is the latest verson of rsync you are trying to build)


## Some notes:
template.sh has patches transliterate.diff, ignore-case from rsync-patches.  These patches are no longer released/updated after 3.4.1
https://download.samba.org/pub/rsync/src/rsync-patches-3.4.1.tar.gz  is the latest version
the patches from -patches tar.gz have been copied to the build directory of this repo.

The patches may not apply cleanly (hunk failed), but this appears to be just the documentation parts of the patches and does not negatively impact the build. OK to ignore (at least for now)

Use at your own risk, script does minimal error checking

# cwRsync client

![cwRsync client](https://itefix.net/sites/default/files/cwRsync_client.png)

A barebone distribution of Rsync client for Windows. That's all you need to initiate rsync requests from your computer.

## About

cwRsync is a packaging of Rsync for Windows. You can use cwRsync for fast remote file backup and synchronization.

Rsync uses the Rsync algorithm which provides a very fast method for bringing remote files into sync. It does this by sending just the differences in the files across the link, without requiring that both sets of files are present at one of the ends of the link beforehand. At first glance this may seem impossible because the calculation of diffs between two files normally requires local access to both files.

Rsync normally uses ssh for communication. It requires no special privileges for installation. You must, however, have a working ssh system. Alternatively, rsync can run in `daemon' mode, listening on a socket. This is generally used for public file distribution, although authentication and access control are available.

Cygwin is a Linux-like environment for Windows. It consists of a DLL (cygwin1.dll), which emulates substantial Linux API functionality, and a collection of tools.

## Features

The rsync binary provided has following convenient patches:

- transliterate
- timelimit
- ignore case

The package contains the required ssh binaries for secure communication.

## Downloads

Downloads are available via [GitHub Releases](https://github.com/joelbaltazor/cwrsync-client/releases).

## Resources

- [FAQs](https://itefix.net/cwrsync/client/faqs)
- [Releases](https://itefix.net/cwrsync/client/releases)
- [Official Website](https://itefix.net/cwrsync/client)

## Additional Products

If you need to serve rsync requests from your computer, you need to set up an rsync daemon, which itefix.net provides [as a paid solution](https://itefix.net/cwrsync/server). itefix.net also provides an [Rsync client helper GUI](https://itefix.net/rsync-client-helper-gui) as a product.

## Links

- [Rsync](http://rsync.samba.org/)
- [Rsync algorithm](http://rsync.samba.org/tech_report/)
- [Cygwin](http://www.cygwin.com/)
- [cwRsync - Rsync for Windows](https://itefix.net/cwrsync)
- [transliterate patch](https://git.samba.org/?p=rsync-patches.git;a=blob;f=transliterate.diff;h=58b2fb26767c17ce32df08942e55159eca672676;hb=ad11a2bcb3aea2faa0c7523fbaaa42e303b0620b)
- [timelimit patch](https://git.samba.org/?p=rsync-patches.git;a=blob;f=time-limit.diff;h=15bf553a21dd8f2a545047ba692b8f811b369201;hb=ad11a2bcb3aea2faa0c7523fbaaa42e303b0620b)
- [ignore case patch](https://git.samba.org/?p=rsync-patches.git;a=blob;f=ignore-case.diff;h=3239ee66b3e415e2dd7ee812118cd1ca5ea6b0c1;hb=ad11a2bcb3aea2faa0c7523fbaaa42e303b0620b)
