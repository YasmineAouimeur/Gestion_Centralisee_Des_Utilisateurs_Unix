#!/bin/bash
##################################################
# Name: delete-user.sh
# Description: Automates the removal of a user from a system.
##################################################
# get_answer Function
#
function get_answer {
#
unset ANSWER
ASK_COUNT=0
#
while [ -z "$ANSWER" ] #While no answer is given, keep asking.
do
	ASK_COUNT=$[ $ASK_COUNT + 1 ]
#
	case $ASK_COUNT in # IF user gives no answer in time alloted
	2)
		echo
		echo "Please answer the question."
		echo

	;;
	3)
		echo
		echo "One last try... please answer the question."
		echo

	;;
	4)
		echo
		echo "Since you refuse to answer the question..."
		echo "exiting program."
		echo
		#
		exit

	;;
	esac
#
	echo
#
	if [ -n "$LINE2" ]
	then	# print 2 lines
		echo $LINE1
		echo -e $LINE2" \c"
	else	#  print 1 line
		echo -e $LINE1" \c"
	fi
#
# Allow 60 seconds to answer before time-out
	read -t 60 ANSWER
done
# Do a little variable clean-up
unset LINE1
unset LINE2
#
} # End of get_answer function
#
#############################################
#process_answer Function
#
function process_answer {
#
case $ANSWER in
y|Y|YES|yes|Yes|yEs|yeS|YEs|yES )
# If user answers "yes", do nothing.
;;
*)
# IF user answers anything but "yes", exit script
	echo
	echo $EXIT_LINE1
	echo $EXIT_LINE2
	echo
	exit
;;
esac
#
# Do a little variable clean-up
#
unset EXIT_LINE1
unset EXIT_LINE2
#
} # End of Function Definitions.
#
#############################################
# End of Function Definitions
#
################: Main Script :##############
# Get name of User Account to check
#
if [ $(id -u) -eq 0 ]; then
	clear
	echo
	echo "*-------------------------------------------------------------------------*"
	echo "Step #1 - Determine User Account to Delete "
	echo "*-------------------------------------------------------------------------*"
	echo
	LINE1="Enter the username of the user "
	LINE2="account you wish to delete from system:"
	get_answer
	USER_ACCOUNT=$ANSWER
	#
	# Double check with script user that this is the correct User account
	#
	LINE1="IS $USER_ACCOUNT the user account "
	LINE2="you wish to delete from system? [y/n]"
	get_answer
	#
	# Call process_answer function:
	#	if user answers anything but "yes", exit script
	#
	EXIT_LINE1="Because the account, $USER_ACCOUNT, is not "
	EXIT_LINE2="the one you wish to delete, we are leaving script..."
	process_answer
	#
	##################################################################
	# Check that USER_ACCOUNT is really an account on the system
	#
	USER_ACCOUNT_RECORD=$(cat /etc/passwd | grep -w $USER_ACCOUNT)
	#
	if [ $? -eq 1 ]		# If the account is not found, exit script
	then
	echo "Account, $USER_ACCOUNT, not found. "
		echo "Leaving the Script..."
		echo
		exit
	fi
		echo
		echo "I found the record:"
		echo $USER_ACCOUNT_RECORD
		echo
	#
	LINE1="Is this the correct User Account? [y/n]"
	get_answer
	#
	#
	# Call process_answer function:
	#	if user answers anything but "yes", exit script
	#
	EXIT_LINE1="Because the account, $USER_ACCOUNT, is not "
	EXIT_LINE2="the one you wish to delete, we are leaving the script..."
	process_answer
	#
	##################################################################
	# Search for any running processes that belong to the User Account
	#
	
else
	echo "Only root may delete a user from the system"
	exit 2
fi