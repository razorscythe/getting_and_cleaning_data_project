# getting_and_cleaning_data_project
author- Aman Tiwari

In order to achieve the objectives given in the question following steps were implemented:-
1. First I have to load the data from the link provided so I used download.file command and as the file was zipped I have to unzip it using unzip() function.
2. Then I have to load the activity labels and features data from the respective files so I did it using the fread() function and assigned coloumn names so that
   furhter processing can be done.
3. Then I used grep() function to exctract the mean and standard deviation values from the features list and used the gsub() function to correct it to my needed
   format.
4. After that I procedeed to load the train datasets contained in the train folder. I loaded the X_train, y_train and subject_train data separately and then 
   combined them into one table using the cbind() function.
5. After that I proceeded with the test datasets contained in the test folder. I lloaded the X_test, y_test and subject test datasets separately and the combined 
   them using cbind function. Also as I knew I have to merge the datasets after this I kept the names of coloumn names same so it will be easy to do so.
6. After this I merged both the train and test datasets into one table using rbind() function and named it mergeddata.
7. Then using the factor() function I creadted levels using the activity class labels and labelled them using activity name so that the activity names can be 
   displayed explicitly.
8. Then I used the melt and dcast funtion to gain the average value of each variable for each activity and each subject.
9. Finally I used the write.table() funtion to create the tidyData file. 
