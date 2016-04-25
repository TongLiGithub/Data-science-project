# Coursera-Project

1. Download and unzip data
2. Read in the three files of test data, name the columns
3. Combine all test data
4. Read in the three files of train data, name the columns
5. Combine all train data
6. Combine test and train data to create 'alldata'

7. Extract the measurements on the mean and standard deviation to create 'extracted' data
8. Create the required independent data set
  a. Subset the 'extracted' data by activity
  b. For each activity, use a for loop to calculate column means
  c. Combine the 6 sets and convert the whole set to 'new' dataframe 
  d. Create a vector of subject and a vector of activity (will be used as columns when combined with 'new')
  e. Combine subject, activity and new, write to table.
