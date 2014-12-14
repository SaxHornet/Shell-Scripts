#! /bin/sh
#
# Liste des fichiers anciens (modifies il y a plus de DUREE_MINI jours),
# mais pas trop anciens (modifies il y a moins de DUREE_MAXI jours).
# On voit ainsi les fichiers temporaires oublies, mais pas les fichiers
# datant de l'installation du systeme.

DUREE_MINI=1
DUREE_MAXI=20
NOM_SCRIPT=$(basename "$0")

LIMITE_PROFONDEUR="-maxdepth 1"

if [ $# -eq 0 ]; then
	echo "usage: $NOM_SCRIPT repertoire..." >&2
	exit 0
fi

for dir in "$@"
do
	if [ "$dir" = "-r" ]; then
		LIMITE_PROFONDEUR=""
		continue;
	fi

	if [ ! -d "$dir" ]; then
		echo "$NOM_SCRIPT: $dir n'est pas un repertoire" >&2
		continue;
	fi
	
	find "$dir" $LIMITE_PROFONDEUR -ctime +$DUREE_MINI -ctime -$DUREE_MAXI

done


