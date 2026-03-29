[ -z "$PS1" ] && return

# When on my MacBook; can add /Library/Frameworks/Python.framework/Versions/3.14/bin but already symlinked in /usr/local/bin
if [[ $OSTYPE = darwin* ]];then
  PATH=/usr/local/bin:/opt/homebrew/bin:$HOME/.local/bin:${PATH}
  export PYTHONPATH="$HOME/.python-local-modules:/Library/Frameworks/Python.framework/Versions/3.14/lib/python3.14/site-packages"
else
  export PYTHONPATH=$HOME/.python-local-modules
fi
  
PATH=$HOME/bin:$PATH:.

export PYTHONSTARTUP=$HOME/.pythonrc.py

# Create variable IS_RHEL_LIKE (1 if on RHEL where zsh 5.9 is hanging on command exec, 0 else)
# Source os-release in a subshell so ID etc don't leak
typeset -g IS_RHEL_LIKE=0
if ( . /etc/os-release 2>/dev/null
     [[ ${ID:-} == rhel ]]
   ); then
  IS_RHEL_LIKE=1
fi
