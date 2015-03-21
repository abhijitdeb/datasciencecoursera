Steps
======================

Here are the steps:

0. Load the sourcecode in run_analysis.R
0. Make sure data is unpacked under the current directory. After that point all the data would be avilable in "./UCI HAR Dataset" directory and subdirectories under it.
0. Run the run_analysis function
0. It will take about 6-7 seconds
0. The run_analysis.txt file will be created which will have the data as requested in the step 5 of the assignemnt.
0. Please refer to the CodeBook.md to understand how many columns are there in the resultset and what are their names.
0. I have taken all the fields in the original data which had "std" or "mean" in their names. And then I created the dataset that has the averages of all these fields for each participant and each of their activities. There are in total 82 fields, the first three of which are id (of the participant), activity_id and activity_label