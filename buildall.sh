#!/bin/bash
# munch (sm8250) 单机型构建：ReSukiSU 无 SuSFS / 无 Root
set -e

bash build.sh munch nosusfs
bash build.sh munch noksu
