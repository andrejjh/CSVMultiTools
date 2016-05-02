require "pp"
require "CSV"
# converts list data into matrix

def convert_data(inpath, outpath, index)

  matrix= Hash.new()

  list= CSV.read(inpath, :headers => true, :col_sep => ',')
  headers = Array.new(list.headers)
  headers.delete_at(list.headers.length()-1)
  headers.delete_at(index)
  list.each do |row|
    column=row.field(index)
    unless headers.include?(column)
      headers << column
    end
    fields =row.fields
    fields.delete_at(list.headers.length()-1)
    fields.delete_at(index)
    signature= fields.to_s
    unless matrix.include?(signature)
      matrix[signature]=fields
    end
    matrix[signature][headers.index(column)]=row.fields.last
  end

  # convert similar list rows into matrix rows
  CSV.open(outpath, "wb", :headers => true, :col_sep => ',') do |out|
    out << headers
    matrix.each_value do |row|
      trailers=Array.new(headers.length-row.length)
      out << row + trailers
    end
  end
end


unless ARGV.length() == 3
  pp "usage: list2matrix.rb inpath outpath index"
else
  convert_data(ARGV[0],ARGV[1],ARGV[2].to_i)
end
