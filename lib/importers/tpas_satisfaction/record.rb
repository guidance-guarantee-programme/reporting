require 'csv'

module Importers
  module TpasSatisfaction
    class Record
      VALID_SATISFACTION_VALUES = '0'..'4'

      def initialize(cells, duplicate_index)
        @cells = cells
        @duplicate_index = duplicate_index
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          satisfaction_raw: satisfaction_raw,
          satisfaction: satisfaction,
          location: location,
          delivery_partner: Partners::TPAS
        }
      end

      def uid
        @uid ||= begin
          md5 = Digest::MD5.new
          @cells.each { |value| md5 << value.to_s }
          md5 << @duplicate_index.to_s
          md5.hexdigest
        end
      end

      def given_at
        Time.zone.parse("#{date} #{period_start}")
      end

      def satisfaction_raw
        @cells[5]
      end

      def satisfaction
        satisfaction_raw.to_i
      end

      def location
        ''
      end

      def valid?
        question == 'PW Exit Poll Q1' && VALID_SATISFACTION_VALUES.cover?(satisfaction_raw)
      end

      def question
        @cells[0]
      end

      def date
        @cells[1]
      end

      def period_start
        @cells[2]
      end

      def self.build(io:)
        grouped_rows = CSV.parse(io.read, row_sep: "\r\r\n").group_by { |row| row.join(',') }
        grouped_rows.flat_map do |_, rows|
          rows.map.with_index { |row, i| new(row, i) }
        end
      end
    end
  end
end
