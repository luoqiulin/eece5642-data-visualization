import re
import csv
import urllib.request

def locateTableElement(data):      
    location = data[re.search(r'<td>', data).end() : re.search(r'</td>', data).start()]
    return location

# Copy the current file path of data.html in the filePath string.
def main():
    filePath = 'file:///Users/qrin/Code/Class/EECE5642/HW4/TheTDataCollection/data.html'
    response = urllib.request.urlopen(filePath)
    element = response.read().decode('GBK')
    cur = True
    fileOpen = csv.writer(open('stations.csv','w', newline = ''))
    for count in range(126 * 2):
        if cur == True:
            strf = locateTableElement(element)
            cur = False
        else:
            strf = locateTableElement(element)
            cur = True
            fileOpen.writerow([strf])   
        element = element[re.search(r'</td>', element).end():]
    
if __name__=="__main__":
    main()
