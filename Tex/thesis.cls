%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jyvaskylan yliopiston Fysiikan laitoksen tutkielma (thesis.cls)
% Dokumenttiluokka
% Versio 1.0 (03/01/2019)
% 
% Alkuperäinen tekijä:
% Jussi Maunuksela (jussi.o.maunuksela at jyu.fi)
%
% Lisenssi:
% CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/)
%
% Muutokset:
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2019/01/03 JYFL tutkielma luokka]

% ================================================================
% DOKUMENTTILUOKAN MÄÄRITELMÄT:
%
% Dokumentti ladotaan artikkelina (article), jolle on määritelty 
% - peruskirjasimen kooksi 12 pistettä (12 pt)
% - taitto kaksipuoleiselle tulostukselle (twoside) A4-kokoiselle paperille (a4paper) 
% - matemaattisten kaavojen ladonta vasempaan reunaan tasattuina (fleqn)
%   
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,fleqn,twoside]{article}

%% Makropaketit:

% Käsikirjoituksessa käytetään utf-8 merkistöä
\RequirePackage[utf8]{inputenc}

% LaTeX käyttää kirjasimen merkkivalikoimana T1-merkistöä täydennettynä 
% Computer Modern-like -kirjasimilla ja microtype -makroilla.  
\RequirePackage[T1]{fontenc} % encoding containing umlaut letters
\RequirePackage{lmodern} % Computer Modern-like fonts with T1 support
\RequirePackage[final]{microtype}
\DisableLigatures[f]{encoding = *, family = *} % no combining f with an adjacent letter

% Desimaalilukujen erottimena käytettävän pilkun eteen tulevan välin 
% oikea mitoitus saadaan icomma-makroilla.
\RequirePackage{icomma}

% Kuvien ja taulukoiden selitteiden ulkoasun muotoilu, jossa vasemman marginaalin ja
% selitetekstin välissä olevan tilan leveys on 10 pistettä. Kuvien ja taulukoiden 
% tunnisteen ladotaan paksunnetulla kirjasimella (bf) ja tunniste, kuten "Kuva 1", 
% erotetaan varsinaisesta selitetekstistä pisteellä, esim. "Kuva 1. Mekaaninen 
% värähtelijä".
\RequirePackage[margin=10pt,labelfont=bf,labelsep=period]{caption}[2013/02/03]

% Dokumentissa on käytössä englannin ja suomen tavutussäännöt, joista suomen
% tavutussäännöt ovat ensisijaisesti käytössä. Englannin tavutus otetaan erillisellä 
% komennolla käyttöön tekstissä.
\RequirePackage[finnish,english]{babel} % Active language: English

% Dokumentin paperin kooksi on määritelty A4-kokoinen paperi, vasemman ja oikean 
% marginaalin leveydeksi 25 mm sekä ala- ylämarginaalin leveydeksi 35 mm. Tutkielman 
% sidontaa varten varataan sivun reunasta 10 mm levyinen alue.
\RequirePackage[a4paper,left=25mm,right=25mm,top=35mm,bottom=35mm,bindingoffset=10mm]{geometry}
\setlength{\headheight}{15pt}

% Tekstin riviväliksi on asetettu 1,5 kertaa peruskirjasimen koko:
\linespread{1.3} % For one-and-a-half spacing you have to use 1.3. 

% Sivun ylä- ja alatunnisteet jäävät pois tutkielman ensimmäiseltä sivulta (kansilehdeltä) ja tämän jälkeen sivunumero tulostetaan ylätunnisteeseenmäärittelyssä 
\RequirePackage{fancyhdr}
\fancypagestyle{firstpage}{%
  \fancyhf{}% clear all six fields
  \renewcommand{\headrulewidth}{0pt} %
  \renewcommand{\footrulewidth}{0pt} %
}
\fancypagestyle{followingpage}{%
  \fancyhf{}% clear all six fields
  \fancyhead[LE,RO]{\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{followingpage}
\AtBeginDocument{\thispagestyle{firstpage}}

% Lukujen otsikoiden muotoilu
\RequirePackage[noindentafter,nobottomtitles,toctitles]{titlesec}
\newcommand{\sectionbreak}{%
	\cleardoublepage%
	\vspace*{24pt}}

% Lähteiden tulostaminen sisällysluetteloon
\RequirePackage[nottoc]{tocbibind}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% GRAPHICX --- Grafiikan lisääminen dokumenttiin. Oletuksen dokumentin tulostaminen pdf-muotoon
%
\RequirePackage{graphicx}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% HYPERREF --- Hyperlinkkien ladonta tekstin sekaan. 
%
\RequirePackage[final]{hyperref}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% LASTPAGE --- Dokumentin viimeiseen sivuun viittaaminen. 
%
\RequirePackage{lastpage}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% BOOKTABS --- Taulukoiden piirtäminen käyttäen viivoja, joiden ympärille jää sopivasti tilaa.
%
\RequirePackage{booktabs}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% DATETIME --- Päiväyksen muotoilu
%
\RequirePackage{datetime}
\renewcommand{\dateseparator}{.}
\setdefaultdate{\dmyyyydate}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% URL --- URL-osoitteiden ladonta
%
\RequirePackage{url}

\RequirePackage{setspace}

\RequirePackage{lipsum}

% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% JYFLTITLE --- Kansilehden ladonta
%
\RequirePackage{jyflTitle}






