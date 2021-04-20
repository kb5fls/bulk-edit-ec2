#!/bin/sh

# Created By: Phil Salem
# Created Date: 04/20/2021
# Version: 1.0

# Purpose of script is to use AWS-tagger to bulk add tags based 
# on user input.
#
# Reference Link: https://github.com/washingtonpost/aws-tagger
#
#
#
#First user input is for tag name
#Second user input is value of EC2 instance tag

echo Enter tag key
read tag
echo Enter tag value
read value

echo -e '\n'
echo Please wait while generating CSV file

#echo Id,Region,$tag > instances.csv

# This FOR loop searches for EC2 instances by ID and outputs to CSV file

for region in `aws ec2 describe-regions --output text | cut -f4`
do

        aws ec2 describe-instances --region $region --filters "Name=tag:Name,Values=*salem*,*Salem*" --query 'Reservations[*].Instances[*].[InstanceId]' --output text >> output.csv

done


# This WHILE loop reads the output.csv file that was created above and uses that
# as input when the aws-tagger command is called and bulk edits EC2 instances
# and adds the tags that the user inputs at the execution of the script

cat output.csv | while read line || [[ -n $line ]];

do

      aws-tagger --resource $line --tag "$tag:$value" > /dev/null 2>&1

done