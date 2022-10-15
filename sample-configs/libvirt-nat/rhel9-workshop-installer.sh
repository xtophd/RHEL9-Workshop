#!/bin/bash


ANSIBLE_SOURCE=""
ADMIN_PASSWORD=""
VAULT_PASSWORD=""
ANSIBLE_SOURCE=""
DNS_SERVER=""
TIME_SERVER=""


# ---


current_settings () {

   ##
   ##    Bash Lession:  the bash shell parameter expansion ':+' passes
   ##                   expansion if paramenter is set and not null
   ##

    echo ""
    echo "Current Settings"
    echo "----------------"
    echo "Ansible Source          ... [${ANSIBLE_SOURCE}]"
    echo "Ansible Vault Password  ... [${VAULT_PASSWORD:+"**********"}]" 
    echo "Workshop Admin Password ... [${ADMIN_PASSWORD:+"**********"}]" 
    echo "DNS Server              ... [${DNS_SERVER}]"
    echo "TIME Server             ... [${TIME_SERVER}]" 
    echo ""
}


# ---


prepare_deployment () {

    echo ""

    echo "## Install Ansible from ${ANSIBLE_SOURCE}"

    case ${ANSIBLE_SOURCE} in 

      "RHSM") 
        ./sample-scripts/rhel9-install-ansible-rhsm.sh 
        ;;

      "EPEL") 
        ./sample-scripts/rhel9-install-ansible-epel.sh 
        ;;
    
      "INSTALLED") 
        echo " - success (ansible already installed)"
        ;;

      "*" )
        echo "WARNING: you must set a valid ansible source"
        return 1
        ;;
    esac





    echo -n "## Copy Configs"

    cp ./sample-configs/libvirt-nat/*.yml ./config

    if [[ $? ]] ; then
      echo " - success" 
    else
      echo " - FAILED" 
      return 1
    fi


    echo -n "## Adjust Workshop Admin Password"

    if [[ -z "${ADMIN_PASSWORD}" ]]; then
      echo " - FAILED" 
      echo "WARNING: you must set the ADMIN PASSWORD"
      return 1
    else
      sed -i -e "s/^\(.*xtoph_deploy_root_passwd:\).*\$/\1 \"${ADMIN_PASSWORD}\"/" ./config/credentials.yml
      if [[ $? ]] ; then
        echo " - success" 
      else
        echo " - FAILED" 
        return 1
      fi
    fi


    echo -n "## Adjust DNS Configuration"

    if [[ -z "${DNS_SERVER}" ]]; then
      echo " - FAILED" 
      echo "WARNING: you must set the DNS SERVER"
      return 1
    else
      sed -i -e "s/^\(.*network_nameserver:\).*\$/\1 \"${DNS_SERVER}\"/" ./config/master-config.yml
      if [[ $? ]] ; then
        echo " - success" 
      else
        echo " - FAILED" 
        return 1
      fi
    fi


    echo -n "## Adjust TIME Configuration"

    if [[ -z "${TIME_SERVER}" ]]; then
      echo " - FAILED" 
      echo "WARNING: you must set the TIME SERVER"
      return 1
    else
      sed -i -e "s/^\(.*network_timeserver:\).*\$/\1 \"${TIME_SERVER}\"/" ./config/master-config.yml
      if [[ $? ]] ; then
        echo " - success" 
      else
        echo " - FAILED" 
        return 1
      fi
    fi


    echo -n "## Encrypt the credentials.yml"

    if [[ -z "${VAULT_PASSWORD}" ]]; then
      echo " - FAILED" 
      echo "WARNING: you must set the VAULT_PASSWORD"
      return 1
    else
      echo "${VAULT_PASSWORD}" > ./config/vault-pw.tmp
      ansible-vault encrypt --vault-password-file ./config/vault-pw.tmp config/credentials.yml 1>/dev/null 2>&1

      if [[ $? ]] ; then
        rm -f ./config/vault-pw.tmp
        echo " - success" 
      else
        rm -f ./config/vault-pw.tmp
        echo " - FAILED" 
        return 1
      fi
    fi

}



# ---


main_menu () {

    PS3="Select Action: "

    current_settings

    select action in "Set Ansible Source" "Set Vault Password" "Set Admin Password" "Set DNS Server" "Set TIME Server" "Prepare Deployment" "Quit"
    do
      case ${action}  in
        "Set Ansible Source")
          if [[ "${ANSIBLE_SOURCE}" == "INSTALLED" ]]; then
            echo ""
            echo "NOTE: Ansible is already installed"
          else
            select ANSIBLE_SOURCE in "EPEL" "RHSM"
            do
              case ${ANSIBLE_SOURCE} in
                "EPEL" )
                  break ;;
                "RHSM" )
                  break ;;
                "*" )
                  ;;
              esac
              REPLY=
            done
          fi
          ;;

        "Set Vault Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter ansible vault password [${VAULT_PASSWORD:+"**********"}]: " input
          echo ""
          read -s -p "Enter ansible vault password again [${VAULT_PASSWORD:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            VAULT_PASSWORD=${input:-$VAULT_PASSWORD}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set Admin Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter admin (root) password [${ADMIN_PASSWORD:+"**********"}]: " input
          echo ""
          read -s -p "Enter admin (root) password again [${ADMIN_PASSWORD:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            ADMIN_PASSWORD=${input:-$ADMIN_PASSWORD}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set DNS Server")
          read -p "Enter dns server ipv4 address [${DNS_SERVER}]: " input
          DNS_SERVER=${input:-$DNS_SERVER}
          ;;

        "Set TIME Server")
          read -p "Enter time server ipv4 address [${TIME_SERVER}]: " input
          TIME_SERVER=${input:-$TIME_SERVER}
          ;;

        "Prepare Deployment")
          prepare_deployment
          ;;

        "Quit")
          echo "Quit"
          break
          ;;

        "*")
          echo "That's NOT an option, try again..."
          ;;       
 
      esac

      ##
      ##    Reprint the current settings
      ##

      current_settings

      ##
      ##    The following causes the select
      ##    statement to reprint the menu
      ##

      REPLY=

    done

}



##
##
##

echo "## Testing for 'ansible-playbook' command"

rpm -qi ansible >/dev/null 2>&1

if [[ $? -eq 0 ]] ; then
    echo "Found ansible"
    ANSIBLE_SOURCE="INSTALLED"
fi



##
##
##

echo ""
echo "** THIS IS AN EXPERIMENTAL WORK-IN-PROGRESS AND IS NOT FUNCTIONAL"
echo "** DO NOT USER THIS"
echo ""

main_menu
