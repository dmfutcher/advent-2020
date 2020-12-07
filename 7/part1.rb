require "set"

@rules = Hash[File.open("input").readlines.map { |l|
            bag_colour, rest = l.chomp.split(" bags contain ")
            contains = rest.split(',').map { |x|
                x == "no other bags." ? nil : [x.split(' ').slice(1,2).join(' ')] * Integer(x.split(' ')[0])}
            [bag_colour, contains.flatten]
         }]

def bag_children(type, coalesce=true)
    direct = (coalesce ? Set.new(@rules[type]) : @rules[type]).reject { |b| b == nil }
    return direct + direct.map { |c| bag_children(c, coalesce) }.flatten
end

def can_hold(outer, inner)
    children = bag_children(outer)
    return children.include? inner
end

if __FILE__ == $0
    p @rules.keys.map { |bag| can_hold(bag, "shiny gold") }.reject { |x| x == false }.length
end
