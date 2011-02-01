#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
sys.path.append("PATH_PERISCOPE")
import autoProcessTV
import periscope
import os
import os.path
import string
import glob
import logging
logging.basicConfig(level=logging.DEBUG)

subdl = periscope.Periscope()
filepath = sys.argv[1]
path, file = os.path.split(filepath)
filepath2 = path + "/" + file.lower()
file, ext = os.path.splitext(file)
sub_en = path + "/" + file + ".en.srt"
sub_nl = path + "/" + file + ".nl.srt"

# First language
print "\nSearch for 'en' subtitle:"
print "===================================="
if not (os.path.isfile (sub_en)) :
    subtitle1 = subdl.downloadSubtitle(filepath, ['en'])    
    if subtitle1 :
        print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle1['plugin'], subtitle1['lang'], subtitle1['subtitlepath'])
        os.rename(subtitle1['subtitlepath'], string.join(string.split(subtitle1['subtitlepath'], ".srt"), ".en.srt"))
    if subtitle1 == None :
        subtitle3 = subdl.downloadSubtitle(file + ".srt", ['en'])
        if subtitle3 :
            print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle3['plugin'], subtitle3['lang'], subtitle3['subtitlepath'])
            os.rename(subtitle3['subtitlepath'], path + "/" + file + ".en.srt")
else:
    print "'en' subtitle present for %s" % filepath

# Second Language
print "\nSearch for 'nl' subtitle:"
print "===================================="
if not (os.path.isfile (sub_nl)) :
    subtitle2 = subdl.downloadSubtitle(filepath, ['nl'])    
    if subtitle2 :
        print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle2['plugin'], subtitle2['lang'], subtitle2['subtitlepath'])
        os.rename(subtitle2['subtitlepath'], string.join(string.split(subtitle2['subtitlepath'], ".srt"), ".nl.srt"))
    if subtitle2 == None :
        subtitle4 = subdl.downloadSubtitle(file + ".srt", ['nl'])
        if subtitle4 :
            print "Found a sub from %s in language %s, downloaded to %s" % ( subtitle4['plugin'], subtitle4['lang'], subtitle4['subtitlepath'])
            os.rename(subtitle4['subtitlepath'],  path + "/" + file + ".nl.srt")
else:
    print "'nl' subtitle present for %s" % filepath

# To SickBeard
if len(sys.argv) < 2:
    print "No folder supplied - is this being called from SABnzbd?"
    sys.exit()
elif len(sys.argv) >= 3:
    autoProcessTV.processEpisode(sys.argv[1], sys.argv[2])
else:
    autoProcessTV.processEpisode(sys.argv[1])
