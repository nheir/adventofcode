type Round = (u8, u8);

#[aoc_generator(day2)]
pub fn input_generator(input: &str) -> Vec<Round> {
    input
        .lines()
        .map(|l| {
            let (left, right) = l.trim().split_once(' ').unwrap();
            (
                left.bytes().nth(0).unwrap() - b'A',
                right.bytes().nth(0).unwrap() - b'X',
            )
        })
        .collect()
}

#[aoc(day2, part1)]
pub fn solve_part1(input: &[Round]) -> i32 {
    input
        .iter()
        .map(|&(a, x)| match (3 + a - x) % 3 {
            0 => x + 3 + 1,
            1 => x + 6 + 1,
            _ => x + 1,
        } as i32)
        .sum()
}

#[aoc(day2, part2)]
pub fn solve_part2(input: &[Round]) -> i32 {
    input
        .iter()
        .map(|&(a, x)| match x {
            0 => (a + 2) % 3 + 1,
            1 => a + 3 + 1,
            _ => (a + 1) % 3 + 6 + 1,
        } as i32)
        .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "A Y
B X
C Z";

    #[test]
    fn part1_example() {
        assert_eq!(solve_part1(&input_generator(&EXAMPLE)), 15);
    }

    #[test]
    fn part2_example() {
        assert_eq!(solve_part2(&input_generator(&EXAMPLE)), 12);
    }
}
