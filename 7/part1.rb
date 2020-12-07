require "set"

@rules = Hash[File.open("input").readlines.map { |l|
            bag_colour, rest = l.chomp.split(" bags contain ")
            contains = rest.split(',').map { |x|
                n, *colours, _ = x.split(' ')
                n == "no" ? [] : [colours.join(' ')] * Integer(n)
            }
            [bag_colour, contains.flatten]
         }]

def bag_children(type, coalesce=true)
    direct = coalesce ? Array(Set.new(@rules[type])) : @rules[type]
    return direct + direct.map { |c| bag_children(c, coalesce) }.flatten
end

def can_hold(outer, inner)
    bag_children(outer).include? inner
end

if __FILE__ == $0
    p @rules.keys.map { |bag| can_hold(bag, "shiny gold") }.reject { |x| x == false }.length
end
