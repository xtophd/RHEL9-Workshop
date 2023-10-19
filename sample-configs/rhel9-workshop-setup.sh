#!/bin/bash

export RHEL9_VERSION="92"
export WORKSHOP_ADMIN_PW=""
export WORKSHOP_USER_PW=""
export RHSM_UID=""
export RHSM_PW=""
export PROJECT_NAME=""
export ANSIBLE_SOURCE=""
export ANSIBLE_IP=""
export ANSIBLE_VAULT_PW=""
export VIRTHOST_UID="root"
export VIRTHOST_IP=""
export VIRTHOST_PW=""
export VIRTHOST_FQDN=""
export VIRTHOST_TYPE=""
export VIRTHOST_BR_TYPE=""
export VIRTHOST_BR_DEV=""
export OVIRT_MANAGER_UID="admin@internal"
export OVIRT_MANAGER_IP=""
export OVIRT_MANAGER_FQDN=""
export OVIRT_MANAGER_PW=""
export OVIRT_DATACENTER=""
export OVIRT_STORAGE_DOMAIN=""
export OVIRT_NETWORK_DOMAIN=""
export NETWORK_ID=""
export NETWORK_GATEWAY=""
export NETWORK_PREFIX=""
export NETWORK_BROADCAST=""
export NETWORK_NETMASK=""
export NETWORK_BASEDOMAIN=""
export NETWORK_DNS_SERVER=""
export NETWORK_TIME_SERVER=""
export ADDR_BASTION=""
export ADDR_NODE1=""
export ADDR_NODE2=""
export ADDR_NODE3=""
export ADDR_NODE4=""
export ADDR_LEAPP=""
export BMC_BASTION=""
export BMC_NODE1=""
export BMC_NODE2=""
export BMC_NODE3=""
export BMC_NODE4=""
export BMC_LEAPP=""
export BMC_PW_DEFAULT=""
export BMC_PW_BASTION=""
export BMC_PW_NODE1=""
export BMC_PW_NODE2=""
export BMC_PW_NODE3=""
export BMC_PW_NODE4=""
export BMC_PW_LEAPP=""
export MAC_BASTION=""
export MAC_NODE1=""
export MAC_NODE2=""
export MAC_NODE3=""
export MAC_NODE4=""
export MAC_LEAPP=""
export HW_BASTION=""
export HW_NODE1=""
export HW_NODE2=""
export HW_NODE3=""
export HW_NODE4=""
export HW_LEAPP=""
export NAME_BASTION="bastion"
export NAME_NODE1="node1"
export NAME_NODE2="node2"
export NAME_NODE3="node3"
export NAME_NODE4="node4"
export NAME_LEAPP="leapp"


##
##    Load current answer file
##

[[ -e ./config/rhel9-workshop-setup.ans ]] && . ./config/rhel9-workshop-setup.ans


# ---

save_settings () {

##
##    NOTE: don't save passwords 
##          user will always need 
##          to enter ALL of them
##
##          Network broadcast and netmask
##          are calculated from the prefix 
##          and also not saved
##

cat > ./config/rhel9-workshop-setup.ans <<EO_ANSWERS
## Passwords are NEVER saved in this file
RHEL_VERSION="${RHEL_VERSION}"
PROJECT_NAME="${PROJECT_NAME}"
RHSM_UID="${RHSM_UID}"
ANSIBLE_SOURCE="${ANSIBLE_SOURCE}"
ANSIBLE_IP="${ANSIBLE_IP}"
CLUSTER_NAME="${CLUSTER_NAME}"
CLUSTER_WILDCARD="${CLUSTER_WILDCARD}"
CLUSTER_PROVISIONER="${CLUSTER_PROVISIONER}"
CLUSTER_LOADBALANCER_IP="${CLUSTER_LOADBALANCER_IP}"
CLUSTER_API_IP="${CLUSTER_API_IP}"
NETWORK_ID="${NETWORK_ID}"
NETWORK_GATEWAY="${NETWORK_GATEWAY}"
NETWORK_PREFIX="${NETWORK_PREFIX}"
NETWORK_BROADCAST="${NETWORK_BROADCAST}"
NETWORK_NETMASK="${NETWORK_NETMASK}"
NETWORK_BASEDOMAIN="${NETWORK_BASEDOMAIN}"
NETWORK_DNS_SERVER="${NETWORK_DNS_SERVER}"
NETWORK_TIME_SERVER="${NETWORK_TIME_SERVER}" 
VIRTHOST_UID="${VIRTHOST_UID}"
VIRTHOST_IP="${VIRTHOST_IP}"
VIRTHOST_FQDN="${VIRTHOST_FQDN}"
VIRTHOST_TYPE="${VIRTHOST_TYPE}"
VIRTHOST_BR_DEV="${VIRTHOST_BR_DEV}"
VIRTHOST_BR_TYPE="${VIRTHOST_BR_TYPE}"
VIRTHOST_DATACENTER="${VIRTHOST_DATACENTER}"
VIRTHOST_STORAGE_DOMAIN="${VIRTHOST_STORAGE_DOMAIN}"
VIRTHOST_NETWORK_DOMAIN="${VIRTHOST_NETWORK_DOMAIN}"
OVIRT_MANAGER_UID="${OVIRT_MANAGER_UID}"
OVIRT_MANAGER_IP="${OVIRT_MANAGER_IP}"
OVIRT_MANAGER_FQDN="${OVIRT_MANAGER_FQDN}"
OVIRT_DATACENTER="${OVIRT_DATACENTER}"
OVIRT_STORAGE_DOMAIN="${OVIRT_STORAGE_DOMAIN}"
OVIRT_NETWORK_DOMAIN="${OVIRT_NETWORK_DOMAIN}"
ADDR_BASTION="${ADDR_BASTION}"
ADDR_NODE1="${ADDR_NODE1}"
ADDR_NODE2="${ADDR_NODE2}"
ADDR_NODE3="${ADDR_NODE3}"
ADDR_NODE4="${ADDR_NODE4}"
ADDR_LEAPP="${ADDR_LEAPP}"
BMC_BASTION="${BMC_BASTION}"
BMC_NODE1="${BMC_NODE1}"
BMC_NODE2="${BMC_NODE2}"
BMC_NODE3="${BMC_NODE3}"
BMC_NODE4="${BMC_NODE4}"
BMC_LEAPP="${BMC_LEAPP}"
MAC_BASTION="${MAC_BASTION}"
MAC_NODE1="${MAC_NODE1}"
MAC_NODE2="${MAC_NODE2}"
MAC_NODE3="${MAC_NODE3}"
MAC_NODE4="${MAC_NODE4}"
MAC_LEAPP="${MAC_LEAPP}"
HW_BASTION="${HW_BASTION}"
HW_NODE1="${HW_NODE1}"
HW_NODE2="${HW_NODE2}"
HW_NODE3="${HW_NODE3}"
HW_NODE4="${HW_NODE4}"
HW_LEAPP="${HW_LEAPP}"
NAME_BASTION="${NAME_BASTION}"
NAME_NODE1="${NAME_NODE1}"
NAME_NODE2="${NAME_NODE2}"
NAME_NODE3="${NAME_NODE3}"
NAME_NODE4="${NAME_NODE4}"
NAME_LEAPP="${NAME_LEAPP}"
EO_ANSWERS

}


# ---

current_settings () {

    if [[ ! -z ${NETWORK_PREFIX} && ! -z ${NETWORK_ID} ]]; then
        NETWORK_BROADCAST=`ipcalc ${NETWORK_ID}/${NETWORK_PREFIX} -b | cut -d= -f2` 
        NETWORK_NETMASK=`ipcalc ${NETWORK_ID}/${NETWORK_PREFIX} -m | cut -d= -f2` 
    fi

    ##
    ##    Bash Lesson:  the bash shell parameter expansion ':+' passes
    ##                  expansion if paramenter is set and not null
    ##

    echo ""
    echo "Current Settings (UID/PW)"
    echo "----------------"
    echo "Project Name          ... ${PROJECT_NAME}"
    echo "Vault Ansible  UID/PW ... - / ${ANSIBLE_VAULT_PW:+"**********"}" 
    echo "Vault Admin    UID/PW ... - / ${WORKSHOP_ADMIN_PW:+"**********"}" 
    echo "Vault User     UID/PW ... - / ${WORKSHOP_USER_PW:+"**********"}" 
    echo "Vault RHSM     UID/PW ... ${RHSM_UID} / ${RHSM_PW:+"**********"}" 
    echo "Vault LibVirt  UID/PW ... ${VIRTHOST_UID} / ${VIRTHOST_PW:+"**********"}" 
    echo "Vault oVirt    UID/PW ... ${OVIRT_MANAGER_UID} / ${OVIRT_MANAGER_PW:+"**********"}" 
  
    echo "Password BMC Default    ... ${BMC_PW_DEFAULT:+"**********"}" 
    echo "Ansible Source          ... ${ANSIBLE_SOURCE}"
    echo "Ansible Control Host IP ... ${ANSIBLE_IP}"
    echo "Network (id/pre/nm/bc)  ... ${NETWORK_ID} / ${NETWORK_PREFIX} / ${NETWORK_NETMASK} / ${NETWORK_BROADCAST}"
    echo "Network Gateway         ... ${NETWORK_GATEWAY}"
    echo "Network DNS Server      ... ${NETWORK_DNS_SERVER}"
    echo "Network TIME Server     ... ${NETWORK_TIME_SERVER}" 
    echo "Network Base Domain     ... ${NETWORK_BASEDOMAIN}"

    echo "vHost Type              ... ${VIRTHOST_TYPE}"
    if [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "ovirt" ]]; then
        echo "oVirt API (ip/fqdn)     ... ${OVIRT_MANAGER_IP} / ${OVIRT_MANAGER_FQDN}" 
        echo "oVirt (dc/blk/net)      ... ${OVIRT_DATACENTER} / ${OVIRT_STORAGE_DOMAIN} / ${OVIRT_NETWORK_DOMAIN}" 
    elif [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "libvirt" ]]; then
        echo "Libvirt Host (ip/fqdn)  ... ${VIRTHOST_IP} / ${VIRTHOST_FQDN}" 
        echo "Libvirt Net (dev/type)  ... ${VIRTHOST_BR_DEV} / ${VIRTHOST_BR_TYPE}" 
    fi

    echo "NODE SETTINGS (ip/mac/hw/bmc/name)" 
    echo "Bastion  : ${ADDR_BASTION} / ${MAC_BASTION} / ${HW_BASTION} / ${BMC_BASTION} / ${NAME_BASTION}"
    echo "Node1  : ${ADDR_NODE1} / ${MAC_NODE1} / ${HW_NODE1} / ${BMC_NODE1} / ${NAME_NODE1}"
    echo "Node2  : ${ADDR_NODE2} / ${MAC_NODE2} / ${HW_NODE2} / ${BMC_NODE2} / ${NAME_NODE2}"
    echo "Node3  : ${ADDR_NODE3} / ${MAC_NODE3} / ${HW_NODE3} / ${BMC_NODE3} / ${NAME_NODE3}"
    echo "Node4  : ${ADDR_NODE4} / ${MAC_NODE4} / ${HW_NODE4} / ${BMC_NODE4} / ${NAME_NODE4}"
    echo "Leapp  : ${ADDR_LEAPP} / ${MAC_LEAPP} / ${HW_LEAPP} / ${BMC_LEAPP} / ${NAME_LEAPP}"
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



    echo -n "## Parsing sample-configs"



    echo -n "## Templating configuration files"
    ansible-playbook sample-configs/rhel9-workshop-setup.yml

    echo -n "## Encrypt the credentials.yml"

    if [[ -z "${ANSIBLE_VAULT_PW}" ]]; then
      echo " - FAILED" 
      echo "WARNING: you must set the ANSIBLE_VAULT_PW"
      return 1
    else
      echo "${ANSIBLE_VAULT_PW}" > ./config/vault-pw.tmp
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

node_submenu () {


    NODE="$1"

    SAVED_PROMPT2="$PS3"

    PS3="$NODE SETTINGS (Select Action): "

    current_settings

    select action in "Set Name" "Set IP Address" "Set MAC Address" "Set Hardware" "Set BMC Address" "Set BMC Password" "Delete Node" "Back to Node Settings"
    do
      case ${action}  in
        "Set Name")
          MAGIC_VAR="NAME_$NODE"
          read -p "Enter Node Name [${!MAGIC_VAR}]: " input
          eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          ;;
        "Set Hardware")
          MAGIC_VAR="HW_$NODE"
          read -p "Enter Hardware Profile [${!MAGIC_VAR}]: " input
          eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          ;;
        "Set IP Address")
          MAGIC_VAR="ADDR_$NODE"
          read -p "Enter IP Address [${!MAGIC_VAR}]: " input
          eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          ;;
        "Set MAC Address")
          MAGIC_VAR="MAC_$NODE"
          read -p "Enter MAC Address [${!MAGIC_VAR}]: " input
          eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          ;;
        "Set BMC Address")
          MAGIC_VAR="BMC_$NODE"
          read -p "Enter BMC Address [${!MAGIC_VAR}]: " input
          eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          ;;
        "Set BMC Password")
          MAGIC_VAR="BMC_PW_$NODE"
          echo "Enter new password and press Enter"
          read -s -p "Enter bmc password [${!MAGIC_VAR:+"**********"}]: " input
          echo ""
          read -s -p "Enter bmc password again [${!MAGIC_VAR:+"**********"}]: " input2
          echo ""

          if [[ "$input" == "$input2" ]]; then
            eval ${MAGIC_VAR}=${input:-${!MAGIC_VAR}}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;
        "Delete Node")
          read -p "DELETE $NODE ... ARE YOU SURE (Y/N): " input
          if [[ "$input" == "Y" ]]; then
            for MAGIC_VAR in HW_$NODE ADDR_$NODE MAC_$NODE BMC_$NODE BMC_PW_$NODE; do
              eval ${MAGIC_VAR}=""
            done
          fi
          ;;
        "Back to Node Settings")
          PS3=${SAVED_PROMPT2}
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

# ---

node_menu () {

    SAVED_PROMPT="$PS3"

    PS3="NODE SETTINGS (select node): "

    current_settings

    select action in "Bastion" "Node1" "Node2" "Node3" "Node4" "Leapp" "Back to Main Menu"
    do
      case ${action}  in
        "Bastion")
          node_submenu BASTION
          ;;
        "Node1")
          node_submenu NODE1
          ;;
        "Node2")
          node_submenu NODE2 
          ;;
        "Node3")
          node_submenu NODE3
          ;;
        "Node4")
          node_submenu NODE4
          ;;
        "Leapp")
          node_submenu LEAPP
          ;;
        "Back to Main Menu")
          PS3=${SAVED_PROMPT}
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



# ---

vault_menu () {

    SAVED_PROMPT="$PS3"

    PS3="VAULT MENU: "

    current_settings

    select action in "Set Ansible Vault Password" "Set Workshop Admin Password" "Set Workshop User Password" "Set RHSM UID" "Set RHSM Password" "Set vHost Password" "Set oVirt Password" "Set Default BMC Password" "Back to Main Menu"
    do
      case ${action}  in

        "Set Ansible Vault Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter ansible vault password [${ANSIBLE_VAULT_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter ansible vault password again [${ANSIBLLE_VAULT_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            ANSIBLE_VAULT_PW=${input:-$ANSIBLE_VAULT_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set Workshop Admin Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter ansible vault password [${WORKSHOP_ADMIN_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter ansible vault password again [${WORKSHOP_ADMIN_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            WORKSHOP_ADMIN_PW=${input:-$WORKSHOP_ADMIN_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set Workshop User Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter ansible vault password [${WORKSHOP_USER_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter ansible vault password again [${WORKSHOP_USER_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            WORKSHOP_USER_PW=${input:-$WORKSHOP_USER_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set RHSM UID")
          read -p "Enter Red Hat Subscription Manager User ID [${RHSM_UID}]: " input
          RHSM_UID=${input:-$RHSM_UID}
          ;;

        "Set RHSM Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter Red Hat Subscription Manager password [${RHSM_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter Red Hat Subscription Manager password again [${RHSM_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            RHSM_PW=${input:-$RHSM_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set vHost Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter libvirt host password [${VIRTHOST_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter libvirt host password again [${VIRTHOST_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            VIRTHOST_PW=${input:-$VIRTHOST_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set oVirt Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter ovirt manager password [${OVIRT_MANAGER_PW:+"**********"}]: " input
          echo ""
          read -s -p "Enter ovirt manager password again [${OVIRT_MANAGER_PW:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            OVIRT_MANAGER_PW=${input:-$OVIRT_MANAGER_PW}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Set Default BMC Password")
          echo "Enter new password and press Enter"
          read -s -p "Enter BMC default password [${BMC_PW_DEFAULT:+"**********"}]: " input
          echo ""
          read -s -p "Enter BMC default password again [${BMC_PW_DEFAULT:+"**********"}]: " input2
          echo ""
          echo ""

          if [[ "$input" == "$input2" ]]; then
            BMC_PW_DEFAULT=${input:-$BMC_PW_DEFAULT}
          else
            echo "WARNING: Passwords do not match ... unchanged"
          fi
          ;;

        "Back to Main Menu")
          PS3=${SAVED_PROMPT}
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
# ---

virthost_menu () {

    SAVED_PROMPT="$PS3"

    PS3="VIRT HOST MENU: "

    current_settings

    action=""

    until [ "${action}" == "Back to Main Menu" ] 
    do

      if [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "ovirt" ]]; then
        TYPE_ACTIONS=("Set Manager UID" "Set Manager IP" "Set Manager FQDN" "Set Datacenter" "Set Storage Domain" "Set Network Domain")
      elif [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "libvirt" ]]; then
        TYPE_ACTIONS=("Set vHost UID" "Set vHost IP" "Set vHost FQDN" "Set Bridge Device" "Set Bridge Type")
      fi


      select action in "Set vHost Type" "${TYPE_ACTIONS[@]}" "Delete vHost" "Back to Main Menu"
      do
        case ${action}  in
          "Set vHost UID")
            read -p "Enter libvirt host User ID [${VIRTHOST_UID}]: " input
            VIRTHOST_UID=${input:-$VIRTHOST_UID}
            ;;
  
          "Set vHost IP")
            read -p "Enter libvirt host IP [${VIRTHOST_IP}]: " input
            VIRTHOST_IP=${input:-$VIRTHOST_IP}
            ;;
  
          "Set vHost FQDN")
            read -p "Enter libvirt host FQDN [${VIRTHOST_FQDN}]: " input
            VIRTHOST_FQDN=${input:-$VIRTHOST_FQDN}
            ;;
  
          "Set vHost Type")
            select VIRTHOST_TYPE in "libvirt" "ovirt"
            do
              case ${VIRTHOST_TYPE} in
                "libvirt" )
                  break ;;
                "ovirt" )
                  break ;;
                "*" )
                   ;;
              esac
              REPLY=
            done

            current_settings
            REPLY=

            break
            ;;

          "Set Bridge Device")
            read -p "Enter libvirt host bridge device[${VIRTHOST_BR_DEV}]: " input
            VIRTHOST_BR_DEV=${input:-$VIRTHOST_BR_DEV}
            ;;
  
          "Set Bridge Type")
             select VIRTHOST_BR_TYPE in "bridge" "macvtap" "nat"
             do
                case ${VIRTHOST_BR_TYPE} in
                  "bridge" )
                    break ;;
                  "macvtap" )
                    break ;;
                  "nat" )
                    break ;;
                  "*" )
                    ;;
                esac
                REPLY=
              done
            ;;
  
          "Set Manager UID")
            read -p "Enter oVirt Manager UID[${OVIRT_MANAGER_UID}]: " input
            OVIRT_MANAGER_UID=${input:-$OVIRT_MANAGER_UID}
            ;;
  
          "Set Manager IP")
            read -p "Enter oVirt Manager IP[${OVIRT_MANAGER_IP}]: " input
            OVIRT_MANAGER_IP=${input:-$OVIRT_MANAGER_IP}
            ;;
  
          "Set Manager FQDN")
            read -p "Enter oVirt Manager FQDN[${OVIRT_MANAGER_FQDN}]: " input
            OVIRT_MANAGER_FQDN=${input:-$OVIRT_MANAGER_FQDN}
            ;;
  
          "Set Datacenter")
            read -p "Enter oVirt Datacenter[${OVIRT_DATACENTER}]: " input
            OVIRT_DATACENTER=${input:-$OVIRT_DATACENTER}
            ;;
  
          "Set Network Domain")
            read -p "Enter oVirt Network Domain[${VIRTHOST_NETWORK_DOMAIN}]: " input
            OVIRT_NETWORK_DOMAIN=${input:-$OVIRT_NETWORK_DOMAIN}
            ;;

          "Set Storage Domain")
            read -p "Enter oVirt Storage Domain[${OVIRT_STORAGE_DOMAIN}]: " input
            OVIRT_STORAGE_DOMAIN=${input:-$OVIRT_STORAGE_DOMAIN}
            ;;
  
          "Delete vHost")
            read -p "DELETE $NODE ... ARE YOU SURE (Y/N): " input
            if [[ "$input" == "Y" ]]; then
              if [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "libvirt" ]]; then
                  VIRTHOST_IP=""
                  VIRTHOST_PW=""
                  VIRTHOST_FQDN=""
                  VIRTHOST_TYPE=""
                  VIRTHOST_BR_TYPE=""
                  VIRTHOST_BR_DEV=""
              elif [[ ! -z ${VIRTHOST_TYPE} && "${VIRTHOST_TYPE}" == "ovirt" ]]; then
                  OVIRT_IP=""
                  OVIRT_API=""
                  OVIRT_PW=""
                  OVIRT_DATACENTER=""
                  OVIRT_STORAGE_DOMAIN=""
                  OVIRT_NETWORK_DOMAIN=""
              fi
            fi
            ;;
  
          "Back to Main Menu")
            PS3=${SAVED_PROMPT}
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

    done

}


# ---

network_menu () {

    SAVED_PROMPT="$PS3"

    PS3="NETWORK MENU: "

    current_settings

    select action in "Set ID" "Set Prefix" "Set Gateway" "Set Base Domain" "Set DNS Server" "Set TIME Server" "Back to Main Menu"
    do
      case ${action}  in
        "Set ID")
          read -p "Enter network id [${NETWORK_ID}]: " input
          NETWORK_ID=${input:-$NETWORK_ID}
          ;;

        "Set Prefix")
          read -p "Enter prefix [${NETWORK_PREFIX}]: " input
          NETWORK_PREFIX=${input:-$NETWORK_PREFIX}
          ;;

        "Set Gateway")
          read -p "Enter gateway[${NETWORK_GATEWAY}]: " input
          NETWORK_GATEWAY=${input:-$NETWORK_GATEWAY}
          ;;

        "Set Base Domain")
          read -p "Enter base domain [${NETWORK_BASEDOMAIN}]: " input
          NETWORK_BASEDOMAIN=${input:-$NETWORK_BASEDOMAIN}
          ;;

        "Set DNS Server")
          read -p "Enter dns server ipv4 address [${NETWORK_DNS_SERVER}]: " input
          NETWORK_DNS_SERVER=${input:-$NETWORK_DNS_SERVER}
          ;;

        "Set TIME Server")
          read -p "Enter time server ipv4 address [${NETWORK_TIME_SERVER}]: " input
          NETWORK_TIME_SERVER=${input:-$NETWORK_TIME_SERVER}
          ;;

        "Back to Main Menu")
          PS3=${SAVED_PROMPT}
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


# ---

rhel9_menu () {

    SAVED_PROMPT="$PS3"

    PS3="RHEL9 MENU: "

    current_settings

    select action in "Set Version" "Back to Main Menu"
    do
      case ${action}  in

        "Set Version")
           select RHEL9_VERSION in "9.0" "9.1" "9.2"
           do
              case ${RHEL9_VERSION} in
                "9.0" | \
                "9.1" | \
                "9.2" )
                  break ;;
                "*" )
                  ;;
              esac
              REPLY=
            done
          ;;

        "Back to Main Menu")
          PS3=${SAVED_PROMPT}
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

# ---

ansible_menu() {

    SAVED_PROMPT="$PS3"

    PS3="ANSIBLE SETTINGS (select node): "

    current_settings

    select action in "Set Ansible Source" "Set Control Host IP" "Back to Main Menu"
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

        "Set Control Host IP")
          read -p "Enter network id [${ANSIBLE_IP}]: " input
          ANSIBLE_IP=${input:-$ANSIBLE_IP}
          ;;

        "Back to Main Menu")
          PS3=${SAVED_PROMPT}
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

# ---

main_menu () {

    PS3="MAIN MENU (select action): "

    current_settings

    select action in "Set Project Name" \
                     "Vault Settings" \
                     "Ansible Settings" \
                     "RHEL9 Settings" \
                     "Network Settings" \
                     "Virt Host Settings" \
                     "Node Settings" \
                     "Prepare Deployment" \
                     "Save & Quit"
    do
      case ${action}  in

        "Set Project Name")
          read -p "Enter Prooject Name [${PROJECT_NAME}]: " input
          PROJECT_NAME=${input:-$PROJECT_NAME}
          ;;
        "Vault Settings")
          vault_menu
          ;;
        "Ansible Settings")
          ansible_menu
          ;;
        "RHEL9 Settings")
          rhel9_menu
          ;;
        "Network Settings")
          network_menu
          ;;
        "Virt Host Settings")
          virthost_menu
          ;;
        "Node Settings")
          node_menu
          ;;
        "Prepare Deployment")
          save_settings
          prepare_deployment
          ;;
        "Save & Quit")
          save_settings
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
##    Testing for 'ansible-playbook' command
##

[[ -x `which ansible-playbook` ]] && ANSIBLE_SOURCE="INSTALLED"


##
##    Engage the main_menu
##

main_menu



