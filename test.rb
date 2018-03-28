require 'semlogr'
require 'semlogr/sinks/logentries'

Semlogr.logger = Semlogr.create_logger do |c|
  c.log_at :info

  c.write_to :logentries, 'c6062f98-f4be-4f81-b014-3a37b0ac8837'
end

Semlogr.info('Customer {customer_id} did something interesting', customer_id: 1234)
