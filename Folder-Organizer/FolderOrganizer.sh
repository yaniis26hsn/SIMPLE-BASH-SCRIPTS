
#this script will regroup all the files into a new Folders with the name of their extension (if it hasn't it will moved to a folder named 'other')


# step 1 : filtring all the files from folders 
 ls > allContent 
   while IFS= read -r line ; do   # IFS is necessary to take the whole line (each line is a separtor )
        if [ -f "$line" ];then
         echo "$line" >> onlyFiles  # we will store only files now
        fi 
        done < allContent  

# step 2 : getting extensions 

rev onlyFiles > reversedFile #rev cmd will make the same file but reversed (each line will be reversed from the right to the left )
cut -d . -f 1 reversedFile > extensionOfEachFile  # we will get only the extensions , we could use pipes but for clarity i prefer to separe the operations
 
# step 3 : replacing empty extensions (deleted after step 2) by the word "other"
while IFS= read line;do
  if [ -z "$line" ]; then
  line="other"
  fi
  echo "$line" >> fixedExtensions
  done < extensionOfEachFile

# step 4 : since we can't read from two files in one time (by a simple way) we concatenate them to a new one and read from it as usual  
paste -d / onlyFiles fixedExtensions > FilesWithTheirExtensions # i choosed / as a separator cz you can't use it in the name of any file 
# however we could use another separator and we would extract it exactly as we did with the extensions (with rev) but this seems simpler

# step 4 : moving files to their specific folder 

while IFS= read -r line;do 
 fileName=$(echo "$line" | cut -d / -f 1) #since we can't deal with strings directly using commands we should make as files 
 extension=$(echo "$line" | cut -d / -f 2  )
 mv -- "$fileName" "$extension/$fileName" # -- if the file started with - it may cause an error cz will think it is an option 
 # the -- will make bash understand that all what was after is a fileName not an option 
done < FilesWithTheirExtensions

# final step : deleting those temprary files 
rm -f allContent FilesWithTheirExtensions extensionOfEachFile reversedFile fixedExtensions # we could use -i too


