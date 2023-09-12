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
    fileOpen = csv.writer(open('connections.csv','w', newline=''))
    for i in range((126 * 2 + 121 * 5)):
        if i >= (126 * 2):
            if cur == True: 
                cur = False
            else:
                if cur == False:                     
                    outset = locateTableElement(element)
                    cur = 'ELE_1_Done'
                else:
                    if cur == 'ELE_1_Done':                 
                        destination = locateTableElement(element)
                        cur = 'ELE_2_Done'
                    else:
                        if cur == 'ELE_2_Done':             
                            color = locateTableElement(element)
                            cur = 'ELE_3_Done'
                        else:
                            if cur == 'ELE_3_Done':         
                                time = locateTableElement(element)
                                cur = True
                                fileOpen.writerow([outset, destination, color, time]);      
        element = element[re.search(r'</td>', element).end():]
    
if __name__=="__main__":
    main()
