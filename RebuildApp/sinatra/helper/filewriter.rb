def write_to_file(content)

  filename = 'myfile.out'

  file_exists = File.exist?(filename)

  if file_exists ? fileswitch = 'a' : fileswitch = 'w'
    open(filename, fileswitch) { |i|

      unless content.nil?
        content.each { |x|
          i << "#{x}\n"
        }
      end
    }
  end

end
