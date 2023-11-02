#!/bin/sh

# Functions
function git_status() {
    awk -vOFS='' '
    NR==FNR {
        all[i++] = $0;
        difffiles[$1] = $0;
        next;
    }
    ! ($2 in difffiles) {
        print; next;
    }
    {
        gsub($2, difffiles[$2]);
        print;
    }
    END {
        if (NR != FNR) {
            # Had diff output
            exit;
        }
        # Had no diff output, just print lines from git status -sb
        for (i in all) {
            print all[i];
        }
    }
' \
    <(git diff --color --stat=$(($(tput cols) - 3)) HEAD | sed '$d; s/^ //')\
    <(git -c color.status=always status -sb)
}

# Variables
PREFIX="\033[1m\033[33mPterodactyl:\033[0m "

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Go to the server folder
cd /home/container || exit 1

# Update Current Git Version
printf "${PREFIX}git --version\n"
git --version

# Pull Updates
if [ "${UPDATE}" == "1" ]; then
    printf "${PREFIX}Starting update process...\n"
    if [ -d ".git" ]; then
        git pull
    else
        if [ ! "$(ls -A /home/container)" ]; then
            printf "${PREFIX}Downloading files...\n"
            if [ -n "${GIT_BRANCH}" ]; then
                printf "${PREFIX}Using custom git branch: ${GIT_BRANCH}...\n"
                git clone ${GIT_REPO} . -b ${GIT_BRANCH}
            else
                printf "${PREFIX}Using default git branch...\n"
                git clone ${GIT_REPO} .
            fi
        else
            printf "${PREFIX}Directory not empty, cannot download, clear directory to allow it...\n"
        fi
    fi
    printf "${PREFIX}Update process completed...\n"
else
    printf "${PREFIX}Updating process disabled...\n"
fi

# Warn the user for local changes
if [ -d ".git" ]; then
    if [ "$(git status --porcelain)" ]; then
        printf "${PREFIX}Your server directory contains modified files that are NOT part of this project:\n"
        git_status
    fi

fi

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# Inform the user of the server startup
printf "${PREFIX}Startup command: ${PARSED}\n"
printf "${PREFIX}Server container started!\n"
exec env ${PARSED}