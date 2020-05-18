array=['a','b','c','d']

array.each do |el|
    puts el
end

array.each_with_index do |element,index|
    puts "#{index}: #{element}"
end