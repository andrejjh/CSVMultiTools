require "pp"
require "CSV"
# converts matrix data into list

def convert_data(inpath, outpath, startAt)
  CSV.open(outpath, "wb", :headers => true, :col_sep => ',') do |out|
    matrix= CSV.read(inpath, :headers => true, :col_sep => ',')
    # create list headers from matrix headers
    headerrow= Array.new
    for idx in 0..startAt-1
      headerrow << matrix.headers()[idx]
    end
    headerrow << "column"
    headerrow << "value"
    out << headerrow
    # convert each matrix row into list rows
    matrix.each do |row|
        baserow= Array.new
        for idx in 0..startAt-1
          baserow << row.field(idx)
        end
        for idx in startAt..row.length()-1
          # do not generate list row when matrix field is empty
          if row.field(idx)!=nil
            outrow = Array.new(baserow)
            outrow << row.headers[idx]
            outrow << row.field(idx)
            out << outrow
          end
      end
    end
  end
end


unless ARGV.length() == 3
  pp "usage: matrix2list.rb inpath outpath startAt"
else
  convert_data(ARGV[0],ARGV[1],ARGV[2].to_i)
end
