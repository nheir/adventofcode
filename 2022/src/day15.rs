use std::{collections::HashSet, str::FromStr};

type Point = (i32, i32);
type Row = (Point, Point);

fn is_not_numeric(c: char) -> bool {
    !c.is_numeric() && c != '-'
}

fn numbers<T: FromStr>(s: &str, sep: fn(char) -> bool) -> Vec<T> {
    s.split(sep)
        .map(|s| s.parse::<T>())
        .filter(|n| match n {
            Ok(_) => true,
            _ => false,
        })
        .map(|n| match n {
            Ok(v) => v,
            _ => unreachable!(),
        })
        .collect()
}

#[aoc_generator(day15)]
pub fn input_generator(input: &str) -> Vec<Row> {
    input
        .lines()
        .map(|l| {
            let v = numbers(l, is_not_numeric);
            ((v[0], v[1]), (v[2], v[3]))
        })
        .collect()
}

fn manhatan(a: &Point, b: &Point) -> u32 {
    a.0.abs_diff(b.0) + a.1.abs_diff(b.1)
}

fn inter(y: i32, (x_s, y_s, d_s): (i32, i32, u32)) -> (i32, i32, i32) {
    let delta = (y_s - y).abs();
    (y_s, x_s + delta - d_s as i32, x_s - delta + d_s as i32)
}

fn line(y: i32, rows: &[Row]) -> Vec<(i32, i32, i32)> {
    let mut win: Vec<(i32, i32, i32)> = rows
        .iter()
        .map(|(s, b)| inter(y, (s.0, s.1, manhatan(s, b))))
        .collect();
    win.sort_by_key(|&(_, x, _)| x);
    win
}

fn count_positions(input: &[Row], y: i32) -> i32 {
    let mut count = 0;
    let mut x = -y;
    for (_, x_min, x_max) in line(y, input) {
        if x_min <= x_max {
            if x < x_min {
                x = x_min
            }
            if x <= x_max {
                count += x_max - x + 1;
                x = x_max + 1;
            }
        }
    }
    let mut xs = HashSet::new();
    for &(_, (xb, yb)) in input {
        if yb == y {
            xs.insert(xb);
        }
    }
    count - xs.len() as i32

}

#[aoc(day15, part1)]
pub fn solve_part1(input: &[Row]) -> i32 {
    count_positions(input, 2000000)
}

fn find_beacon(input: &[Row], max: i32) -> i64 {
    let mut win_s: Vec<(i32, i32, i32)> = line(0, input);
    for y in 0..max {
        win_s.sort_by_key(|&(_, x, _)| x);
        let mut x = 0;
        for &(_, x_min, x_max) in &win_s {
            if x_min <= x_max {
                if x < x_min {
                    return 4000000 * (x as i64) + (y as i64);
                }
                if x <= x_max {
                    x = x_max + 1;
                }
            }
            if x > max {
                break;
            }
        }
        win_s = win_s
            .iter()
            .map(|&(y_s, x_min, x_max)| {
                let delta = if y < y_s { -1 } else { 1 };
                (y_s, x_min + delta, x_max - delta)
            })
            .collect();
    }
    0
}

#[aoc(day15, part2)]
pub fn solve_part2(input: &[Row]) -> i64 {
    find_beacon(input, 4000000)
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3";

    #[test]
    fn part1_example() {
        assert_eq!(count_positions(&input_generator(&EXAMPLE), 10), 26);
    }

    #[test]
    fn part2_example() {
        assert_eq!(find_beacon(&input_generator(&EXAMPLE), 20), 56000011);
    }
}
