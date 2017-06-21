# environmental/shell prefs
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
unsetopt BG_NICE		# do NOT nice bg commands
setopt CORRECT			# command CORRECTION
#setopt MENUCOMPLETE
setopt ALL_EXPORT

REPORTTIME=10

# Set/unset  shell options
setopt   notify globdots pushdtohome autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups
setopt   autopushd pushdminus pushdsilent pushdtohome pushdignoredups
setopt   extendedglob rcquotes mailwarning
setopt   interactivecomments
unsetopt autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
#use shell built-ins for file tasks (prevents limits on arguments, etc.)
zmodload -i zsh/files

#directory stack coolness
DIRSTACKSIZE=15
alias dh='dirs -v'

HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=5000
if [ `uname` = "SunOS" ];then
  HOSTNAME=$HOST
else
  HOSTNAME="`hostname -s`"
fi
PAGER='less'
EDITOR='vim'

# maintain compatibility with fas files
if [[ $ISTYPE == "" ]]; then
  if [ `uname` = "SunOS" ];then
    ISTYPE=$HOST
  else
    ISTYPE=`hostname -s`
  fi
fi

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 || "$termcap[colors]" -ge 80 ]]; then
	colors
	source $HOME/.colors
	PS1="%{$thismachine%}%(#.%{${bg_no_bold[black]}${fg_no_bold[yellow]}%}.)%(?..%{${bg_no_bold[black]}${fg_no_bold[red]}%})%n@$ISTYPE:%~%{${bg_no_bold[default]}${fg_no_bold[default]}%} "
  if [ `uname -n` = 'r2d2' ];then
    PS1="%{$thismachine%}%(#.%{${bg_no_bold[black]}${fg_no_bold[magenta]}%}.)%(?..%{${bg_no_bold[black]}${fg_no_bold[red]}%})%n@$ISTYPE:%~%{${bg_no_bold[default]}${fg_no_bold[default]}%} "
  fi
  #RPROMPT='[%*]'
else
	PS1="%n@$ISTYPE:%~ %!%# "
fi

unsetopt ALL_EXPORT

#change the title of xterms to display user@host: ~ style directory
case $TERM in
    *xterm*|rxvt|(dt|k|E)term*)
        precmd () {print -Pn "\e]0;%n@$ISTYPE: %~\a"}
        ;;
esac

# Read in some zsh functions
if [ -d $HOME/.functions ]; then
	for f in $HOME/.functions/*; do
			source $f
	done	
fi

# Read in aliases file
if [ -s $HOME/.aliases ]; then
  source $HOME/.aliases
fi

shellsync(){
  base="www.hcs.harvard.edu/~vsant/vivek"
  mkdir -p ~/.functions
  for f in .zshrc .zshenv .colors .vimrc .aliases .functions/shcs .functions/mq .functions/_subversion; do
    wget $base$f -q -O ~/$f
  done
  source ~/.zshrc
  echo "Done"
}

# Less promiscuous umask
umask u=rwx,g=x,o=x

autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey "^[[3~" delete-char
bindkey '' beginning-of-line
bindkey '' end-of-line
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=4 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'

#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')
local _myhosts
if [[ -f $HOME/.ssh/known_hosts ]]; then
  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*' hosts $_myhosts
fi 
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort
# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show
