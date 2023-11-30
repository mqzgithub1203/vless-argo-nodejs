#!/usr/bin/env bash
# =============设置一下参数=========

export UUID=${UUID:-'fd80f56e-93f3-4c85-b2a8-c77216c509a7'}
export VPORT=${VPORT:-'8002'}
export VPATH=${VPATH:-'vls'}

# ===============分割线===============
chmod 777 ./web.js
nohup ./web.js 2>/dev/null 2>&1 &
