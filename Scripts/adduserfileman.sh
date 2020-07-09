    #! /bin/sh
    
    #Fonction pour créer un utilisateur manuellement
    creer_user_m()
    {
    if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
            echo "$username exists!"
            exit 1
        else
            pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
            useradd -m -p $pass $username
            [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
    else
        echo "Only root may add a user to the system"
        exit 2
    fi
    }
    
    #Fonction  pour créer plusieurs utilisateurs inscrit dant un fichier texte
    creer_user_a()
    {   
    if [ $(id -u) -eq 0 ]; then
       echo "Donner le chemin jusqu'au fichier : "
       read dir
    #on vérifie si le fichier entré en paramêtre existe	
            if [ -e $dir ] then
                while read ligne do #pour chaque ligne
                    #reçoit la 1ere partie de la ligne séparée par “ : ”
                    user=$(echo $ligne | cut -d: -f1)
                    #reçoit la 2ème partie de la ligne séparée par “ : ”			
                    pass=$(echo $ligne | cut -d: -f2)
                    #on écrit le login et mot de passe dans comptes.txt en incremantant à chaque fois (pour ainsi suprimer facilement plus tard)
                    echo $user":"$pass >> comptes.txt
                    #création du compte unix
                    useradd -d /home/$user -m -s /bin/false $user
                    echo "L'utilisateur "$user" a été correctement créer sur le système."
            fi 
     else
        echo "Only root may add a user to the system"
	    exit 2
    fi
        
    }