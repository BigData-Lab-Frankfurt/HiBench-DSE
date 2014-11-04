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


# compression
COMPRESS=$COMPRESS_GLOBAL
COMPRESS_CODEC=$COMPRESS_CODEC_GLOBAL

# paths
BAYES_INPUT="Input"
BAYES_OUTPUT="Output"
BAYES_BASE_HDFS=${DATA_HDFS}/Bayes

if [ $COMPRESS -eq 1 ]; then
    BAYES_INPUT=${BAYES_INPUT}-comp
    BAYES_OUTPUT=${BAYES_OUTPUT}-comp
fi

INPUT_HDFS=${BAYES_BASE_HDFS}/${BAYES_INPUT}
OUTPUT_HDFS=${BAYES_BASE_HDFS}/${BAYES_OUTPUT}

# for prepare
#PAGES=100000
#PAGES=100000
#PAGES=57611902 #240G
#PAGES=81616861 #340G
#PAGES=105.621.820 #440G
#PAGES=36007438 #150G
#PAGES=18003719 # 75G
#PAGES=9601983 # 40G
#PAGES=3600744 # 15G
PAGES=2400496 # 10G
#PAGES=1200248 # 5G

CLASSES=100
NUM_MAPS=4
NUM_REDS=1

# bench parameters
NGRAMS=2
