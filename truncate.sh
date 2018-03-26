#!/bin/bash
locationOfCsvDir="/$HOME/Desktop"
cd $locationOfCsvDir
allCsvFiles=`ls -1 *.csv`
for csvFile in ${allCsvFiles[@]};
do
  # remove file extension
  csvFileLessExtension=`echo $csvFile | sed 's/\(.*\)\..*/\1/'`

   # remove ".csv" extension to generate table
    tableName="${csvFileLessExtension}"
        echo "TRUNCATE TABLE $tableName;" | /usr/local/mysql/bin/mysql -u root Airline_project;
done
