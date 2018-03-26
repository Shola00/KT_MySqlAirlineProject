#!/bin/bash

myDataBase="Airline"
user="root"

#define directory containing CSV files
locationOfCsvDir="/$HOME/Desktop"
#go into directory
cd $locationOfCsvDir
#get a list of CSV files in directory
allCsvFiles=`ls -1 *.csv`

#loop through csv files
for csvFile in ${allCsvFiles[@]};
 do
   #remove ".csv" file extension
   csvFileNameLessExtension=`echo $csvFile | sed 's/\(.*\)\..*/\1/'`

   #generate table name
   tableName="${csvFileNameLessExtension}"

   #get column names from all CSV files
   nameOfColumns=`head -1 $locationOfCsvDir/$csvFile | tr ',' '\n' | sed 's/^"//' | sed 's/"$//' | sed 's/ /_/g'`

  #create multiple tables
#   /usr/local/mysql/bin/mysql -u $user $myDataBase << eof
#     CREATE TABLE IF NOT EXISTS \`$tableName\` (
#       id int(11) NOT NULL auto_increment,
#       PRIMARY KEY  (id)
#     ) ENGINE=MyISAM
# eof

  #loop through column names in csv files and insert to table
  for column in ${nameOfColumns[@]};
   do
       #ignore tab, return and new line
    column=${column//[$'\t\r\n']}
    #/usr/local/mysql/bin/mysql -u $user $myDataBase --execute="alter table \`$tableName\` add column \`$column\` varchar(30);"
echo $column | grep Ticket_Id
  done

 #insert multiple rows to table

  tableIds=""
  valueids=""

  count=0
  while IFS=, read -r col1 col2
  do

      col2=${col2//[$'\t\r\n']}

      if [ $count -eq 0 ]; then
        tableIds="${col1},${col2}"
      else
        valueids="${valueids},($count, '${col2//,/','}')"
      fi;

      ((count++))
  done < $tableName.csv

  valueids=$( echo $valueids | sed 's/,*//')

  #echo "INSERT INTO $tableName ( $tableIds ) value $valueids ;" | /usr/local/mysql/bin/mysql -u $user $myDataBase;

done

#update ticket date format
#echo "update ticket set Date_Of_Purchases = STR_To_DATE(Date_Of_Purchases, '%m/%d/%Y');" | /usr/local/mysql/bin/mysql -u $user $myDataBase;

#drop duplicate column
# /usr/local/mysql/bin/mysql -u $user $myDataBase --execute="
#         ALTER TABLE Airline DROP Airline_id;
#         ALTER TABLE Country DROP Country_id;
#         ALTER TABLE Passenger DROP Passenger_id;
#         ALTER TABLE Ticket DROP Ticket_id; "
