@rules = Hash[File.open("input").readlines.map { |l|
            bag_colour, rest = l.split(" bags contain ")
            contains = rest.split(',').map { 
				|x| x == "no other bags." ? nil : x.split(' ').slice(1,2).join(' ') }
            [bag_colour, contains]
         }]

def bag_children(type)
    direct = (@rules[type] or []).reject { |b| b == nil }
    return direct + (direct.map { |c| bag_children(c) }).flatten
end

def can_hold(outer, inner)
    bag_children(outer).include? inner
end

p @rules.keys.map { |bag| can_hold(bag, "shiny gold") }.reject { |x| x == false }.length
