<?php

# =-=-=-=-=-=-=-=-=-=-=-=-=  /etc/default/spotweb/ownsettings.php  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-   WIJZIG ONDERSTAANDE  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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


# Waar is SpotWeb geinstalleerd (voor de buitenwereld), deze link is nodig voor zaken als de RSS feed en de 
# sabnzbd integratie. Let op de afsluitende slash "/"!
if (isset($_SERVER['SERVER_PROTOCOL'])) {
    $settings['spotweburl'] = (@$_SERVER['HTTPS'] == 'on' ? 'https' : 'http') . '://' . @$_SERVER['HTTP_HOST'] . (dirname($_SERVER['PHP_SELF']) != '/' && dirname($_SERVER['PHP_SELF']) != '\\' ? dirname($_SERVER['PHP_SELF']). '/' : '/');	
} else {
	$settings['spotweburl'] = 'http://mijnserver/spotweb/';
} # if


#
# Moeten de headers door retrieve volledig geladen worden? Als je dit op 'true' zet wordt 
# het ophalen van headers veel, veel trager. Het staat je dan echter wel toe om te filteren op userid.
#
$settings['retrieve_full'] = false;

#
# Hoeveel verschillende headers (van danwel spots, reports danwel comments) moeten er per keer opgehaald worden? 
# Als je regelmatig timeouts krijgt van retrieve.php, vrelaag dan dit aantal
#
$settings['retrieve_increment'] = 1000;

# Zet een minimum datum vanaf wanneer je spots op wilt halen, om alle spots van FTD te skippen geef je hier 1290578400 op
# Andere data kun je omrekenen op http://www.unixtimestamp.com/
$settings['retrieve_newer_than'] = 0;

#
# SpotNet ondersteund moderatie van de gepostte spots en reacties, dit gebeurt
# door middel van moderatie berichten in de nieuwsgroup waar ook de spots worden
# gepost.
#
# SpotWeb ziet deze berichten ook, en zal er iets mee moeten doen. Afhankelijk van
# wat je wilt moet je onderstaande setting aanpassen naar een van de volgende waardes:
#
# 	disable				- 	Doe helemaal niks met de moderatie
#	act					- 	Wis de gemodereerde spots
#	markspot			-	Markeer de gemodereerde spots als gemodereerd. Er is op 
#							dit moment nog geen UI om dit te filteren of iets dergelijks.
#
$settings['spot_moderation'] = 'act';

# moeten wij comments ophalen?
$settings['retrieve_comments'] = true;

# moeten wij (spamm) repors ophalen?
$settings['retrieve_reports'] = true;

# Retentie op de spots (in dagen). Oudere spots worden verwijderd. Selecteer 0 om spots niet te verwijderen
$settings['retention'] = 0;
