# TOxDIAG
TOxDIAG est une ROM de diagnostic pour les ordinateurs Thomson TO8 et TO8D.
## Présentation
TOxDIAG permet de vérifier le fonctionnement des éléments de base de l'ordinateur.
Dans ce but, les opérations suivantes sont réalisées :
- Définition d'une palette de 9 couleurs.
- Affichage cyclique de la palette sur le cadre de l'écran.
- Ecriture et lecture de la RAM vidéo.
## Installation
TOxDIAG remplace la ROM moniteur IW17.
Afin de l'utiliser il faut programmer une EPROM de type 27128 ou 27256, retirer le composant IW17 monté sur support et installer à la place la nouvelle ROM.
- Pour une EPROM 27128 de 16 Ko, il faut utiliser le fichier [TOxDIAG-27128.bin](build/TOxDIAG-27128.bin).
- Pour une EPROM 27256 de 32 Ko, il faut utiliser le fichier [TOxDIAG-27256.bin](build/TOxDIAG-27256.bin).

Si IW17 n'est pas monté sur support, il faudra dessouder le composant et souder un support, puis installer TOxDIAG.

>**Important** 
> Toute manipulation des composants doit se faire ordinateur hors tension.
> Dessouder des composants d'une carte mère de Thomson TO8 est une opération délicate et risquée : les pistes ont tendance à se décoller du PCB.
## Utilisation
A la mise sous tension, l'ordinateur va afficher pendant environ une seconde chaque couleur de sa palette sur le cadre de l'écran puis débuter la vérification de la RAM vidéo. 
A la fin du traitement la couleur du cadre indique le résultat de l'opération. 
Le tableau suivant indique le composant défectueux en fonction de la couleur affichée :
<table>
<tr><th>Couleur</th><th>Composant</th></tr>
<tr><td bgcolor="grey">Gris</td><td>Aucune erreur</td></tr>
<tr><td bgcolor="black"><font color="white">Noir</font></td><td>IW01</td></tr>
<tr><td bgcolor="red">Rouge</td><td>IW02</td></tr>
<tr><td bgcolor="green">Vert</td><td>IW03</td></tr>
<tr><td bgcolor="yellow">Jaune</td><td>IW04</td></tr>
<tr><td bgcolor="blue">Bleu</td><td>IW05</td></tr>
<tr><td bgcolor="magenta">Magenta</td><td>IW06</td></tr>
<tr><td bgcolor="cyan">Cyan</td><td>IW07</td></tr>
<tr><td bgcolor="white">Blanc</td><td>IW08</td></tr>
</table>

Le composant spécifié doit être vérifié et dans la plupart des cas, remplacé.

>**Note**
le diagnostic s'interrompt dès qu'une erreur est rencontrée. De ce fait, il est nécessaire de réitérer l'exécution de TOxDIAG jusqu'à l'affichage d'un cadre gris.

Lorsque il n'est plus nécessaire d'utiliser TOxDIAG, la ROM d'origine peut être réinstallée à son emplacement.

>**Note** 
A la mise sous tension, mon TO8 n'exécute pas TOxDIAG. Un appui sur la touche INIT est nécessaire pour que l'exécution débute. Le moniteur d'origine s'exécute immédiatement à la mise sous tension.
## Développement
TOxDIAG est réalisé à l'aide des outils suivants :
- [Visual Studio Code](https://code.visualstudio.com/) sur Windows 10, et le plugin [6x09 Assembly](https://marketplace.visualstudio.com/items?itemName=blairleduc.6x09-assembly) pour éditer le source.
- LWASM, élément de [LWTOOLS](http://www.lwtools.ca/), pour la compilation.
- [Hex2bin](http://hex2bin.sourceforge.net/)  pour construire les binaires pour la programmation des EPROMs.

Le fichier [build.bat](build.bat) réalise l'ensemble des tâches nécessaires à la construction des binaires.
### A faire
- Tester l'ensemble de la RAM.
- Tester la ROM sur TO9. La ROM moniteur est une EPROM 2764 de 8 Ko I42.
- Tester la ROM sur TO9+. La ROM moniteur est une EPROM 27128 de 16 Ko IW12.
### Historique
- TOxDiag 1.0.0, 19/12/2019<br/>Version initiale.
### Remerciements
Merci à l'ensemble des membres du [forum](https://forum.system-cfg.com/) de System-cfg, dont les différentes contributions m'ont fourni toutes les informations techniques nécessaires à la réalisation de ce projet.
```asm
 sta $A7E7 
```