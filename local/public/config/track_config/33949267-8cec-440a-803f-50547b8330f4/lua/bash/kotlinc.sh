#!/bin/bash

runFile() {
  kotlinc $2 -include-runtime -d /dev/shm/main.jar &
  pid=$!

  sign="-"

  while [[ -d "/proc/$pid" ]]; do
    echo -ne "\r$sign compiling code"
    case "$sign" in
    "|")
      sign="/"
      ;;
    "/")
      sign="-"
      ;;
    "-")
      sign="\\"
      ;;
    "\\")
      sign="|"
      ;;
    esac

    sleep 0.1
  done

  echo -ne "\rcompilation complete        \n"

  cd /dev/shm/
  kotlin main.jar
  cd $1
  rm /dev/shm/main.jar

}

isGradleBased="$(echo "$1" | grep -o "src/\(main\|test\)/kotlin")"

if [[ -z $isGradleBased ]]; then
  runFile $1 $2
  exit
fi

arg="$(echo $isGradleBased | grep -o "\(test\|main\)")"
arg="$(echo $arg | sed -s 's/main/run/g')"

projRootPath="$(echo "$1" | sed "s|$isGradleBased.*||")"

if [[ ! -z "$(ls $projRootPath | grep -o ".*gradle.*")" ]]; then
  echo "gradle $arg"
  gradle $arg
  exit
fi

projRootPath="$(echo "${projRootPath%/}" | sed 's:/[^/]*$::')"

if [[ ! -z "$(ls $projRootPath | grep -o ".*gradle.*")" ]]; then
  echo "gradle $arg"
  gradle $arg
  exit
fi

runFile $1 $2
