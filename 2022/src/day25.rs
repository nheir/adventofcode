fn snafu_to_dec(input: &str) -> i64 {
    input
        .chars()
        .map(|c| match c {
            '0' => 0,
            '1' => 1,
            '2' => 2,
            '-' => -1,
            '=' => -2,
            _ => unreachable!(),
        })
        .fold(0, |a, b| a * 5 + b)
}

fn dec_to_snafu(n: i64) -> String {
    let mut v = vec![];
    let mut n = n;
    while n != 0 {
        let r = n % 5;
        n = n / 5;
        if r > 2 {
            n += 1;
            v.push(r - 5);
        } else {
            v.push(r);
        }
    }
    v.iter()
        .map(|v| match v {
            0 => '0',
            1 => '1',
            2 => '2',
            -1 => '-',
            -2 => '=',
            _ => unreachable!(),
        })
        .rev()
        .collect::<String>()
}

#[aoc(day25, part1)]
pub fn part1(input: &str) -> String {
    dec_to_snafu(input.lines().map(snafu_to_dec).sum())
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122";

    #[test]
    fn part_example() {
        assert_eq!(part1(EXAMPLE), "2=-1=0");
    }

}
