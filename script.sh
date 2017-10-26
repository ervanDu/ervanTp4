menuAgirVagrant(){
  echo "Les Vagrant lancées :"
  vagrant global-status
  echo ""
  echo ""
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo " 1 Supprimer une Vagrant"
  echo " 2 Arrter une vagrant"
  echo " 3 se connecter en ssh a une vagrant"
  echo " 4 quitter"
  echo " 4 quitter"
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"
  echo ""
}

#fonction recurcive pour gerer les problemes de choix dans le menu
caseBoxFunction(){
  echo "Quelle box voulez vous ?"
  echo "1 - ubuntu/xenial64"
  echo "2 - ubuntu/xenial64"
  echo ""
  read -p "--------------------" choix;
  if [[ -n $1 ]]; then
      return $1;
  else
    case $choix in
      1) return 1 ;;
      2) return 2 ;;
      *) echo ""
         echo "------ ce n'est pas un choix valide ------"
         echo ""
         caseBoxFunction ;;
     esac
  fi
}


while read -p "voulez vous 1 - creer une Vagrant ou 2 - gerer vos vagrant (autre chose pour quitter)" choixGlobal; do
  case $choixGlobal in
    1)
      #verification des Instaliation
      echo "";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "";
      echo "verification des instalation de Virtualbox puis Vagrant"
      echo "";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
      echo "";
      if [[ -z $(which Virtualbox) ]]; then
        echo "";
        echo "virtualbox est installe"
        echo "";
      else
        echo "";
        echo "instalation de virtualbox";
        sudo apt-get install virtualbox-5.1
        echo "";
      fi

      if [[ -z $(which lel) ]]; then
        echo "";
        echo "vagrant est installe"
        echo "";
      else
        echo "";
        echo "instalation de vagrant";
        sudo apt-get install vagrant
        echo "";
      fi

      echo "";
      echo "--------------------";
      echo "Création d'une Vagrant";
      echo "--------------------";
      echo "";
      #variables du Vagrantfile

      caseBoxFunction
      case $choix in
        1) box="ubuntu/xenial64" ;;
        2) box="ubuntu/xenial64" ;;
        *) echo ":)" ;;
      esac
      echo ""
      echo "------ ecriture du Vagrantfile ------"
      echo ""
      echo "box : $box"
      echo ""
      read -p "Votre dossier (chemin relatif) : " chemin;
      if [[ -d "pwd/$chemin" ]]; then
        echo "le dossier existe"
      else
        echo "creation du dossier $chemin"
        mkdir $chemin
      fi
      read -p "Votre dossier sur le serveur (chemin absulut) : " cheminServ;
      #ecriture du Vagrantfile
      echo "# -*- mode: ruby -*-
      Vagrant.configure('2') do |config|
      config.vm.box = '$box'
      config.vm.network 'private_network', ip: '192.168.33.10'
      config.vm.synced_folder '$chemin', '/$cheminServ'
      config.vm.provider 'virtualbox' do |vb|
      vb.memory = '1024'
      end
      end" >> Vagrantfile
      vagrant up ;;
    2)
      #gestion des Vagrant
      menuAgirVagrant
      while read -p "Votre choix : " choixA; do
        case $choixA in
                1) read -p "quel est l'id de la vagrant ? " id
                vagrant destroy $id;;
                2) read -p "quel est l'id de la vagrant ? " id
                vagrant halt $id;;
                3) read -p "quel est l'id de la vagrant ? " id
                vagrant ssh $id;;
                4) break;;
        esac
        menuAgirVagrant
      done
      ;;
  *) break ;;
  esac
done
