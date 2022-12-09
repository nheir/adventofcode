use std::collections::HashSet;
use std::num::ParseIntError;
use std::str::FromStr;

pub enum Move {
    Up(i32),
    Down(i32),
    Left(i32),
    Right(i32),
}

impl FromStr for Move {
    type Err = ParseIntError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (a, b) = s.split_once(" ").unwrap();
        let v = b.parse().unwrap();
        match a {
            "U" => Ok(Move::Up(v)),
            "D" => Ok(Move::Down(v)),
            "L" => Ok(Move::Left(v)),
            "R" => Ok(Move::Right(v)),
            _ => unreachable!(),
        }
    }
}

type XY = (i32, i32);
struct State {
    rope: [XY; 10],
}

impl State {
    fn move_all_tail(&mut self, size: usize) -> &Self {
        for i in 0..size - 1 {
            let (x, y) = (
                self.rope[i].0 - self.rope[i + 1].0,
                self.rope[i].1 - self.rope[i + 1].1,
            );
            if x > 1 || x < -1 || y > 1 || y < -1 {
                self.rope[i + 1].0 += x.signum();
                self.rope[i + 1].1 += y.signum();
            }
        }
        self
    }
}

impl Move {
    fn apply(&self, s: &mut State, size: usize) -> Vec<XY> {
        let (&d, x, y) = match &self {
            Move::Up(d) => (d, 0, 1),
            Move::Down(d) => (d, 0, -1),
            Move::Left(d) => (d, -1, 0),
            Move::Right(d) => (d, 1, 0),
        };
        (0..d)
            .map(|_| {
                s.rope[0].0 += x;
                s.rope[0].1 += y;
                s.move_all_tail(size);
                s.rope[size - 1]
            })
            .collect()
    }
}

#[aoc_generator(day9)]
pub fn input_generator(input: &str) -> Vec<Move> {
    input.lines().map(|l| l.parse().unwrap()).collect()
}

#[aoc(day9, part1)]
pub fn part1(input: &[Move]) -> usize {
    let mut hs: HashSet<XY> = HashSet::new();
    let mut state = State { rope: [(0, 0); 10] };
    for m in input {
        for tail in m.apply(&mut state, 2) {
            hs.insert(tail);
        }
    }
    hs.len()
}

#[aoc(day9, part2)]
pub fn part2(input: &[Move]) -> usize {
    let mut hs: HashSet<XY> = HashSet::new();
    let mut state = State { rope: [(0, 0); 10] };
    for m in input {
        for tail in m.apply(&mut state, 10) {
            hs.insert(tail);
        }
    }
    hs.len()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2";

    const EXAMPLE2: &str = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(&EXAMPLE1)), 13);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(&EXAMPLE2)), 36);
    }
}
