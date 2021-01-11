#include <iostream>
#include <fstream>
#include <unordered_set>
#include <algorithm>
#include <utility>
#include <vector>

const char CHAR_ACTIVE = '#';
const char CHAR_INACTIVE = '.';
const int BOOT_STEPS = 6;

template <std::size_t D>
class Point {
    public:
        std::vector<int> coordinates;

        Point(std::vector<int> coordinates);
        size_t dimensions() const;
        std::unordered_set<Point<D>> neighbours();
        std::unordered_set<Point<D>> neighbours3();
        std::unordered_set<Point<D>> neighbours4();

        bool operator==(const Point<D>& other) const
        {
            for (auto i = 0; i < this->dimensions(); i++)
                if (this->coordinates[i] != other.coordinates[i])
                    return false;

            return true;
        }

        friend std::ostream& operator<<(std::ostream &strm, const Point<D> &p) 
        {
            strm << "Point(";

            for (auto c : p.coordinates) 
                strm << c << " ";

            strm << ")";
            return strm;
        }
};

template <std::size_t D>
Point<D>::Point(std::vector<int> coordinates)
{
    if (D != coordinates.size())
        throw std::invalid_argument("Invalid coordinates vector length");

    this->coordinates = coordinates;
}

template <std::size_t D>
inline size_t Point<D>::dimensions() const
{
    return D;
}

template <std::size_t D>
std::unordered_set<Point<D>> Point<D>::neighbours()
{
    // So this is obviously dreadful ... but I've spent more than enough time on this puzzle already ...
    if (D == 3)
        return this->neighbours3();

    if (D == 4)
        return this->neighbours4();

    return std::unordered_set<Point<D>>();
}

template <std::size_t D>
std::unordered_set<Point<D>> Point<D>::neighbours3()
{
    int possibilities[] = {1, 0, -1};
    std::unordered_set<Point<D>> neighbours;

    for (auto x : possibilities) 
        for (auto y : possibilities)
            for (auto z : possibilities)
            {
                if (x == 0 && y == 0 && z == 0) 
                    continue;

                neighbours.insert(Point<D>({this->coordinates[0] + x, this->coordinates[1] + y, this->coordinates[2] + z}));
            }

    return neighbours;
}

template <std::size_t D>
std::unordered_set<Point<D>> Point<D>::neighbours4()
{
    int possibilities[] = {1, 0, -1};
    std::unordered_set<Point<D>> neighbours;

    for (auto x : possibilities) 
        for (auto y : possibilities)
            for (auto z : possibilities)
                for (auto w : possibilities)
                {
                    if (x == 0 && y == 0 && z == 0) 
                        continue;

                    neighbours.insert(Point<D>({this->coordinates[0] + x, this->coordinates[1] + y, this->coordinates[2] + z, this->coordinates[3] + w}));
                }

    return neighbours;
}

// Defines the hash function for Point so it can be used in std::unordered_set
namespace std
{
    template <std::size_t D>
    struct hash<Point<D>>
    {
        size_t operator()(const Point<D>& p) const
        {
            size_t h = hash<int>()(p.dimensions());

            for (auto c : p.coordinates)
                h = (h + (324723947 + c)) ^93485734985;

            return h;
        }
    };
}

template <std::size_t D>
class PocketSpace {
    public:
        PocketSpace(std::unordered_set<Point<D>>);
        std::unordered_set<Point<D>> simulate();

    private:
        std::unordered_set<Point<D>> active_points;
        std::vector<std::vector<int>> bounds;
        void step();
        bool is_active(Point<D> p);
};

template <std::size_t D>
PocketSpace<D>::PocketSpace(std::unordered_set<Point<D>> initial_points)
{
    this->active_points = initial_points;
}

template <std::size_t D>
std::unordered_set<Point<D>> PocketSpace<D>::simulate()
{
    for (auto i = 0; i < BOOT_STEPS; i++)
        step();

    return this->active_points;
}

template <std::size_t D>
void PocketSpace<D>::step()
{
    std::unordered_set<Point<D>> queue;
    std::unordered_set<Point<D>> active_next;

    for (auto p : this->active_points)
    {
        queue.insert(p);
        for (auto n : p.neighbours())
            queue.insert(n);
    }

    for (auto it = queue.begin(); it != queue.end(); ++it)
    {
        Point<D> point = *it;
        bool point_is_active = this->is_active(*it);
        int active_neighbours = 0;

        for (auto n : point.neighbours())
            if (this->is_active(n))
                active_neighbours++;

        if (point_is_active)
        {
            if (active_neighbours == 2 || active_neighbours == 3)
                active_next.insert(*it);
        }
        else
        {
            if (active_neighbours == 3)
                active_next.insert(*it);
        }
        
    }

    this->active_points = active_next;
}

template <std::size_t D>
bool PocketSpace<D>::is_active(Point<D> p)
{
    return this->active_points.count(p) > 0;
}

std::unordered_set<Point<3>> parse_input() 
{
    std::ifstream file("input");
    auto x = 0, y = 0, z = 0;
    std::unordered_set<Point<3>> points;

    for (std::string line; std::getline(file, line); ) 
    {
        x = 0;
        for (auto c : line) 
        {
            if (c == CHAR_ACTIVE) 
                points.insert(Point<3>({ x, y, z }));

            x++;
        }
        y++;
    }

    return points;
}

int main() 
{
    auto input = parse_input();
    auto space3D = new PocketSpace<3>(input);
    auto active_at_end = space3D->simulate();

    std::cout << active_at_end.size() << " cubes active" << std::endl;
}