import socket	

def encrypt(message): 
    # Morse code directory (numbers and dot only, for the IP address ecription)
    MORSE_CODE_DICT = { '1':'.----', '2':'..---', '3':'...--', 
                        '4':'....-', '5':'.....', '6':'-....', 
                        '7':'--...', '8':'---..', '9':'----.', 
                        '0':'-----', '.':'.-.-.-'}
    cipher = '' 
    for letter in message: 
        if letter != ' ': 
  
            # Looks up the dictionary and adds the 
            # correspponding morse code 
            # along with a space to separate 
            # morse codes for different characters 
            cipher += MORSE_CODE_DICT[letter] + ' '
        else: 
            # 1 space indicates different characters 
            # and 2 indicates different words 
            cipher += ' '
  
    return cipher 

# Setting up the connection
s = socket.socket()	 
print ("Socket successfully created") 

port = 12346				
 
s.bind(('', port))	 
print ("socket binded to %s" %(port)) 
 
s.listen(5) 
print ("socket is listening")		 




# a forever loop until we interrupt it / error occurs 
while True: 

    # Establish connection with client. 
    c, addr = s.accept()	 
    print ('Got connection from', addr ) 

    # send a thank you message to the client.
    morseIP = encrypt(addr[0])
    # morseIP = encrypt()
    c.sendall(b'The morse code for your IP is: \n' + morseIP.encode('ascii'))
    c.send(b'\nThank you for connecting\n') 

    # Close the connection with the client 
    c.close() 
