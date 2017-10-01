require_relative 'yaml_buddy'
# Module that can be included (mixin) to take and output TSV data
module TsvBuddy
  include YamlBuddy

  TAB = "\t".freeze
  NEWLINE = "\n".freeze

  def create_record(headers, line)
    values = line.split(TAB).map!(&:chomp)
    headers = headers.split(TAB).map!(&:chomp)

    new_record = {}
    headers.size.times { |index| new_record[headers[index]] = values[index] }
    new_record
  end

  def deserialize_to_lines(lines, data)
    data.each do |set|
      set.each_value { |val| lines << val + TAB }
      lines[lines.length - 1].strip!
      lines << NEWLINE
    end
  end

  def get_headers(data)
    column = ''
    header_keys = data[0].keys

    header_keys.each { |header| column << header + TAB }
    column.strip!
    column
  end

  def data_to_tsv(data)
    lines = []

    lines << get_headers(data) << NEWLINE
    deserialize_to_lines(lines, data)

    lines
  rescue StandardError
    raise 'Error transforming data'
  end

  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)
    @data = []
    header = ''
    tsv.each_line.with_index do |line, index|
      header = line if index.zero?
      @data << create_record(header, line) unless index.zero?
    end
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    data_to_tsv(@data).join('')
  end
end
