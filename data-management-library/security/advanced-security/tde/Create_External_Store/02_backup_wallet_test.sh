#!/bin/bash

# keep track of script usage with a simple curl query
# the remote host runs nginx and uses a javascript function to mask your public ip address
# see here for details: https://www.nginx.com/blog/data-masking-user-privacy-nginscript/
#
file_path=`realpath "$0"`
curl -Is --connect-timeout 3 http://150.136.21.99:6868${file_path} > /dev/null

# generate an output based on the script name
outfile=$(basename -s .sh $0)".out"
#echo $outfile
rm -f $outfile 2>&1
exec > >(tee -a $outfile) 2>&1

echo
echo "Backup the wallet. This will demonstrate you can still perform certain activities without knowing the wallet password."
echo

sqlplus -s / as sysdba <<EOF
--
ADMINISTER KEY MANAGEMENT BACKUP KEYSTORE USING 'BACKUP_USING_EXTERNAL_STORE'  FORCE KEYSTORE IDENTIFIED BY EXTERNAL STORE;
EOF

echo
echo "View the contents of the directory that holds the TDE wallets..."
echo "You should see a new file with the phrase 'BACKUP_USING_EXTERNAL_STORE' in the file name."
echo
ls -al $WALLET_DIR/tde

echo
