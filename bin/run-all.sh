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
########################################################################
#	21.11.2013
#	Update by Todor Ivanov, Big Data Lab
#	Update by Raik Niemann, Big Data Lab
#	http://www.bigdata.uni-frankfurt.de
#
#	Add functionality to repeat tests and clear HDFS files after
# 	each performed test run.
########################################################################


DIR=`dirname "$0"`
DIR=`cd "${DIR}/.."; pwd`

. $DIR/bin/hibench-config.sh

if [ -f $HIBENCH_REPORT ]; then
    rm $HIBENCH_REPORT
fi

# loop through the repetition parameter
RepetitionFactor=3
for (( i = 1; i <= $RepetitionFactor; i++ ))
do 

	# perform the actual tests
	for benchmark in `cat $DIR/conf/benchmarks.lst`;
	do

	if [[ $benchmark == \#* ]]; then
			continue
		fi

		if [ "$benchmark" = "dfsioe" ] ; then
			# dfsioe specific
			$DIR/dfsioe/bin/prepare-read.sh
			$DIR/dfsioe/bin/run-read.sh
			$DIR/dfsioe/bin/run-write.sh

		elif [ "$benchmark" = "hivebench" ]; then
			# hivebench specific
			$DIR/hivebench/bin/prepare.sh
			$DIR/hivebench/bin/run-aggregation.sh
			$DIR/hivebench/bin/run-join.sh

		else
			if [ -e $DIR/${benchmark}/bin/prepare.sh ]; then
				$DIR/${benchmark}/bin/prepare.sh
			fi
			$DIR/${benchmark}/bin/run.sh
		fi

		#save the test results
		time="$(date +'%d-%m-%Y')"
		# create new directory for the results
		mkdir $DIR/run_${i}_${time}
		#cd $DIR/run_${i}_${time}

		if [ "$benchmark" = "dfsioe" ] ; then
			# dfsioe specific
			# get testDFSIO write ouput and configuration
			# get testDFSIO read ouput and configuration
			mkdir $DIR/run_${i}_${time}/testDFSIOe_${i}
			#cd $DIR/run_${i}_${time}/testDFSIOe_${i}
			mv $DIR/dfsioe/throughput_read.csv $DIR/run_${i}_${time}/testDFSIOe_${i}/throughput_read.csv
			mv $DIR/dfsioe/throughput_write.csv $DIR/run_${i}_${time}/testDFSIOe_${i}/throughput_write.csv
			mv $DIR/dfsioe/result_read.txt $DIR/run_${i}_${time}/testDFSIOe_${i}/result_read.txt
			mv $DIR/dfsioe/result_write.txt $DIR/run_${i}_${time}/testDFSIOe_${i}/result_write.txt
		elif [ "$benchmark" = "wordcount" ];
		then
			# get wordcount ouput and configuration

			hadoop fs -get   /HiBench/Wordcount/Output-comp/_logs/history $DIR/run_${i}_${time}/wordcount_${i}
		elif [ "$benchmark" = "sort" ];
		then
			# get sort ouput and configuration
			hadoop fs -get  /HiBench/Sort/Output-comp/_logs/history $DIR/run_${i}_${time}/sort_${i}
		elif [ "$benchmark" = "terasort" ];
		then
			# get terasort ouput and configuration
			hadoop fs -get  /HiBench/Terasort/Output/_logs/history $DIR/run_${i}_${time}/terasort_${i}
		fi
		# copy hibench report to results
		mv $DIR/hibench.report $DIR/run_${i}_${time}/hibench_${i}.report
	done

	#clear the data from HDFS
	# remove all the folders
	hadoop fs -rm -r -skipTrash /HiBench/*
	hadoop fs -rm -r -skipTrash /benchmarks/*
	# clear trash if any
	hadoop fs -expunge
	# sleep time 5 min in seconds
	sleep 30
done
