# vagrant_cmds.sh
#
# Useful vagrant commands

# Create the Vagrant VM
alias start='vagrant up'

# TODO: zeroize free space so it compresses well
# make sure the VM disk size is not large

# Create the box for publishing
alias stop='vagrant halt'
alias mkbox='vagrant package --output clouddata.box'
