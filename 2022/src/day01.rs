fn parse(input: &str) -> impl Iterator<Item = u32> + '_ {
    input
        .split("\n\n")
        .map(|block| block.lines().map(|l| l.parse::<u32>().unwrap()).sum())
}

#[aoc(day1, part1)]
pub fn part1_chars(input: &str) -> u32 {
    parse(input).max().unwrap()
}

#[aoc(day1, part2)]
pub fn part2_chars(input: &str) -> u32 {
    let mut best = (0,0,0);

    for s in parse(input) {
        if s > best.0 {
            best = (s, best.0, best.1);
        } else if s > best.1 {
            best = (best.0, s, best.1);
        } else if s > best.2 {
            best = (best.0, best.1, s);
        }
    }
    best.0 + best.1 + best.2
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";

    #[test]
    fn part1_example() {
        assert_eq!(part1_chars(EXAMPLE), 24000);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2_chars(EXAMPLE), 45000);
    }
}
