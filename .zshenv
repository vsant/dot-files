[ -z "$PS1" ] && return

GNU="true"

if [ `uname -n` = "trajan.hcs.harvard.edu" ];then
	PATH=$PATH:/var/lib/mailman/bin
  alias mman='cd /var/lib/mailman/'
fi

# When on any HCS machine
if [ `uname -n | cut -d'.' -f2` = "hcs" ] && [ `whoami` = "vsant" ];then
  mesg n
fi

# When on my MacBook
if [ `uname` = "Darwin" ];then
  PATH=/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/opt/subversion/bin:${PATH}
  if [ `uname -n` = "Viveks-MacBook-Air.local" ];then
    ISTYPE='c3po'
    sudo () { ( unset LD_LIBRARY_PATH DYLD_LIBRARY_PATH; exec command sudo $* ) }
  fi
  if [ `uname -n` = "Viveks-MacBook.local" ];then
    ISTYPE='vader'
  fi
  if [ `whoami` = "Sharada" ];then
    ISTYPE='vader'
  fi
  export PYTHONPATH="$HOME/.python-local-modules:$HOME/Library/Python/2.7/site-packages"
else
  export PYTHONPATH=$HOME/.python-local-modules
fi
  
PATH=$HOME/bin:$PATH:.

export PYTHONSTARTUP=$HOME/.pythonrc.py
export LD_LIBRARY_PATH=/home/people/vsant/usr/lib64
