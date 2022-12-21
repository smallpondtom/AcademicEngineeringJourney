### QUESTION #3 ###
# AUTHOR     : TOMOKI KOIKE
# DATE       : NOV. 17 2019
# DESCRIPTION: THIS PROGRAM IS DESIGNED TO COMPARE THE UNIQUE WORDS IN TWO TEXT FILES AND FIND THE
#              WORDS UNIQUE TO EACH FILE OR COMMON TO BOTH FILES.
###################

# The main function
from typing import Pattern


def main():
    unqdict1, list1 = scanFile('xian_1.txt')
    unqdict2, list2 = scanFile('xian_2.txt')
    writeUnq(unqdict1, 'word_frequency_1.txt')
    writeUnq(unqdict2, 'word_frequency_2.txt')
    commonWords(list1, list2, 'common_words.txt')
    unq2either(list1, list2, 'eitherbutnotboth.txt')

# Importing modules
import re

# Functions
# Function that read through the file
def scanFile(file):
    afile = open(file, 'r', encoding='utf-8')  # Open the file in read mode
    lesen = afile.read()  # Read the entire file
    lesen = lesen.lower().split()
    lesen = filterRegEx(lesen)
    tempList = lesen
    unqdict = scanIt(lesen)  # Creating a dictionary with all the unique words and count of them
    afile.close()  # Close the file
    return unqdict, tempList

# Function to filter with regEx
def filterRegEx(stringList):
    base1 = re.compile(r'.+(n\’t)+$')
    base2 = re.compile(r'[a-z](\’s)$')
    base3: Pattern[str] = re.compile(r'([a-z]\.[a-z]\.)')
    base4 = re.compile(r'.+\W$')
    base5 = re.compile(r'^\W+.')
    base6 = re.compile(r'^\w+\W+\w+$')
    base7 = re.compile(r'\W')
    for i, v in enumerate(stringList):
        if base1.search(v):
            stringList[i] = re.sub(base1, '', v)
        elif base2.search(v):
            stringList[i] = re.sub(base2, '', v)
        elif base3.search(v):
            stringList[i] = v.upper()
        elif base4.search(v):
            temp = re.findall(base4, v)[0]
            stringList[i] = v.rstrip(temp[-1])
        elif base5.search(v):
            temp = re.findall(base5, v)[0]
            stringList[i] = v.lstrip(temp[0])
        elif base6.search(v):
            pass
        elif base7.search(v):
            stringList[i] = re.sub(base7, '', v)
            if not stringList[i]:
                stringList.pop(i)
    return stringList

# Function to scan through the read line of the file and find unique words
def scanIt(strList):
    # Call the rmDuplicate function to get a dict of unique words being the keys and count as values
    unqdict = rmDuplicate(strList)
    # For loop to count the number of each unique word in the line list and assign them to the value
    # of the dictionary
    for x in strList:
        unqdict[x] += 1
    return unqdict

# Function to remove duplicate values or strings from a list and return as a dictionary
def rmDuplicate(alist):
    adict = dict.fromkeys(alist)  # Form  dictionary from the list
    # For loop to change the NoneType to 0
    for x in adict:
        if adict[x] == None:
            adict[x] = 0
    return adict

# Function to remove duplicate values of strings from a list
def rmDuplicateList(alist):
    alist = [x for x in alist if x != 's']
    return list(dict.fromkeys(alist))

# Function to create a new file with all the common words in both files
def commonWords(list1, list2, filename):
    # Convert both list to tuple
    set1 = set(rmDuplicateList(list1))
    set2 = set(rmDuplicateList(list2))
    # Find the common words
    commonset = set1 & set2
    commonlist = list(commonset)
    newfile = open(filename, 'w')  # Opening file
    for n in commonlist:
        newfile.write('{0}\n'.format(n))
    newfile.close()
    return

# Function to create a new file with the words unique to either of the files
def unq2either(list1, list2, filename):
    # Convert both list to tuple
    set1 = set(rmDuplicateList(list1))
    set2 = set(rmDuplicateList(list2))
    # Find the common words
    unq2Oneset = set1 ^ set2
    unq2Onelist = list(unq2Oneset)
    newfile = open(filename, 'w')  # Opening file
    for n in unq2Onelist:
        newfile.write('{0}\n'.format(n))
    newfile.close()
    return

# Writing the unique words in the file to a new text file as results
def writeUnq(adict, name):
    newfile = open(name, 'w')  # Opening a new file write mode
    # Looping through to write
    for k, v in adict.items():
        newfile.write('{0}: {1}\r'.format(k, v))
    newfile.close()  # Close written file
    return

# Executing the main function
if __name__ == '__main__':
    main()

