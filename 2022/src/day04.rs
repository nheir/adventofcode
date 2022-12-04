#[aoc_generator(day4)]
pub fn input_generator(input: &str) -> Vec<((u32, u32), (u32, u32))> {
    input
        .lines()
        .map(|l| {
            let mut a = l.split(",");
            let (l, r) = (a.next().unwrap(), a.next().unwrap());
            let mut li = l.split("-");
            let mut ri = r.split("-");
            (
                (
                    li.next().unwrap().parse().unwrap(),
                    li.next().unwrap().parse().unwrap(),
                ),
                (
                    ri.next().unwrap().parse().unwrap(),
                    ri.next().unwrap().parse().unwrap(),
                ),
            )
        })
        .collect()
}

#[aoc(day4, part1)]
pub fn part1(input: &Vec<((u32, u32), (u32, u32))>) -> u32 {
    input
        .iter()
        .map(|((a, b), (c, d))| {
            if a <= c && d <= b {
                1
            } else if c <= a && b <= d {
                1
            } else {
                0
            }
        })
        .sum()
}

#[aoc(day4, part2)]
pub fn part2(input: &Vec<((u32, u32), (u32, u32))>) -> u32 {
    input
        .iter()
        .map(|((a, b), (c, d))| if b < c || d < a { 0 } else { 1 })
        .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 2);
    }
    #[test]
    fn part2_examples() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 4);
    }
}
