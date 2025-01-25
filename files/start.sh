#!/usr/bin/bash
set -eu

#!/usr/bin/bash
set -eu

# Export CPU frequency if necessary
if ! test -e "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"; then
    export CPU_MHZ=${CPU_MHZ:-1600}
fi

# Install/update 7 Days to Die
/usr/games/steamcmd \
    +@sSteamCmdForcePlatformBitness 64 \
    +force_install_dir "$HOME/app" \
    +login anonymous \
    +app_update 380870 \
    +quit

# Execute server
export JSIG="libjsig.so"
export LD_PRELOAD="$JSIG" 
export PATH="$HOME/app/jre64/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/app/linux64:$HOME/app/natives:$HOME/app/jre64/lib/server:$HOME/app/jre64/lib:$HOME/app"

cd "$HOME/app"
exec ./ProjectZomboid64 "$@"
