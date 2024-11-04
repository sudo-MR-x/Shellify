#!/usr/bin/env bash

# Define colors
COLORS=(
  "\033[0m"      # reset
  "\033[1;35m"   # magenta
  "\033[1;32m"   # green
  "\033[1;37m"   # white
  "\033[1;34m"   # blue
  "\033[1;31m"   # red
  "\033[1;33m"   # yellow
  "\033[1;36m"   # cyan
  "\033[1;40;30m" # black
  "\033[1;43;33m" # background yellow
  "\033[1;47;37m" # background white
)

# Initialize color variables
c0=${COLORS[0]}
c1=${COLORS[1]}
c2=${COLORS[2]}
c3=${COLORS[3]}
c4=${COLORS[4]}
c5=${COLORS[5]}
c6=${COLORS[6]}
c7=${COLORS[7]}
c8=${COLORS[8]}
c9=${COLORS[9]}
c10=${COLORS[10]}

# Functions to retrieve system properties
fetchCodename() { codename="$(getprop ro.product.board)"; }
fetchClientBase() { client_base="$(getprop ro.com.google.clientidbase)"; }
fetchModel() { model="$(getprop ro.product.brand) $(getprop ro.product.model)"; }
fetchOS() { os="$(uname -o) $(uname -m)"; }
fetchKernel() { kernel="$(uname -r)"; }

fetchLANIP() {
    if [ -r /proc/net/dev ]; then
        lan_ip=$(ifconfig | awk '/inet / && $2 != "127.0.0.1" {print $2; exit}')
    else
        lan_ip="NAN"
    fi
}


fetchUptime() { uptime="$(uptime --pretty | sed 's/up//')"; }

fetchMemoryUsage() {
  mem_info=$(free --mega | awk '/Mem:/ {print $3 "MB / " $2 "MB"}')
  memory="$mem_info"
}

fetchDiskUsage() {
  disk_info=$(df -h /data | awk 'NR==2 {print $3 "B / " $2 "B (" $4 "B) " $5}')
  storage="$disk_info"
}

# Main function to display system info
displayInfo() {
clear
  fetchCodename
  fetchClientBase
  fetchModel
  fetchOS
  fetchKernel
  fetchLANIP
  fetchUptime
  fetchMemoryUsage
  fetchDiskUsage

  # Display system info with custom box pattern
  echo -e "\n\n"
  echo -e "  ┏━━━━━━━━━━━━━━━━━━━━━━┓"
  echo -e "  ┃ ${c4}mister x     ${c5}${c0}  ${c6}${c0}  ${c7}${c0} ┃  ${codename}${c5}@${c0}${client_base}"
  echo -e "  ┣━━━━━━━━━━━━━━━━━━━━━━┫"
  echo -e "  ┃                      ┃"
  # Adding the custom box pattern
  echo -e "  ┃   🟩🟩🟩🟩🟩🟩🟩🟩   ┃  ${c1}phone${c0}  ${model}"
  echo -e "  ┃   🟩⬛⬛🟩🟩⬛⬛🟩   ┃  ${c2}IP${c0}     ${lan_ip}"
  echo -e "  ┃   🟩⬛⬛🟩🟩⬛⬛🟩   ┃  ${c3}up${c0}     ${uptime}"
  echo -e "  ┃   🟩🟩🟩⬛⬛🟩🟩🟩   ┃  ${c4}ker${c0}    ${kernel}"
  echo -e "  ┃   🟩🟩🟩⬛⬛🟩🟩🟩   ┃  ${c5}os${c0}     ${os}"
  echo -e "  ┃   🟩🟩⬛⬛⬛⬛🟩🟩   ┃  ${c6}ram${c0}    ${memory}"
  echo -e "  ┃   🟩🟩⬛⬛⬛⬛🟩🟩   ┃  ${c7}disk${c0}   ${storage}"
  echo -e "  ┃   🟩🟩⬛🟩🟩⬛🟩🟩   ┃"
  echo -e "  ┗━━━━━━━━━━━━━━━━━━━━━━┛  ${c1}━━━${c2}━━━${c3}━━━${c4}━━━${c5}━━━${c6}━━━${c7}━━━"
  echo -e "\n\n"
}

# Functions for prompt timer and SVN stats
function prompt_timer_start {
    PROMPT_TIMER=$(date +%s.%3N) # Start the timer
    echo -ne "\033]0;${@}\007"
}

function prompt_svn_stats() {
    command -v svn >/dev/null
    if [ $? != 0 ]; then
        return
    fi

    local WCROOT=$(svn info --show-item wc-root 2>/dev/null)
    if [ -z "$WCROOT" ]; then
        return
    fi

    local SVN_INFO=$(svn info ${WCROOT} 2>/dev/null)
    local CHECKEDOUTURL=$(echo "${SVN_INFO}" |sed -ne 's#^URL: ##p')
    local REV=$(echo "${SVN_INFO}" |sed -ne 's#^Revision: ##p')
    local ROOTURL=$(echo "${SVN_INFO}" |sed -ne 's#^Repository Root: ##p')
    echo " (\e[32m${CHECKEDOUTURL/$ROOTURL\//}\e[1;30m@\e[0;100m${REV})"
}

function prompt_timer_stop {
    local EXIT="$?" # MUST come first
    local NOW=$(date +%s.%3N) # Corrected syntax for command substitution
    echo -ne "\033]0;$USER@$HOSTNAME: $PWD\007"

    local ELAPSED=$(bc <<< "$NOW - $PROMPT_TIMER")
    unset PROMPT_TIMER

    local T=${ELAPSED%.*}
    local AFTER_COMMA=${ELAPSED##*.}
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))

    local TIMER_SHOW=
    [[ $D > 0 ]] && TIMER_SHOW=${TIMER_SHOW}$(printf '%dd ' $D)
    [[ $H > 0 ]] && TIMER_SHOW=${TIMER_SHOW}$(printf '%dh ' $H)
    [[ $M > 0 ]] && TIMER_SHOW=${TIMER_SHOW}$(printf '%dm ' $M)
    TIMER_SHOW=${TIMER_SHOW}$(printf "%d.${AFTER_COMMA}s" $S)

    PS1="\e[0m\n" # begin with a newline
    if [ $EXIT != 0 ]; then
        PS1+="\e[1;41m ✘ ${EXIT}" # red x with error status
    else
        PS1+="\e[1;42m ✔" # green tick
    fi
    PS1+=" \e[0;100;93m $(date +%H:%M)" # Corrected syntax for date command

    local PSCHAR="▶"
    if [ $(id -u) -eq 0 ]; then
        PS1+=" \e[1;31m\h " # root: red hostname
        PSCHAR="\e[1;31m#\e[0m"
    else
        PS1+=" \e[1;32m\h " # non-root: green hostname
    fi
    PS1+="\e[1;94m\w" # working directory

    PS1+=prompt_svn_stats

    PS1+=" \e[0;100;93m${TIMER_SHOW}" # runtime of last command
    PS1+=" \e[0m\n${PSCHAR} " # prompt in new line
}

# see https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

trap 'prompt_timer_start "$BASH_COMMAND (date +%H:%M:%S)"' DEBUG
PROMPT_COMMAND=prompt_timer_stop

# Run the main display function
displayInfo
