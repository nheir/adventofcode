type Round = (i32, i32);

#[aoc_generator(day2)]
pub fn input_generator(input: &str) -> Vec<Round> {
    input
        .lines()
        .map(|l| {
            let mut round = l.trim().split(' ');
            (
                match round.next().unwrap() {
                    "A" => 0,
                    "B" => 1,
                    "C" => 2,
                    _ => unreachable!(),
                },
                match round.next().unwrap() {
                    "X" => 0,
                    "Y" => 1,
                    "Z" => 2,
                    _ => unreachable!(),
                },
            )
        })
        .collect()
}

#[aoc(day2, part1)]
pub fn solve_part1(input: &[Round]) -> i32 {
    input
        .iter()
        .map(|&(a, x)| {
            if a == x {
                x + 3 + 1
            } else if (a + 1) % 3 == x {
                x + 6 + 1
            } else {
                x + 1
            }
        })
        .sum()
}

#[aoc(day2, part2)]
pub fn solve_part2(input: &[Round]) -> i32 {
    input
        .iter()
        .map(|&(a, x)| {
            if 0 == x {
                (a + 2) % 3 + 1
            } else if 1 == x {
                a + 3 + 1
            } else {
                (a + 1) % 3 + 6 + 1
            }
        })
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
}
