use std::collections::HashSet;

#[aoc(day6, part1)]
pub fn part1(input: &str) -> usize {
    for c in 0..input.len() - 4 {
        let mut hs = HashSet::new();
        for i in input[c..c + 4].bytes() {
            hs.insert(i);
        }
        if hs.len() == 4 {
            return c + 4;
        }
    }
    0
}

#[aoc(day6, part2)]
pub fn part2(input: &str) -> usize {
    for c in 0..input.len() - 14 {
        let mut hs = HashSet::new();
        for i in input[c..c + 14].bytes() {
            hs.insert(i);
        }
        if hs.len() == 14 {
            return c + 14;
        }
    }
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_examples() {
        assert_eq!(part1("bvwbjplbgvbhsrlpgdmjqwftvncz"), 5);
        assert_eq!(part1("nppdvjthqldpwncqszvftbrmjlhg"), 6);
        assert_eq!(part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 10);
        assert_eq!(part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 11);
    }

    #[test]
    fn part2_examples() {
        assert_eq!(part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 19);
        assert_eq!(part2("bvwbjplbgvbhsrlpgdmjqwftvncz"), 23);
        assert_eq!(part2("nppdvjthqldpwncqszvftbrmjlhg"), 23);
        assert_eq!(part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 29);
        assert_eq!(part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 26);
    }
}
