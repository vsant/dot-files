[ -z "$PS1" ] && return

GNU="true"

# When on any HCS machine
if [ `uname -n | cut -d'.' -f2` = "hcs" ] && [ `whoami` = "vsant" ];then
  mesg n
fi

# When on my MacBook
if [ `uname` = "Darwin" ];then
  PATH=/usr/local/bin:/opt/homebrew/bin:$HOME/Library/Python/3.9/bin:${PATH}
  if [ `uname -n | cut -d'.' -f1` = "Viveks-Air" ];then
    ISTYPE='c3po'
  fi
  export PYTHONPATH="$HOME/.python-local-modules:$HOME/Library/Python/3.9/lib/python/site-packages"
else
  export PYTHONPATH=$HOME/.python-local-modules
fi
  
PATH=$HOME/bin:$PATH:.

export PYTHONSTARTUP=$HOME/.pythonrc.py

# When on BioHPC
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/cm/shared/apps/python/3.12.x-mamba/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/cm/shared/apps/python/3.12.x-mamba/etc/profile.d/conda.sh" ]; then
        . "/cm/shared/apps/python/3.12.x-mamba/etc/profile.d/conda.sh"
    else
        export PATH="/cm/shared/apps/python/3.12.x-mamba/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
