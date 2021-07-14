if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
export PATH=$HOME/.node_modules/bin:$PATH
# Custom bin 
export PATH=$HOME/bin:$PATH
# Garmin SDKs 
# export PATH=`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin:$PATH

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

export SPICETIFY_INSTALL="/home/mark/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

/home/mark/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
