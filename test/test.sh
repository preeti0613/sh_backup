#!/bin/bash
dbname=""
username="postgres"
PASS=postgres
#csvfile=function.txt


column=column.txt.txt
querypath=/Desktop/CSVs/column.sh
counter=0
while IFS= read -r line
do
echo $line
counter=$(($counter+1))
done < $column
targettable=$line
PGPASSWORD=$PASS psql -U $username -d $dbname<< EOF
INSERT INTO table_1542455817 (Result_Time, Granularity_Period, Object_Name, Reliability, 1526728273, 1526728272, 1526728275, 1526728274, 1526727544, 1526727545,1526726669, 1526726668)
) select (Result_Time, Granularity_Period, Object_Name, Reliability, 1526728273, 1526728272, 1526728275, 1526728274, 1526727544, 1526727545,1526726669, 1526726668) from pmresult_1542455817_60_201805272300_201805280000
Inner Join pmresult_1542455817_60_201805272200_201805272300 ON pmresult_1542455817_60_201805272300_201805280000.granularity=pmresult_1542455817_60_201805272200_201805272300.granularity;
EOF
#for file in /Desktop/CSVs/pmresult.sql
#do

#psql -U $username -d $dbname -a -f $file
#done
#Insert into table_name (column_names) select column_name from table1



#INSERT INTO other_table (name, age, sex, city, id, number, nationality)
#SELECT name, age, sex, city, p.id, number, n.nationality
#FROM table_1 p
#INNER JOIN table_2 a ON a.id = p.id
#INNER JOIN table_3 b ON b.id = p.id
#...
#INNER JOIN table_n x ON x.id = p.id


targettable=(table_1542455817)
fromtable=(pmresult_1542455817_60_201805271600_201805271700)
for table in $targettable
do
PGPASSWORD=postgres psql -U postgres -d huawei<< EOF

INSERT INTO $table (Result_Time, Granularity_Period, Object_Name, Reliability, "1542460356")
      SELECT Result_Time, Granularity_Period, Object_Name, Reliability, "1542460356"
             FROM ${fromtable[0]};
EOF
done





while IFS=',' read -r line; 
do
IFS=',' read -r -a array <<< "$line"
length="${#array[@]}"
targettable=$(echo ${array[0]} | sed -e "s/table_//g")
read -r -a fromtables <<< $(ls *.sql)
fromTablelength=${#fromtables[@]}
for fromfile in ${fromtables[@]}
do
if [[ $fromfile = *"$targettable"* ]]
then
fromtable=$fromfile
echo $fromtable
break
fi
done
done < "./Target_table.csv"

dbname=""
username="postgres"
PASS=postgres
while IFS=',' read -r line; 
do
IFS=',' read -r -a array <<< "$line"
length="${#array[@]}"
targettableoriginal=${array[0]}
targettable=$(echo ${array[0]} | sed -e "s/table_//g")
read -r -a fromtables <<< $(ls *.sql)
fromTablelength=${#fromtables[@]}

for fromfile in ${fromtables[@]}
do
if [[ $fromfile = *"$targettable"* ]]
then
fromtable=$fromfile
fromtable=$(echo $fromtable | sed -e "s/.sql//g")
sqlQuery=""
for ((i=1; i< $length; i++))
do
column=$(echo ${array[$i]} | sed 's/\"//g')
if [[ "$column" =~ [0-9] ]]
then
column=\""$column"\"
fi
if [ $i == 1 ]
then
sqlQuery+=" $column"
else
sqlQuery+=", $column"
fi
sqlQuery=$(echo $sqlQuery | sed 's/, ,//g' | sed 's/,,//g')

done 
query="INSERT INTO $targettableoriginal ($sqlQuery) SELECT $sqlQuery FROM  $fromtable;"
echo $query
PGPASSWORD=$PASS psql -U $username -d $dbname<< EOF
$query
EOF
break
fi
done
done < "./Target_table.csv"











