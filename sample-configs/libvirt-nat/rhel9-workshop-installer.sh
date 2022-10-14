#!/bin/bash


ANSIBLE_SOURCE=""
DNS_SERVER=""
TIME_SERVER=""


# ---


current_settings () {

    echo ""
    echo "Current Settings"
    echo "----------------"
    echo "Ansible Source    ... [${ANSIBLE_SOURCE}]"
    echo "DNS Server        ... [${DNS_SERVER}]"
    echo "TIME Server       ... [${TIME_SERVER}]" 
    echo ""
}


# ---


main_menu () {

    PS3="Select Action: "

    current_settings

    select action in "Set Ansible Source" "Set DNS Server" "Set TIME Server" "Install" "Quit"
    do
      case ${action}  in
        "Set Ansible Source" )
          echo "setting ansible source"
          ;;

        "Set DNS Server")
          read -p "Please enter dns server ipv4 address: "  DNS_SERVER
          ;;

        "Set TIME Server")
          read -p "Please enter time server ipv4 address: "  TIME_SERVER
          ;;

        "Install")
          echo "Install"
          break
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

which ansible-playbook >/dev/null 2>&1

if [[ $? -eq 0 ]] ; then
    echo "Found ansible"
    ANSIBLE_SOURCE="INSTALLED"
else
    echo "Need to install ansible"
    ANSIBLE-SOURCE="EPEL"
fi



##
##
##

echo ""
echo "** THIS IS AN EXPERIMENTAL WORK-IN-PROGRESS AND IS NOT FUNCTIONAL"
echo "** DO NOT USER THIS"
echo ""

main_menu
