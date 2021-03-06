#!/usr/bin/env bats
#
# Unit test script for Python3 installer script
#
# This unit test script is using Bats as test framework
# Please refer to https://github.com/bats-core/bats-core for details

@test "test Python3 installer script" {
    # skip this test if installer testing not activated
    if [ -z ${DOT_TEST_INSTALLERS:+x} ]; then
        skip "Please set DOT_TEST_INSTALLERS to activate installer testings"
    fi
    # ensure .bashrc is the updated one
    source ~/.bashrc
    # source the necessary util functions
    source ${BATS_TEST_DIRNAME}/../../util_funcs.sh
    # execute the python3 installer function
    source ${BATS_TEST_DIRNAME}/../../installers/python3.sh
    run install_latest_python3
    # make the changes taking effects
    source ~/.bashrc
    # check the running is successful
    [ "$status" -eq 0 ]
    # check if the latest Python3 has been installed
    run python${DOT_PYTHON3_VER:-3.8} --version
    [ "$status" -eq 0 ]
    # check if pip has been installed
    run pip3 --version
    [ "$status" -eq 0 ]
    # check if pip has been globally disabled
    run pip3 install
    [ "$status" -ne 0 ]
    # check if pipenv has been installed
    LANG=C.UTF-8 pipenv --version >/dev/null
    [[ $? -eq 0 ]]
    # check if virtualenv has been installed
    virtualenv --version >/dev/null
    [[ $? -eq 0 ]]
    # check if virtualenvwrapper has been installed
    if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
        ~/.local/bin/virtualenvwrapper.sh --version >/dev/null
    else
        /usr/local/bin/virtualenvwrapper.sh --version >/dev/null
    fi
    [[ $? -eq 0 ]]
    # check if pyenv has been installed
    $HOME/.pyenv/bin/pyenv -v >/dev/null
    [[ $? -eq 0 ]]
    [ -d "$HOME/.pyenv" ]
}