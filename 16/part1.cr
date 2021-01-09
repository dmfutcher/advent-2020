class Validator
    @name: String
    @ranges: Array(Range(Int32, Int32))

    def initialize(descriptor : String)
        @name, validator_info = descriptor.split(": ")
        @ranges = validator_info.split(" or ").map(&.split('-')).map{ |bounds| bounds[0].to_i..bounds[1].to_i }
    end

    def is_valid?(v : Int32)
        return @ranges.any?(&.includes? v)
    end
end

def get_input()
    lines = File.new("input").gets_to_end.split '\n'

    validators = lines[..lines.index("").not_nil! - 1].map{ |l| Validator.new l }
    our_ticket = lines[lines.index("your ticket:").not_nil! + 1].split(',').map(&.to_i)
    nearby_tickets = lines[(lines.index("nearby tickets:").not_nil! + 1)..].map(&.split(',').map(&.to_i))
    
    return { validators, our_ticket, nearby_tickets }
end

validators, _, nearby_tickets = get_input()
invalid_vals = nearby_tickets.map { |ticket|
    ticket.select{ |field| validators.none?(&.is_valid? field) }
}.flatten

puts invalid_vals.sum
