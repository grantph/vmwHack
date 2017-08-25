echo
echo "Creates https://<hostname or ip>/vmrc.html"
echo
echo "vmrc.html containts a list of ALL registered VMs, and spawns the VMRC application when clicked"
echo
echo "By installing vmrc.html in /docroot, there is NO authentication - your list of VMs are exposed/unsecure. However, VMRC requires login to interact with VM. Recommend using /ui/ folder if security is required."
echo

if [[ "$1" = "" ]]; then echo "vmrc.sh <hostname or ip>"; echo; exit; fi

HOST=$1

RUNNING=$(esxcli vm process list | grep -E '^([A-Z])')
HTML=$(vim-cmd vmsvc/getallvms | grep -E '^([0-9])' | sort -k 2,2 | awk '{ printf "<a href=\"vmrc://[HOST]/?moid=%s\">%s</a><br>\n", $1, $2 }')

echo "<html><body><h1>VMRC Launcher</h1><p style='line-height:1.4em;'>" > /usr/lib/vmware/hostd/docroot/vmrc.html
echo ${HTML//\[HOST\]/$HOST} >> /usr/lib/vmware/hostd/docroot/vmrc.html
echo "</p></body></html>" >> /usr/lib/vmware/hostd/docroot/vmrc.html
