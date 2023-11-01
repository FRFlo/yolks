#!/bin/sh

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


cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Update Current Git Version
printf "\033[1m\033[33mPterodactyl: \033[0mgit --version\n"
git --version

# Pull Updates
if [ "${UPDATE}" == "1" ]; then
    printf "\033[1m\033[33mPterodactyl: \033[0mStarting update process...\n"
    if [ -d ".git" ]; then
        git pull
    else
        if [ ! "$(ls -A /home/container)" ]; then
            printf "\033[1m\033[33mPterodactyl: \033[0mDownloading files...\n"
            if [ -n "${GIT_BRANCH}" ]; then
                printf "\033[1m\033[33mPterodactyl: \033[0mUsing custom git branch: ${GIT_BRANCH}\n"
                git clone ${GIT_REPO} . -b ${GIT_BRANCH}
            else
                printf "\033[1m\033[33mPterodactyl: \033[0mUsing default git branch\n"
                git clone ${GIT_REPO} .
            fi
        else
            printf "\033[1m\033[33mPterodactyl: \033[0mDirectory not empty, cannot download, clear directory to allow it...\n"
        fi
    fi
    printf "\033[1m\033[33mPterodactyl: \033[0mUpdate process completed...\n"
else
    printf "\033[1m\033[33mPterodactyl: \033[0mUpdating process disabled...\n"
fi

# Warn the user for local changes
if [ -d ".git" ]; then
    if [ "$(git status --porcelain)" ]; then
        printf "\033[1m\033[33mPterodactyl: \033[0mYour server directory contains modified files that are NOT part of this project:\n"
        git_status();
    fi

fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

# Run the Server
echo -e ":/home/container$ ${MODIFIED_STARTUP}"
eval ${MODIFIED_STARTUP}