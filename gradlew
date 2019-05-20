#!/bin/bash
set -eu
builddir="$(dirname ${BASH_SOURCE})"
[[ ${builddir} == "." ]] && builddir=$PWD
mvn_project="$(basename $builddir)"
typeset -a commands parameters
h=$(hostname -s)
pid=$$
preCommitText=''
preTagCommitMessage='[gradlew-mvnw release] - pre tag commit: '
tagCommitMessage='[gradlew-mvnw release] - creating tag: '
newVersionCommitMessage='[gradlew-mvnw release] - new version commit: '
versionPropertyFile='pom.xml'

while (( $# > 0 ))
do
    if [[ ${1:0:2} == "--" ]]
    then
        longopt=${1:2}
        case $longopt in
            stop)
                exit 0
                ;;
            *)
                eval "$longopt=1"
                ;;
        esac
    elif [[ ${1:0:1} == "-" ]]
    then
        parameters+=($1)
        parm=${1:2}
        n=${parm%=*}
        v=${parm#*=}
        n=${n//./_}
        eval "${n}=${v}"
    else
        commands+=($1)
    fi
    shift
done

function d
{
    date +"%F %X.%N"
}

function error
{
    echo "[$(d)][$h][$pid][ERROR]$@" >&2
}

function log
{
    echo "[$(d)][$h][$pid][INFO]$@"
}

log "commands: ${commands[@]}"
log "params  : ${parameters[@]}"
log "builddir: ${builddir}"

dbg=

cd "$builddir"
for c in ${commands[@]}
do
    case $c in
        clean)
            ${dbg} ./mvnw clean
            ;;
        build)
            ${dbg} ./mvnw compile
            ;;
        release)
            ${dbg} sed -e "s=<version>.*</version>\( *<name>${mvn_project}</name>\)=<version>${release_releaseVersion}</version>\1=" -i ${versionPropertyFile}
            ${dbg} git commit -am "${preTagCommitMessage}${release_releaseVersion}"
            ${dbg} git tag --force -a "${release_releaseVersion}" -m "${tagCommitMessage}${release_releaseVersion}"
            ${dbg} sed -e "s=<version>.*</version>\( *<name>${mvn_project}</name>\)=<version>${release_newVersion}</version>\1=" -i ${versionPropertyFile}
            ${dbg} sed -e "s:version=.*:version=${release_newVersion}:" -i gradle.properties
            ${dbg} git commit -am "${newVersionCommitMessage}${release_newVersion}"
            ;;
        publish)
            ${dbg} ./mvnw deploy
            ;;
        *)
            error "[$c] is not supported"
            exit
            ;;
    esac
done

