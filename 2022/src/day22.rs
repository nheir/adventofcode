use std::collections::HashMap;

#[derive(Debug, Clone, Copy)]
enum Step {
    Left,
    Right,
    Forward(usize),
}

#[derive(Debug, Clone, Copy, PartialEq)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl Direction {
    fn left(&self) -> Self {
        match self {
            Direction::Up => Direction::Left,
            Direction::Down => Direction::Right,
            Direction::Left => Direction::Down,
            Direction::Right => Direction::Up,
        }
    }
    fn right(&self) -> Self {
        match self {
            Direction::Up => Direction::Right,
            Direction::Down => Direction::Left,
            Direction::Left => Direction::Up,
            Direction::Right => Direction::Down,
        }
    }
}

type Coord = (usize, usize);

#[derive(Debug, Clone, Copy)]
struct State {
    face: Coord,
    coord: Coord,
    direction: Direction,
}

#[derive(Debug, Clone)]
struct Face {
    up: (Coord, Direction),
    down: (Coord, Direction),
    left: (Coord, Direction),
    right: (Coord, Direction),
}

impl Face {
    fn new(c: Coord) -> Self {
        Face {
            up: (c, Direction::Up),
            down: (c, Direction::Up),
            left: (c, Direction::Up),
            right: (c, Direction::Up),
        }
    }
    fn next(&self, d: &Direction) -> (Coord, Direction) {
        match d {
            Direction::Up => self.up,
            Direction::Down => self.down,
            Direction::Left => self.left,
            Direction::Right => self.right,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Cube {
    faces: HashMap<Coord, Face>,
    data: Vec<Vec<char>>,
    state: State,
    size: usize,
}

impl Cube {
    fn may_foward(&self) -> bool {
        match self.state.direction {
            Direction::Up => self.state.coord.1 > 0,
            Direction::Left => self.state.coord.0 > 0,
            Direction::Right => self.state.coord.0 < self.size - 1,
            Direction::Down => self.state.coord.1 < self.size - 1,
        }
    }
    fn will_forward(&self) -> (Coord, Coord, Direction) {
        let (x, y) = self.state.coord;
        let cur_face = self.faces.get(&self.state.face).unwrap();
        if self.may_foward() {
            let (x, y) = match self.state.direction {
                Direction::Up => (x, y - 1),
                Direction::Left => (x - 1, y),
                Direction::Right => (x + 1, y),
                Direction::Down => (x, y + 1),
            };
            (self.state.face, (x, y), self.state.direction.clone())
        } else {
            let size = self.size;
            let (next_face, d) = cur_face.next(&self.state.direction);
            let v = match self.state.direction {
                Direction::Right => size - 1 - y,
                Direction::Down => x,
                Direction::Left => y,
                Direction::Up => size - 1 - x,
            };
            let coord = match d {
                Direction::Up => (size - 1 - v, size - 1),
                Direction::Down => (v, 0),
                Direction::Left => (size - 1, v),
                Direction::Right => (0, size - 1 - v),
            };
            (next_face, coord, d)
        }
    }

    fn foward(&mut self) {
        let (face, (x, y), d) = self.will_forward();
        if self.data[face.1 * self.size + y][face.0 * self.size + x] == '.' {
            self.state = State {
                face,
                coord: (x, y),
                direction: d,
            }
        }
    }

    fn left(&mut self) {
        self.state.direction = self.state.direction.left();
    }

    fn right(&mut self) {
        self.state.direction = self.state.direction.right()
    }

    fn init_neigh(&mut self) {
        for i in 0..4 {
            for j in 0..4 {
                if self.faces.contains_key(&(i, j)) {
                    if self.faces.contains_key(&(i + 1, j)) {
                        self.faces.get_mut(&(i, j)).unwrap().right = ((i + 1, j), Direction::Right);
                        self.faces.get_mut(&(i + 1, j)).unwrap().left = ((i, j), Direction::Left);
                    }
                    if self.faces.contains_key(&(i, j + 1)) {
                        self.faces.get_mut(&(i, j)).unwrap().down = ((i, j + 1), Direction::Down);
                        self.faces.get_mut(&(i, j + 1)).unwrap().up = ((i, j), Direction::Up);
                    }
                }
            }
        }
    }

    fn complete_torus(&mut self) {
        for i in 0..4 {
            if let Some(j_min) = (0..4).filter(|&j| self.faces.contains_key(&(i, j))).min() {
                let j_max = (0..4)
                    .filter(|&j| self.faces.contains_key(&(i, j)))
                    .max()
                    .unwrap();
                self.faces.get_mut(&(i, j_min)).unwrap().up = ((i, j_max), Direction::Up);
                self.faces.get_mut(&(i, j_max)).unwrap().down = ((i, j_min), Direction::Down);
            }
            if let Some(j_min) = (0..4).filter(|&j| self.faces.contains_key(&(j, i))).min() {
                let j_max = (0..4)
                    .filter(|&j| self.faces.contains_key(&(j, i)))
                    .max()
                    .unwrap();
                self.faces.get_mut(&(j_min, i)).unwrap().left = ((j_max, i), Direction::Left);
                self.faces.get_mut(&(j_max, i)).unwrap().right = ((j_min, i), Direction::Right);
            }
        }
    }

    /* ad hoc folding... */
    fn complete_cube(&mut self) {
        let mapping = if self.size == 4 {
            /*
              1
            234
              56
            */
            vec![
                ((2, 0), Direction::Left, (1, 1), Direction::Down),
                ((2, 0), Direction::Up, (0, 1), Direction::Down),
                ((2, 0), Direction::Right, (3, 2), Direction::Left),
                ((0, 1), Direction::Left, (3, 2), Direction::Up),
                ((0, 1), Direction::Down, (2, 2), Direction::Up),
                ((1, 1), Direction::Down, (2, 2), Direction::Right),
                ((2, 1), Direction::Right, (3, 2), Direction::Down),
            ]
        } else {
            use self::Direction::*;
            let fs = [(1, 0), (2, 0), (1, 1), (1, 2), (0, 2), (0, 3)];
            /*
             01
             2
            43
            5
            */
            vec![
                (fs[0], Up, fs[5], Right),
                (fs[0], Left, fs[4], Right),
                (fs[1], Up, fs[5], Up),
                (fs[1], Right, fs[3], Left),
                (fs[1], Down, fs[2], Left),
                (fs[2], Left, fs[4], Down),
                (fs[3], Down, fs[5], Left),
            ]
        };
        for (f1, d1, f2, d2) in mapping {
            let face = self.faces.get_mut(&f2).unwrap();
            match &d2 {
                Direction::Down => face.up = (f1, d1.right().right()),
                Direction::Up => face.down = (f1, d1.right().right()),
                Direction::Right => face.left = (f1, d1.right().right()),
                Direction::Left => face.right = (f1, d1.right().right()),
            };
            let face = self.faces.get_mut(&f1).unwrap();
            match &d1 {
                Direction::Up => face.up = (f2, d2),
                Direction::Down => face.down = (f2, d2),
                Direction::Left => face.left = (f2, d2),
                Direction::Right => face.right = (f2, d2),
            };
        }
    }

    fn score(&self) -> usize {
        let (i, j) = self.state.face;
        let (x, y) = self.state.coord;
        (j * self.size + y + 1) * 1000
            + (i * self.size + x + 1) * 4
            + (match self.state.direction {
                Direction::Right => 0,
                Direction::Down => 1,
                Direction::Left => 2,
                Direction::Up => 3,
            })
    }
}

#[derive(Debug)]
pub struct Input {
    cube: Cube,
    path: Vec<Step>,
}

#[aoc_generator(day22)]
pub fn input_generator(input: &str) -> Input {
    let (map, path) = input.split_once("\n\n").unwrap();
    let size = map.chars().filter(|&c| c == '.' || c == '#').count();
    let side = (1..=50).find(|i| i * i == size / 6).unwrap();
    let lines: Vec<_> = map.lines().map(|l| l.chars().collect::<Vec<_>>()).collect();
    let h = lines.len() / side;
    let mut cube = Cube {
        faces: HashMap::new(),
        data: lines,
        size: side,
        state: State {
            coord: (1, 1),
            face: (0, 0),
            direction: Direction::Right,
        },
    };
    for j in 0..h {
        let w = cube.data[j * side].len() / side;
        for i in 0..w {
            if cube.data[j * side][i * side] != ' ' {
                if cube.state.coord == (1, 1) {
                    cube.state.coord = (0, 0);
                    cube.state.face = (i, j);
                }
                cube.faces.insert((i, j), Face::new((i, j)));
            }
        }
    }
    let mut r = vec![];
    for ss in path.split("L").map(|l| {
        let mut r = vec![];
        for s in l.split("R").map(|v| Step::Forward(v.parse().unwrap())) {
            r.push(s);
            r.push(Step::Right)
        }
        r.pop();
        r
    }) {
        for s in ss {
            r.push(s);
        }
        r.push(Step::Left);
    }
    r.pop();
    Input {
        cube: cube,
        path: r,
    }
}

fn run_path(cube: &mut Cube, path: &[Step]) -> usize {
    for step in path.iter() {
        match step {
            Step::Left => cube.left(),
            Step::Right => cube.right(),
            Step::Forward(v) => {
                for _ in 0..*v {
                    cube.foward()
                }
            }
        }
    }
    cube.score()
}

#[aoc(day22, part1)]
pub fn part1(input: &Input) -> usize {
    let mut cube = input.cube.clone();
    cube.init_neigh();
    cube.complete_torus();
    run_path(&mut cube, &input.path)
}

#[aoc(day22, part2)]
pub fn part2(input: &Input) -> usize {
    let mut cube = input.cube.clone();
    cube.init_neigh();
    cube.complete_cube();
    run_path(&mut cube, &input.path)
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 6032);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 5031);
    }
}
