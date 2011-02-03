#!/usr/bin/python
# -*- coding: utf-8 -*-

import periscope
import sys
import logging
import os
import glob
import os.path
import string
logging.basicConfig(level=logging.DEBUG)

subdl = periscope.Periscope()
filepath = sys.argv[1]
path, file = os.path.split(filepath)
filepath2 = path + "/" + file.lower()
file, ext = os.path.splitext(file)
sub_111 = path + "/" + file + ".111.srt"
sub_222 = path + "/" + file + ".222.srt"

# First language
print "\nSearch for '111' subtitle:"
print "===================================="
if not (os.path.isfile (sub_111)) :
    subtitle1 = subdl.downloadSubtitle(filepath + "/*.avi" , ['111'])    
    if subtitle1 :
        print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle1['plugin'], subtitle1['lang'], subtitle1['subtitlepath'])
        os.rename(subtitle1['subtitlepath'], string.join(string.split(subtitle1['subtitlepath'], ".srt"), ".111.srt"))
    if subtitle1 == None :
        subtitle3 = subdl.downloadSubtitle(file + ".srt", ['111'])
        if subtitle3 :
            print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle3['plugin'], subtitle3['lang'], subtitle3['subtitlepath'])
            os.rename(subtitle3['subtitlepath'], path + "/" + file + ".111.srt")
else:
    print "'111' subtitle present for %s" % filepath

# Second Language
print "\nSearch for '222' subtitle:"
print "===================================="
if not (os.path.isfile (sub_222)) :
    subtitle2 = subdl.downloadSubtitle(filepath, ['222'])    
    if subtitle2 :
        print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle2['plugin'], subtitle2['lang'], subtitle2['subtitlepath'])
        os.rename(subtitle2['subtitlepath'], string.join(string.split(subtitle2['subtitlepath'], ".srt"), ".222.srt"))
    if subtitle2 == None :
        subtitle4 = subdl.downloadSubtitle(file + ".srt", ['222'])
        if subtitle4 :
            print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle4['plugin'], subtitle4['lang'], subtitle4['subtitlepath'])
            os.rename(subtitle4['subtitlepath'],  path + "/" + file + ".222.srt")
else:
    print "'222' subtitle present for %s" % filepath
