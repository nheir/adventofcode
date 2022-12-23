use std::collections::{HashMap, HashSet, VecDeque};

#[derive(Debug)]
enum Direction {
    North,
    South,
    West,
    East,
}

#[derive(Debug)]
pub struct World {
    rules: VecDeque<(u8, Direction)>,
    map: HashSet<(i32, i32)>,
}

impl World {
    fn neigh(&self, i: i32, j: i32) -> u8 {
        [
            (0, -1),
            (-1, -1),
            (-1, 0),
            (-1, 1),
            (0, 1),
            (1, 1),
            (1, 0),
            (1, -1),
        ]
        .iter()
        .enumerate()
        .map(|(id, (dx, dy))| {
            if self.map.contains(&(i + dx, j + dy)) {
                (1 << id) as u8
            } else {
                0
            }
        })
        .sum()
    }

    fn get_moves(&self) -> HashMap<(i32, i32), &Direction> {
        let mut hm = HashMap::new();
        for k in &self.map {
            let nh = self.neigh(k.0, k.1);
            if nh != 0 {
                for (n, d) in &self.rules {
                    if nh & n == 0 {
                        hm.insert(*k, d);
                        break;
                    }
                }
            }
        }
        hm
    }

    fn do_step(&mut self) -> bool {
        let moves = self.get_moves();
        let mut ret: HashMap<(i32, i32), Vec<(i32, i32)>> = HashMap::new();
        for ((i, j), d) in moves {
            let (x, y) = match d {
                Direction::North => (i, j - 1),
                Direction::South => (i, j + 1),
                Direction::West => (i - 1, j),
                Direction::East => (i + 1, j),
            };
            ret.entry((x, y)).or_insert(vec![]).push((i, j));
        }
        let mut moved = 0;
        for (k, v) in ret {
            if v.len() == 1 && v[0] != k{
                self.map.remove(&v[0]);
                self.map.insert(k);
                moved += 1;
            }
        }
        let first = self.rules.pop_front().unwrap();
        self.rules.push_back(first);
        moved != 0
    }

    fn score(&self) -> i32 {
        let size = self.map.len();
        let min = self
            .map
            .iter()
            .copied()
            .reduce(|(x, y), (i, j)| (x.min(i), y.min(j)))
            .unwrap();
        let max = self
            .map
            .iter()
            .copied()
            .reduce(|(x, y), (i, j)| (x.max(i), y.max(j)))
            .unwrap();
        (max.1 - min.1 + 1) * (max.0 - min.0 + 1) - (size as i32)
    }
}

pub fn input_generator(input: &str) -> World {
    let lines: Vec<_> = input
        .lines()
        .map(|l| l.chars().collect::<Vec<_>>())
        .collect();
    let w = lines[0].len();
    let h = lines.len();
    let mut ret = HashSet::new();
    for i in 0..w {
        for j in 0..h {
            if lines[j][i] == '#' {
                ret.insert((i as i32, j as i32));
            }
        }
    }
    let mut vq = VecDeque::new();
    vq.push_back((0b10000011, Direction::North));
    vq.push_back((0b00111000, Direction::South));
    vq.push_back((0b00001110, Direction::West));
    vq.push_back((0b11100000, Direction::East));
    World {
        map: ret,
        rules: vq,
    }
}

#[aoc(day23, part1)]
pub fn part1(input: &str) -> i32 {
    let mut world = input_generator(&input);
    for _ in 0..10 {
        world.do_step();
    }
    world.score()
}

#[aoc(day23, part2)]
pub fn part2(input: &str) -> i32 {
    let mut world = input_generator(&input);
    let mut count = 1;
    while world.do_step() {
        count += 1;
    }
    count
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = ".....
..##.
..#..
.....
..##.
.....";

    const EXAMPLE2: &str = "..............
..............
.......#......
.....###.#....
...#...#.#....
....#...##....
...#.###......
...##.#.##....
....#..#......
..............
..............
..............";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(EXAMPLE1), 25);
        assert_eq!(part1(EXAMPLE2), 110);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(EXAMPLE2), 20);
    }
}
