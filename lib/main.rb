#!/usr/bin/env ruby

require "csv"
require "time"

HEADS = [
  "Record",
  "Sign",
  "Distance",
  "Time",
  "Date",
  "Velocity",
  "Jazda",
  "Brzda",
  "MaxPrevBr",
  "NudzBr_1",
  "NudzBr_2",
  "ZBVodic",
  "ZBCest",
  "ZBRiadSys",
  "OdbrRRad",
  "MechBr_A",
  "MechBr_C1",
  "MechBr_C2",
  "MechBr_B",
  "KolBr_1",
  "KolBr_2",
  "Kab_A",
  "Kab_B",
  "Smer_A",
  "Smer_B",
  "Zvonec",
  "Bdelost",
  "L_Smer",
  "P_Smer",
  "VonkOsv",
  "ZelLinka",
  "ZatvDveri",
  "ZnamKVod",
  "HavarPoj",
  "NudzDoj",
  "BlokDveri",
  "Piesk",
  "Sklz_Smyk",
  "RucOdbr_A",
  "RucOdbr_C1",
  "RucOdbr_C2",
  "RucOdbr_B",
  "RiadSystOK",
  "Vyh_R",
  "Vyh_L",
  "Vyh_P",
  "NapTrolej",
  "Sila_A",
  "Sila_C2",
  "Sila_B",
  "Radic",
  "PocetCest",
  "TeplSal",
  "NapBat",
  "Last_stop"
]
HEADS_TO_DEL = [
  :report,
  :mark,
  :switch_off,
  :time_change,
  :driver
]
IS_HEADS = [
  "IS_Date",
  "IS_Time",
  "IS_Identifikator_polozky",
  "IS_Cislo_vozidla",
  "IS_Vodic",
  "IS_Cislo_sluzby",
  "IS_Linka",
  "IS_Smer",
  "IS_Cislo_jazdy",
  "IS_Longitude",
  "IS_Latitude",
  "IS_GPS_Signal",
  "IS_Odchylka_voci_grafikonu",
  "IS_Zast_stlp",
  "IS_Zastavka",
  "IS_Pocet_ozn._listkov",
  "IS_Pocet_nastupeni",
  "IS_Pocet_vystupeni",
  "IS_Stav_dveri",
  "IS_Poziadavka_od_cestujucich",
  "IS_Revizia",
  "IS_Blokovanie_OCL",
  "IS_Planovany_odchod",
  "IS_Cislo_zastavky",
  "IS_Typ_spravy"
]

# no selected file edgecase
if ARGV.length == 0
  puts "No file in ARGV. Please specify a file path."
  return
end

# load files and export data
ARGV.each do |file|
  # check extension
  if File.extname(file) != ".txt"
    puts "#{File.basename(file)} must be a \".tgf\" export file."
    next
  end

  # prepare file data
  file_name = file.delete_suffix(".tgf.txt")
  _, vehicle_num, date = file_name.split("_")

  # open file with IS data
  is_data = {}
  begin
    print "Parsing file \"#{vehicle_num}.csv\"…\r"
    CSV.foreach("data/is/#{vehicle_num}.csv", "r", col_sep: ";", headers: true, header_converters: :symbol, encoding: "iso-8859-1:utf-8") do |row|
      is_data["#{row[:datum]}-#{row[:cas]}"] = row.to_h
    end
  rescue
    puts "No IS file for vehicle #{vehicle_num} found. Terminating…"
    next
  end

  # open result file
  print "Parsing file \"#{File.basename(file)}\"…"
  CSV.open("#{file_name}.csv", "w", col_sep: ";", write_headers: true, headers: HEADS + IS_HEADS) do |csv|
    # read data file and reverse the data
    file_data = []
    CSV.foreach(file, col_sep: "\t", headers: true, header_converters: :symbol) do |row|
      if !row[:time].nil?
        file_data << row.to_h
      end
    end
    file_data.reverse!

    # match file data to is data
    last_is_row = nil
    file_data.each do |row|
      # extract data
      timestamp = row[:time]
      date = row[:date]

      if timestamp.nil? || date.nil?
        next
      end

      time = Time.parse(timestamp).strftime("%H:%M:%S")

      # select data in IS
      is_row = is_data["#{date}-#{time}"]
      if !is_row.nil?
        last_is_row = is_row
      end

      csv << row.to_h.except(*HEADS_TO_DEL).values + last_is_row.to_h.values
    end
  end
end

puts "\nFinished"
