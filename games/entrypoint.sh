#!/bin/bash
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
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

# Run the Server
echo -e ":/home/container$ ${MODIFIED_STARTUP}"
eval ${MODIFIED_STARTUP}