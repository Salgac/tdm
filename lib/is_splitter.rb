#!/usr/bin/env ruby

require("csv")

HEADERS = [
    'Datum', 
    'Cas', 	
    'Identifikator polozky', 	
    'Cislo vozidla', 	
    'Vodic', 	
    'Cislo sluzby', 	
    'Linka', 	
    'Smer', 	
    'Cislo jazdy', 	
    'Longitude', 	
    'Latitude', 	
    'GPS Signal', 	
    'Odchylka voci grafikonu', 	
    'Zast/stlp', 	
    'Zastavka', 	
    'Pocet ozn. listkov', 	
    'Pocet nastupeni', 	
    'Pocet vystupeni', 	
    'Stav dveri', 	
    'Poziadavka od cestujucich', 	
    'Revizia', 	
    'Blokovanie OCL', 	
    'Planovany odchod', 	
    'Cislo zastavky', 	
    'Typ spravy'
];
result = Array.new  

# no selected file edgecase
if ARGV.length == 0
    puts "No file in ARGV. Please specify a file path."
    return
end

# read input data
ARGV.each do |file|   
    puts "Reading file \"#{File.basename(file)}\"…" 

    CSV.foreach(file, :headers => true, :col_sep => ";", :header_converters => :symbol, :encoding => 'iso-8859-1:utf-8') do |row|    
        row[:cislo_vozidla] = row[:cislo_vozidla].chomp("B")
        result << row.to_h 
    end
end

#

tram_number = "";
csv = nil;

# write data into separate files
result.each do |row|
    number = row[:cislo_vozidla]

    if tram_number != number
        puts "Writing file \"#{number}.csv\"…"

        csv = CSV.open("data/is/#{number}.csv", "w+",  :write_headers=> true, :headers => HEADERS, :col_sep => ";", :encoding => 'iso-8859-1:utf-8')
        tram_number = number
    end
    
    csv << row.values
end
