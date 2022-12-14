use std::collections::HashSet;

type Point = (usize, usize);
type Path = Vec<Point>;
type Abyss = (HashSet<Point>, usize);

#[aoc_generator(day14)]
pub fn input_generator(input: &str) -> Abyss {
    let mut y_max = 0;
    let mut abyss: HashSet<Point> = HashSet::new();
    for path in input.lines() {
        for line in path
            .split(" -> ")
            .map(|c| {
                let (a, b) = c.split_once(",").unwrap();
                (a.parse::<usize>().unwrap(), b.parse::<usize>().unwrap())
            })
            .collect::<Path>()
            .windows(2)
        {
            let mut start = line[0];
            let mut end = line[1];
            if start.0 > end.0 || start.1 > end.1 {
                (start, end) = (end, start);
            }
            for i in start.0..=end.0 {
                for j in start.1..=end.1 {
                    abyss.insert((i, j));
                }
            }
            if y_max < end.1 {
                y_max = end.1
            }
        }
    }
    (abyss, y_max)
}

#[aoc(day14, part1)]
pub fn part1((abyss, y_max): &Abyss) -> usize {
    let mut abyss = abyss.clone();
    let mut count = 0;
    let mut p: Point = (500, 0);
    while p.1 < *y_max {
        if !abyss.contains(&(p.0, p.1 + 1)) {
            p = (p.0, p.1 + 1);
        } else {
            if !abyss.contains(&(p.0 - 1, p.1 + 1)) {
                p = (p.0 - 1, p.1 + 1);
            } else if !abyss.contains(&(p.0 + 1, p.1 + 1)) {
                p = (p.0 + 1, p.1 + 1);
            } else {
                abyss.insert(p);
                p = (500, 0);
                count += 1;
            }
        }
    }
    count
}

// would be nice to have if from bottom to top instead
#[aoc(day14, part2)]
pub fn part2((abyss, y_max): &Abyss) -> usize {
    let mut abyss = abyss.clone();
    let mut count = 0;
    let mut p: Point = (500, 0);
    while !abyss.contains(&(500, 0)) {
        if p.1 == 1 + *y_max {
            abyss.insert(p);
            p = (500, 0);
            count += 1;
        } else if !abyss.contains(&(p.0, p.1 + 1)) {
            p = (p.0, p.1 + 1);
        } else {
            if !abyss.contains(&(p.0 - 1, p.1 + 1)) {
                p = (p.0 - 1, p.1 + 1);
            } else if !abyss.contains(&(p.0 + 1, p.1 + 1)) {
                p = (p.0 + 1, p.1 + 1);
            } else {
                abyss.insert(p);
                p = (500, 0);
                count += 1;
            }
        }
    }
    count
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(&EXAMPLE1)), 24);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(&EXAMPLE1)), 93);
    }
}
