module Importers
  module BookingBug
    autoload :Record, 'importers/booking_bug/record'
    autoload :Importer, 'importers/booking_bug/importer'
    autoload :Retriever, 'importers/booking_bug/retriever'
    autoload :Saver, 'importers/booking_bug/saver'
    autoload :SummarySaver, 'importers/booking_bug/summary_saver'
  end
end
