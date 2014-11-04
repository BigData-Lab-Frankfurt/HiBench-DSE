#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -u 

# compress
COMPRESS=$COMPRESS_GLOBAL
COMPRESS_CODEC=$COMPRESS_CODEC_GLOBAL

# paths
INPUT_HDFS=${DATA_HDFS}/Wordcount/Input
OUTPUT_HDFS=${DATA_HDFS}/Wordcount/Output

if [ $COMPRESS -eq 1 ]; then
    INPUT_HDFS=${INPUT_HDFS}-comp
    OUTPUT_HDFS=${OUTPUT_HDFS}-comp
fi

# for preparation (per node) - 32G
#DATASIZE=32000000000 #Original benchmark value
#DATASIZE=250 #1KB total
#DATASIZE=250000000 #1GB total
#DATASIZE=1250000000 #5GB total
#DATASIZE=2500000000 #10GB total
#DATASIZE=5000000000 #20GB total
DATASIZE=32212254720 #30GB pro Node = 240GB
#DATASIZE=45634027520 # 340G
#DATASIZE=59055800320 # 440G

# for running (in total)
NUM_MAPS=12
NUM_REDS=4
