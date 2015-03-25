def writeToFile(content)

filename = 'myfile.out'
  
  fileExists = File.exist?(filename)
 
  if fileExists ? fileswitch = 'a' : fileswitch = 'w'
  	 open(filename, fileswitch){ |i|
  		 
  		if ( !content.nil? ) 
  		  	content.each{|x| 
             i << "#{x}\n" 
            }
  		end
     }
  end

end
