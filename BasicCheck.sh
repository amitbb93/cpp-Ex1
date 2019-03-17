#!/bin/bash
path=$1
variable=$2
counter=0

makeCOMP=PASS

cd $path
make > /dev/null 2>&1
makeDone=$?

if [ $makeDone -gt 0 ]
	then
	echo "compilation memoryLeaks threadRace"
	echo "FAIL      FAIL     FAIL"
	echo 7
	exit 7

	else
		valgrind --tool=memcheck --leak-check=full --error-exitcode=3 -q ./$variable >  /dev/null 2>&1
		valgridgout=$?
		if [ $valgridgout -gt 0 ]
			then
			LEAK=FAIL
			counter=$(( $counter + 2 ))
			else
			LEAK=PASS
		fi

		valgrind --tool=helgrind --error-exitcode=3 -q ./$variable > /dev/null 2>&1
		helg=$?
		if [ $helg -gt 0 ]
			then
			THREAD=FAIL
			counter=$(( $counter + 1 ))
			else
			THREAD=PASS
		fi
fi
echo "compilation memoryLeaks threadRace"
echo "$makeCOMP      $LEAK     $THREAD"
echo $counter
exit $counter