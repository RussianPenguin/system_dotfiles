# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
 . ~/.bash_aliases
fi

# autocd - автоматический переход в папки без cd
# cdspell - исправление опечаток в cd
# checkjobs - нельзя выйти если есть автивные джобы
# сmdhist - схлопывание многострочных команд
# dirspell - исправление опечаток в именах директорий при автодополнении
# globstar - использование ** для поиска файлов рекурсивно
# histappend - записываем команды в историю сразу
shopt -s autocd 
shopt -s cdspell 
shopt -s checkjobs 
shopt -s cmdhist 
shopt -s dirspell 
shopt -s globstar
shopt -s histappend

# улаояем  из истории мусор
export HISTIGNORE="&:ls*:[bf]g*:exit*:apropos*:man*:history*"
export PROMPT_COMMAND='history -a'

# управление историей: 
# - не запоминает команды, которые начинатся с пробела,
# - не запоминает дубликаты команд
# - стирает уже существующие дубликаты
export HISTCONTROL=ignoreboth:erasedups

# Маска доступов. чтение и запись - владелец. Группа - чтение. Остальные - нет доступа
umask 027

# устанавливаем ширину табов в 2 вместо 8
tabs 2

export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

# зеленый греп
export GREP_COLOR='1;32'
export MANPATH=${HOME}/.local/share/man:$MANPATH

