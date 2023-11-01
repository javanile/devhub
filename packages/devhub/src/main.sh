
module commands

legacy getoptions

VERSION="DevHub 0.1.1 (2023-10-24)"

parser_definition() {
  setup REST error:args_error help:usage abbr:true -- "Development Stack Manager" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  disp  VERSION -V --version                      -- "Print version info and exit"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET   -q --quiet                        -- "Do not print cargo log messages"
  disp  :usage  -h --help                         -- "Print help information"

  msg           -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   start   -- "Start the development stack"
}

args_error() {
  case "$2" in
    notcmd)
      echo -e "No such command: '$3'\n\n\tView all available commands with 'devhub --help'" >&2
      ;;
    required)
      echo -e "Argument to option '$3' missing." >&2
      ;;
    *)
      echo "ERROR: ($2 $3) $1" >&2
  esac
  exit 101
}

main() {
  if [ $# -eq 0 ]; then
    eval "set -- --help"
  fi

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

  if [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
      start)
        devhub_start "$@"
        ;;
      --)
    esac
  fi
}
