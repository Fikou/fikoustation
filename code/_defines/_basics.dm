#define NONE 0
#define INFINITY 1e31

#define SQRT_2 1.41421
#define PI 3.14159
#define NUM_E 2.71828

#define DECISECONDS * 1
#define SECONDS * 10
#define MINUTES * 600
#define HOURS * 36000

GLOBAL_LIST_INIT(cardinals, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(diagonals, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(verticals, list(UP, DOWN))
GLOBAL_LIST_INIT(compass, cardinals + diagonals)
GLOBAL_LIST_INIT(directions, compass + verticals)
