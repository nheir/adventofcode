use std::{num::ParseIntError, str::FromStr};

enum Inst {
    Noop,
    Addx(i32),
}

impl FromStr for Inst {
    type Err = ParseIntError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s.starts_with("noop") {
            Ok(Inst::Noop)
        } else {
            let (_a, b) = s.split_once(" ").unwrap();
            let v = b.parse().unwrap();
            Ok(Inst::Addx(v))
        }
    }
}

#[derive(Debug)]
struct State {
    x: i32,
    cycle: i32,
}

#[aoc(day10, part1)]
pub fn part1(input: &str) -> i32 {
    let mut state = State { x: 1, cycle: 0 };
    let mut count = 0;
    for inst in input.lines().map(|l| l.parse::<Inst>().unwrap()) {
        let (dx, dc) = match inst {
            Inst::Noop => (0, 1),
            Inst::Addx(v) => (v, 2),
        };
        for i in 1..dc + 1 {
            if (i + state.cycle + 20) % 40 == 0 {
                count += state.x * (i + state.cycle) as i32;
            }
        }
        state.x += dx;
        state.cycle += dc;
    }
    count
}

#[aoc(day10, part2)]
pub fn part2(input: &str) -> String {
    let mut state = State { x: 1, cycle: 0 };
    let mut grid = vec![];
    for _ in 0..6 {
        let mut v = [b'.'; 41].to_vec();
        v[40] = b'\n';
        grid.push(v);
    }
    for inst in input.lines().map(|l| l.parse::<Inst>().unwrap()) {
        let (dx, dc) = match inst {
            Inst::Noop => (0, 1),
            Inst::Addx(v) => (v, 2),
        };
        for i in 0..dc {
            let c = state.cycle + i;
            let col = c % 40;
            let lin = c / 40;
            if state.x - 1 <= col && col <= state.x + 1 {
                grid[lin as usize][col as usize] = b'#';
            }
        }
        state.x += dx;
        state.cycle += dc;
    }
    String::from_utf8(grid.concat()).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&EXAMPLE1), 13140);
    }

    #[test]
    fn part2_example() {
        assert_eq!(
            part2(&EXAMPLE1),
            "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
"
        );
    }
}
