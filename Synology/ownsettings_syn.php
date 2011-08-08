<?php

ini_set("include_path", "/opt/share/pear");

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   WIJZIG ONDERSTAANDE  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$settings['nntp_nzb']['host'] = 'news.ziggo.nl';    # <== Geef hier je nntp server in
$settings['nntp_nzb']['user'] = 'xx';               # <== Geef hier je username in
$settings['nntp_nzb']['pass'] = 'yy';               # <== Geef hier je password in
$settings['nntp_nzb']['enc'] = false;               # <== false|'tls'|'ssl', defaults to false.
$settings['nntp_nzb']['port'] = 119;                # <== set to 563 in case of encryption

# =-=-=-=-=-=-=-=- Als je een aparte 'headers' newsserver nodig hebt, uncomment dan volgende =-=-=-=-=-=-=-=-=-
$settings['nntp_hdr']['host'] = '';
$settings['nntp_hdr']['user'] = '';
$settings['nntp_hdr']['pass'] = '';
$settings['nntp_hdr']['enc'] = false;
$settings['nntp_hdr']['port'] = 119;

# =-=-=-=-=-=-=-=- Als je een aparte 'upload' newsserver nodig hebt, uncomment dan volgende =-=-=-=-=-=-=-=-=-
$settings['nntp_post']['host'] = '';
$settings['nntp_post']['user'] = '';
$settings['nntp_post']['pass'] = '';
$settings['nntp_post']['enc'] = false;
$settings['nntp_post']['port'] = 119;

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#
# Moeten de headers door retrieve volledig geladen worden? Als je dit op 'true' zet wordt 
# het ophalen van headers veel, veel trager. Het staat je dan echter wel toe om te filteren op userid.
#
$settings['retrieve_full'] = false;
