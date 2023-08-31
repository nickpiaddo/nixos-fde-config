# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

################################################################################
#                        HELPER FUNCTIONS
################################################################################

#function _print_err {
#  echo -e "$1" >&2
#}
#
#function _debug {
#
#  _print_err " "
#  _print_err "words: ${COMP_WORDS[*]}"
#  _print_err "curr: '${COMP_WORDS[COMP_CWORD]}'"
#  _print_err "prev: ${COMP_WORDS[COMP_CWORD - 1]}"
#  _print_err "line: ${COMP_LINE}"
#  _print_err "point: ${COMP_POINT}"
#
#}

######################################################################
# Test if a value is an element of an array
# Arguments:
#   Target
#   Array
# Returns:
#   0 if Target is an element of Array
#   1 otherwise
######################################################################
# Inspired by https://stackoverflow.com/questions/14366390/
function _isElementOf {
  local target=$1
  shift
  local in=1

  for element; do
    if [[ ${element} == "${target}" ]]; then
      in=0
      break
    fi
  done

  return ${in}
}

######################################################################
# Test if a value is an element of an array
# Arguments:
#   Array1
#   Array2
# Returns:
#   An array containing the result of the set difference
#   Array2 - Array1
#
# Example:
#  Array1="a b c d e"
#  Array2="j k l a b"
#
#  _filterOutAssigned Array1 Array2 -> "j k l"
######################################################################
function _filterOutAssigned {
  local array
  read -r -a array <<<"$1"

  local flags="$2"
  local acc=()

  for flag in ${flags}; do
    if ! _isElementOf "${flag}" "${array[@]}"; then
      acc+=("${flag}")
    fi
  done

  echo "${acc[*]}"
}

function _noSuggestion {
  COMREPLY=()
}

function _suggestSpace {
  COMREPLY=(" ")
}

function _suggest {
  read -r -a COMPREPLY <<<"$("$@" | tr "\n" " ")"
}

################################################################################
#                        MAIN PROGRAM
################################################################################

# `nixos-fde-config` completion function.
function _nixos_fde_config {
  local i curr prev opts last_state assigned
  export COMREPLY=()
  curr="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"
  last_state=""
  # Options available.
  opts=""
  # List of flags previously encountered.
  assigned=()

  # Identify the last flag entered.
  #
  # Here we update the state of a finite-state machine while iterating over the
  # words on the command-line. Each flag we identify triggers a state
  # transition.  Along the way, we collect a list of all the flags we have seen
  # so far.
  #
  for i in "${COMP_WORDS[@]}"; do
    case "${last_state}" in
      "") # No option set
        opts="-b --boot-key -h --help --help-rescue -H --home-size -m --main-disk --reset --resume -R --root-size -S --swap-size --version"
        last_state="nixos_fde_config"
        ;;

      nixos_fde_config__help | nixos_fde_config__reset | nixos_fde_config__resume | nixos_fde_config__version) ;;
      *)
        case "${i}" in
          "-b" | "--boot-key")
            opts="-H --home-size -m --main-disk -R --root-size -S --swap-size"
            assigned+=("-b" "--boot-key")
            last_state="nixos_fde_config__boot_key"
            ;;
          "-h" | "--help") last_state="nixos_fde_config__help" ;;
          "-H" | "--home-size")
            opts="-b --boot-key -m --main-disk -R --root-size -S --swap-size"
            assigned+=("-H" "--home-size")
            last_state="nixos_fde_config__home_size"
            ;;
          "-m" | "--main-disk")
            opts="-b --boot-key -H --home-size -R --root-size -S --swap-size"
            assigned+=("-m" "--main-disk")
            last_state="nixos_fde_config__main_disk"
            ;;
          "-R" | "--root-size")
            opts="-b --boot-key -H --home-size -m --main-disk -S --swap-size"
            assigned+=("-R" "--root-size")
            last_state="nixos_fde_config__root_size"
            ;;
          "-S" | "--swap-size")
            opts="-b --boot-key -H --home-size -m --main-disk -R --root-size"
            assigned+=("-S" "--swap-size")
            last_state="nixos_fde_config__swap_size"
            ;;
          "-u" | "--help-rescue") last_state="nixos_fde_config__help_rescue" ;;
          "-z" | "--resume") last_state="nixos_fde_config__resume" ;;
          "--reset") last_state="nixos_fde_config__reset" ;;
          "--version") last_state="nixos_fde_config__version" ;;
        esac
        ;;
    esac
  done

  # Keep the option flags pertinent to suggest after a value is set for the
  # given last_state.
  opts=$(_filterOutAssigned "${assigned[*]}" "${opts}")

  # Show suggestions.
  case "${last_state}" in
    nixos_fde_config)
      # Complete with a white space if the user types nixos-fde-config and hits
      # the <TAB> key.
      if [[ ${COMP_WORD} -eq 1 ]]; then
        _suggestSpace
        return 0
      fi
      ;;

    # Final states of the finite-state machine. We ignore any flag set after
    # the ones below.
    nixos_fde_config__help | \
      nixos_fde_config__help_rescue | \
      nixos_fde_config__reset | \
      nixos_fde_config__resume | \
      nixos_fde_config__version)
      _noSuggestion
      return 0
      ;;

    nixos_fde_config__home_size | \
      nixos_fde_config__root_size | \
      nixos_fde_config__swap_size)
      # If the option value is not set or set with an invalid value...
      if [[ "${prev}" == -* && ! "${curr}" =~ [0-9]+[kKMGT]? ]]; then
        # provide no suggestion.
        _noSuggestion
        return 0
      fi
      ;;

    nixos_fde_config__boot_key | \
      nixos_fde_config__main_disk)
      # If the option value is empty or not a file...
      if [[ "${prev}" == -* && ! -e ${curr} ]]; then
        # suggest a device with a name prefixed '/dev/sd'.
        _suggest compgen -f /dev/sd -- "${curr}"
        return 0
      fi
      ;;
  esac

  # Show available flags to set after the last one currently on the command-line.
  _suggest compgen -W "${opts}" -- "${curr}"
}

complete -F _nixos_fde_config -o bashdefault nixos-fde-config
