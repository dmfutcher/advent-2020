require "./part1"

def ticket_valid?(ticket, validators)
    ticket.all?{ |field| validators.any?(&.is_valid? field) }
end

def possible_column_validators(nearby_tickets, validators)
    possible_validators = {} of Int32 => Set(Validator)
    nearby_tickets.each do |ticket|
            ticket.each.with_index do |val, col|
                field_validators = validators.select(&.is_valid? val).to_set
                possible_validators[col] = field_validators & possible_validators.fetch(col, field_validators)
        end
    end

    possible_validators
end

def determine_column_labels(col_validators)
    labelled_columns = {} of Int32 => String
    col_count = col_validators.keys.size

    while labelled_columns.keys.size < col_count
        assigned_fields = [] of Validator

        # If column has only one possible validator, assign that label to column
        col_validators.each do |(col, validators)|
            if validators.size == 1
                validator = validators.to_a[0]
                labelled_columns[col] = validator.@name
                col_validators.delete col
                assigned_fields.push validator
            end
        end

        # Remove any assigned fields from options for un-labelled fields
        col_validators.each do |(_, validators)|
            assigned_fields.each do |v|
                validators.delete(v)
            end
        end
    end

    labelled_columns
end

def label_ticket(ticket, col_labels)
    col_labels.each.map { |(col, name)| {name, ticket[col]} }.to_h
end

validators, our_ticket, nearby_tickets = get_input()
valid_nearby = nearby_tickets.select{ |t| ticket_valid?(t, validators) }

col_validators = possible_column_validators(valid_nearby, validators)
col_labels = determine_column_labels(col_validators)
labelled = label_ticket(our_ticket, col_labels)

puts labelled.keys.select(&.includes? "departure").map{ |k| labelled[k].to_u64 }.product
